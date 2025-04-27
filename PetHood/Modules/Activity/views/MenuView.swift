//
//  MenuView.swift
//  PetHood
//
//  Created by MacPro on 2024/7/9.
//

import UIKit
import SnapKitExtend
import RxSwift
import RxCocoa




enum PetActivity {
    case WalkPet
    case LookforPet
    case TripPet
    case TrackPet
    
    var title:String {
        switch self {
        case .WalkPet:
            return "遛宠"
        case .LookforPet:
            return "寻宠"
        case .TripPet:
            return "出行"
        case .TrackPet:
            return "轨迹"
        }
    }
    
    var icon:String {
        switch self {
        case .WalkPet:
            return "walk_pet_icon"
        case .LookforPet:
            return "lookfor_pet_icon"
        case .TripPet:
            return "trip_pet_icon"
        case .TrackPet:
            return "track_pet_icon"
        }
    }
   
    
}

class MenuView: UIView {
    
    var menuType:PetActivity?
    var tapClick:((PetActivity) -> Void)?
    var naviClick:(() -> Void)?
    var closeClick:(() -> Void)?
    var inputClick:(() -> Void)?
    var stopTripClick:(() -> Void)?
    
    var buttonType:PetActivity = .WalkPet
    
    var online: Bool {
        get {
            return _online
        }
        set(newValue) {
            _online = newValue
            if itemViews.count == 0 {return}
            for i in 0..<itemViews.count - 1 {
                let v  = itemViews[i]
                v.online = newValue
            }
            
        }
    }
    
    private var _online :Bool = false

    init(type:PetActivity) {
        menuType = type
        super.init(frame: .zero)
        addAllSubviews();
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addAllSubviews();
    }
    
    private func addAllSubviews() {
        
        bgVue.add2(self)
        
        [photoImgV, nickLabel,deviceVue].forEach { bgVue.addSubview($0) }
        
        guard let type = menuType else {
            [addressLabel, updateTimeLabel].forEach { bgVue.addSubview($0) }
            addActions()
            return
        }
        if(type == .LookforPet) {
            
            [tipLabel,addressLabel, updateTimeLabel,closeButton,naviButton].forEach { bgVue.addSubview($0)}
            naviButton.addTarget(self, action: #selector(naviAction), for: .touchUpInside)
            closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        }
        
        if(type == .TripPet) {
            
            [tipLabel,startPointLabel ,  endPointLabel, tripButton,  stopTripButton].forEach { bgVue.addSubview($0)
            }
            
            endPointLabel.isUserInteractionEnabled = true;
            let tap = UITapGestureRecognizer(actionBlock: { [self]_ in
//                print("input end");
                inputClick?()
            })
            
            stopTripButton.isHidden = true
            endPointLabel.addGestureRecognizer(tap)
            updateEndPoint(location: "请输入目的地")
            tripButton.addTarget(self, action: #selector(naviAction), for: .touchUpInside)
            stopTripButton.addTarget(self, action: #selector(stopTripAction), for: .touchUpInside)
            
        }
        
    }
    
    override func layoutSubviews() {
        bgVue.add2(self).lyt { make in
            make.left.top.equalTo(0)
            make.right.bottom.equalTo(0)
        }
        photoImgV.lyt { make in
            make.top.equalTo(DHPXSW(s: 12))
            make.left.equalTo(DHPXSW(s: 16))
            make.size.equalTo(CGSize(width: DHPXSW(s: 24), height: DHPXSW(s: 24)))
        }
        
        nickLabel.lyt { make in
            make.left.equalTo(photoImgV.snp.right).offset(DHPXSW(s: 4));
            make.centerY.equalTo(photoImgV.snp.centerY);
            make.width.lessThanOrEqualTo(DHPXSW(s: 120))
        }
        
        deviceVue.lyt { make in
            make.right.equalTo(DHPXSW(s: -12))
            make.centerY.equalTo(photoImgV.snp.centerY)
            make.height.equalTo(DHPXSW(s: 30))
        }
        
        guard let type = menuType else {
            
            addressLabel.lyt { make in
                make.top.equalTo(photoImgV.snp.bottom).offset(DHPXSW(s: 13))
                make.left.equalTo(photoImgV.snp.left)
                make.right.equalTo(bgVue.snp.right).offset(DHPXSW(s: -16))
            }
            
            updateTimeLabel.lyt { make in
                make.top.equalTo(addressLabel.snp.bottom).offset(DHPXSW(s: 3))
                make.left.equalTo(photoImgV.snp.left)
                make.right.equalTo(bgVue.snp.right).offset(DHPXSW(s: -16))
            }
            
            addActions()
            return
        }
        if(type == .LookforPet) {
            
            tipLabel.lyt { make in
                make.top.equalTo(photoImgV.snp.bottom).offset(DHPXSW(s: 13))
                make.left.equalTo(photoImgV.snp.left)
                make.right.equalTo(bgVue.snp.right).offset(DHPXSW(s: -16))
            }
            
            addressLabel.lyt { make in
                make.top.equalTo(tipLabel.snp.bottom).offset(DHPXSW(s: 13))
                make.top.equalTo(tipLabel.snp.bottom).offset(DHPXSW(s: 13))
                make.left.equalTo(photoImgV.snp.left)
                make.right.equalTo(bgVue.snp.right).offset(DHPXSW(s: -16))
            }
            
            updateTimeLabel.lyt { make in
                make.top.equalTo(addressLabel.snp.bottom).offset(DHPXSW(s: 3))
                make.left.equalTo(photoImgV.snp.left)
                make.right.equalTo(bgVue.snp.right).offset(DHPXSW(s: -16))
            }
            closeButton.lyt { make in
                //                make.top.equalTo(naviButton.snp.bottom).offset(DHPXSW(s: 5))
                make.left.equalTo(photoImgV.snp.left)
                make.right.equalTo(bgVue.snp.right).offset(DHPXSW(s: -16))
                make.height.equalTo(DHPXSW(s: 44))
                make.bottom.equalTo(DHPXSW(s: -5))
            }
            
            naviButton.lyt { make in
                //                make.top.equalTo(updateTimeLabel.snp.bottom).offset(DHPXSW(s: 16))
                make.left.equalTo(photoImgV.snp.left)
                make.right.equalTo(bgVue.snp.right).offset(DHPXSW(s: -16))
                make.height.equalTo(DHPXSW(s: 44))
                make.bottom.equalTo(closeButton.snp.top).offset(DHPXSW(s: -2))
            }
            
           
        }
        
        if(type == .TripPet) {
            
            tipLabel.lyt { make in
                make.top.equalTo(photoImgV.snp.bottom).offset(DHPXSW(s: 13))
                make.left.equalTo(photoImgV.snp.left)
                make.right.equalTo(bgVue.snp.right).offset(DHPXSW(s: -16))
            }
            startPointLabel.lyt { make in
                make.top.equalTo(tipLabel.snp.bottom).offset(DHPXSW(s: 16))
                make.left.equalTo(photoImgV.snp.left)
                make.height.equalTo(DHPXSW(s: 48))
            }
            
            
            endPointLabel.lyt { make in
                make.top.equalTo(startPointLabel.snp.bottom).offset(DHPXSW(s: 2))
                make.height.equalTo(DHPXSW(s: 48))
                make.left.equalTo(photoImgV.snp.left)
                make.right.equalTo(bgVue.snp.right).offset(DHPXSW(s: -16))
            }
            
            tripButton.lyt { make in
                make.left.equalTo(photoImgV.snp.left)
                make.right.equalTo(bgVue.snp.right).offset(DHPXSW(s: -16))
                make.height.equalTo(DHPXSW(s: 48))
                make.bottom.equalTo(DHPXSW(s: -20))
            }
            
            stopTripButton.lyt { make in
                make.bottom.equalTo(tripButton.snp.bottom)
                make.left.equalTo(tripButton.snp.left)
                make.right.equalTo(tripButton.snp.right)
                make.height.equalTo(tripButton.snp.height)
            }
        }
    }
    
    
    
    @objc private func naviAction() {
        naviClick?()
    }
    
    @objc private func closeAction() {
        closeClick?()
    }
    
    @objc private func stopTripAction() {
        stopTripClick?()
    }
    
    
    private func addActions() {
        
        for v in itemViews {
            v.removeFromSuperview()
        }
        itemViews.removeAll()
        
        let space = DHPXSW(s: 16)
        for i in 0..<types.count {
            let type = types[i]
            let itemView = MenuButton(type: type)
//            itemView.frame = CGRect(x: 0, y: 0, width: DHPXSW(s: 64), height: DHPXSW(s: 64))
            bgVue.addSubview(itemView)
            itemViews.append(itemView)
            itemView.tag = i;
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
            itemView.addGestureRecognizer(tap)

            
        }
        //        axisType:方向
        //        fixedSpacing:中间间距
        //        leadSpacing:左边距(上边距)
        //        tailSpacing:右边距(下边距)
        itemViews.snp.distributeViewsAlong(axisType: .horizontal, fixedSpacing: space, leadSpacing: space, tailSpacing: space)
        //        上面的可以约束x+w,还需要另外约束y+h
        //        约束y和height()如果方向是纵向,那么则另外需要设置x+w
        itemViews.snp.makeConstraints{
            $0.top.equalTo(updateTimeLabel.snp.bottom).offset(DHPXSW(s: 15))
//            $0.bottom.equalTo(bgVue.snp.bottom).offset(DHPXSW(s: -20))
//            $0.width.equalTo(DHPXSW(s: 64))
            $0.height.equalTo(DHPXSW(s: 64))
            
        }
        
    }
    
    
    @objc func tapAction(sender:UITapGestureRecognizer) {
        print( "menu button click : " );
        tapClick?(types[sender.view?.tag ?? 0])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func createAttributedStringWithImage(image: UIImage , font:UIFont? = UIFont.systemFont(ofSize: 14)) -> NSMutableAttributedString {
        let attachment = NSTextAttachment()
        attachment.image = image
        attachment.bounds = CGRect(x: 0, y: (font!.capHeight - image.size.height).rounded() / 2, width: image.size.width, height: image.size.height)
        let attachmentString = NSAttributedString(attachment: attachment)
        return NSMutableAttributedString(attributedString: attachmentString)
    }
     
    
    
    private var bgVue =  UIView().bgColor(.white).cornerRadius(DHPXSW(s: 16))
    private var photoImgV = UIImageView().cornerRadius(DHPXSW(s: 12)).bgColor(.red)
    private var deviceVue = DeviceInfoVue(frame: CGRect(x: 0, y: 0, width: 100, height: 100)).cornerRadius(8)
    private var nickLabel = UILabel()
        .txtFont(UIFont.systemFont(ofSize: DHPXSW(s: 16), weight: UIFont.Weight(rawValue: 700)))
        .txtColor(UIColor.black)
        .txt("霸道总霸道总裁霸道总裁霸道总裁霸道总裁霸道总裁霸道总裁裁")
    private var tipLabel = UILabel()
        .txtFont(UIFont.systemFont(ofSize: DHPXSW(s: 14), weight: .light))
        .txtColor(UIColor.color(hex: 000000))
        .txt("当前电量可维持20分钟")
        .lines(1)
    private var addressLabel = UILabel()
        .txtFont(UIFont.systemFont(ofSize: DHPXSW(s: 14), weight: .light))
        .txtColor(UIColor.color(hex: 0x3D3D3D))
        .txt("广东省广州市番禺区海外高层次人才创新567号")
        .lines(1)
    private var updateTimeLabel = UILabel()
        .txtFont(UIFont.systemFont(ofSize: DHPXSW(s: 12), weight: .light))
        .txtColor(UIColor.color(hex: 0x999999))
        .txt("5小时前")
        .lines(1)
    
    private var naviButton = UIButton()
        .titleFont(UIFont.systemFont(ofSize: 14, weight: .light))
        .titleColor(UIColor.color(hex: 0xffffff))
        .bgColor(UIColor.color(hex: 0x1B79FF))
        .cornerRadius(DHPXSW(s: 22))
        .title("导航")
    
    private var closeButton = UIButton()
        .titleFont(UIFont.systemFont(ofSize: 16, weight: .light))
        .titleColor(UIColor.color(hex: 0x000000))
        .bgColor(UIColor.color(hex: 0xffffff))
    //        .cornerRadius(DHPXSW(s: 22))
        .title("关闭寻宠模式")
    
    private var startPointLabel = UILabel()
        .txtFont(UIFont.systemFont(ofSize: DHPXSW(s: 12), weight: .light))
        .txtColor(UIColor.color(hex: 0x999999))
        .txt("宠物将从 华业大厦 出发")
        .lines(1)
    
    private var endPointLabel = UILabel()
        .txtFont(UIFont.systemFont(ofSize: DHPXSW(s: 12), weight: .light))
        .txtColor(UIColor.color(hex: 0x999999))
        .borderColor(UIColor.color(hex: 0x000000))
        .borderWidth(1)
        .cornerRadius(DHPXSW(s: 12))
        .txt("请输入宠物目的地")
        .lines(1)
    
    private var tripButton = UIButton()
        .titleFont(UIFont.systemFont(ofSize: 14, weight: .light))
        .titleColor(UIColor.color(hex: 0xffffff))
        .bgColor(UIColor.color(hex: 0x1B79FF))
        .cornerRadius(DHPXSW(s: 22))
        .title("开启宠物出行追踪")
    
    private var stopTripButton = UIButton()
        .titleFont(UIFont.systemFont(ofSize: 16, weight: .light))
        .titleColor(UIColor.color(hex: 0x4C96FF))
        .bgColor(UIColor.color(hex: 0xffffff))
        .cornerRadius(DHPXSW(s: 22))
        .borderColor(UIColor.color(hex: 0x4C96FF))
        .borderWidth(1)
        .title("结束宠物出行")
    
    private var itemViews: [MenuButton] = []
    let types:[PetActivity] = [PetActivity.WalkPet, PetActivity.LookforPet, PetActivity.TripPet, PetActivity.TrackPet]
    
}



//对外方法
extension MenuView {
    
    func configVue(pet:PetLocationModel) {
        addressLabel.txt(pet.regeocode.formattedAddress)
        online = pet.mapDeviceModel?.is_online?.intValue == 1
        let number = Int.random(in: 0..<2)
        deviceVue.config("\(number)", "\(Int.random(in: 1...3))", "\(Int.random(in: 1...4))")
        
    }
    
    func updateStartPoint(location:String) {
        guard let image = UIImage.createImg(UIColor.color(hex: 0x00DE83), with: CGSize(width: DHPXSW(s: 8), height: DHPXSW(s: 8)))?.fillet(DHPXSW(s: 4))
        else {return}
        let picAtt =  createAttributedStringWithImage(image: image , font: startPointLabel.font)
        let  att = NSMutableAttributedString()
        att.appendString("    ")
        att.append(picAtt)
        att.appendString(" ")
        att.append(NSAttributedString(string: "宠物将从 ", attributes: [.font:UIFont.systemFont(ofSize: DHPXSW(s: 12), weight: .light) , .foregroundColor:UIColor.color(hex: 0x000000)]))
        
        att.append(NSAttributedString(string: location, attributes: [.font:UIFont.systemFont(ofSize: DHPXSW(s: 12), weight: .medium) , .foregroundColor:UIColor.color(hex: 0x00DE83)]))
        
        att.append(NSAttributedString(string: " 出发", attributes: [.font:UIFont.systemFont(ofSize: DHPXSW(s: 12), weight: .light) , .foregroundColor:UIColor.color(hex: 0x000000)]))
        
        startPointLabel.attrTxt(att)
    }
    
    func updateEndPoint(location : String) {

        guard let image = UIImage.createImg(UIColor.color(hex: 0xFE4B01), with: CGSize(width: DHPXSW(s: 8), height: DHPXSW(s: 8)))?.fillet(DHPXSW(s: 4))
        else {return}
        let picAtt =  createAttributedStringWithImage(image: image , font: endPointLabel.font)
        let  att = NSMutableAttributedString()
        att.appendString("    ")
        att.append(picAtt)
        att.appendString(" ")
        att.append(NSAttributedString(string: location, attributes: [.font:UIFont.systemFont(ofSize: DHPXSW(s: 16), weight: .bold) , .foregroundColor:UIColor.color(hex: 0x000000)]))
        endPointLabel.attrTxt(att)
        
    }
    
    func startTrip() {
        if menuType != .TripPet {
            return
        }
        startPointLabel.isHidden = true
        endPointLabel.isHidden = true
        tripButton.isHidden = true
        
        stopTripButton.isHidden = false
        
    }
   
}


class MenuButton : UIView {
    
    var buttonType:PetActivity = .WalkPet
    
    var online: Bool {
        get {
            return _online
        }
        set(newValue) {
            print("MenuButton==\(newValue ? "online" : "not online")")
            _online = newValue
            self.alpha = newValue ? 1.0 : 0.4
        }
    }
    
    private var _online :Bool = false
    
    private var icon  = UIImageView()
    private var titleLabel = UILabel()
        .txtFont(UIFont.systemFont(ofSize: DHPXSW(s: 14), weight: .light))
        .txtColor(UIColor.color(hex: 0x000000))
    
    init(type:PetActivity) {
        super.init(frame: .zero)
        buttonType = type
        
        layer.cornerRadius = DHPXSW(s: 8)
        backgroundColor = UIColor.color(hex: 0xF7F7F7)
        addAllSubviews()
        
    }
    
    private func addAllSubviews() {
        icon.add2(self).lyt { make in
            make.top.equalTo(DHPXSW(s: 15))
            make.centerX.equalTo(self.snp.centerX)
            make.size.equalTo(CGSize(width: 20, height: 20))
        }
        
        titleLabel.add2(self).lyt { make in
            make.centerX.equalTo(self.snp.centerX)
            make.bottom.equalTo(DHPXSW(s: -5))
        }
        
        titleLabel.txt(buttonType.title)
        icon.img(UIImage(named: buttonType.icon))
        
    }
    
  
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
