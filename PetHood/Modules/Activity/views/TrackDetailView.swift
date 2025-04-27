//
//  TrackDetailView.swift
//  PetHood
//
//  Created by MacPro on 2024/7/16.
//

import UIKit

class TrackDetailView: UIView {
    
    var shareClosure:(()->Void)?
    
    private var isShare : Bool? = false
    
    private var topImagView = UIImageView().bgColor(.red)
    private var acvatorImagView = UIImageView().bgColor(.green).cornerRadius(DHPXSW(s: 22))
    private var nickNameLabel = UILabel()
        .txtFont(UIFont.systemFont(ofSize: DHPXSW(s: 16), weight: .medium))
        .txtColor(UIColor.color(hex: 0x000000))
    private var timeLabel = UILabel()
        .txtFont(UIFont.systemFont(ofSize: DHPXSW(s: 12), weight: .light))
        .txtColor(UIColor.color(hex: 0x666666))
    
    private var distanceVue = TrackDetailDataItemVue()
    private var timeVue = TrackDetailDataItemVue()
    private var eneryVue = TrackDetailDataItemVue()
    private var stepVue = TrackDetailDataItemVue()
    private var gradLayer = CAGradientLayer()
    
    private var shareImagView = UIImageView(image: UIImage(named: "report_share_top_image"))
    private var shareButton = UIButton(type: .custom)
        .bgColor(UIColor.color(hex: 0x4C96FF))
        .cornerRadius(DHPXSW(s: 28))
        .title(" 分享", for: .normal)
        .titleColor(.white, for: .normal)
        .titleFont(UIFont.systemFont(ofSize: DHPXSW(s: 18), weight: .medium))
        .img(UIImage(named: "report_share_icon"),for: .normal)
        .img(UIImage(named: "report_share_icon"),for: .normal)
    
    
    
    private var lineVue = UIView().bgColor(UIColor.color(hex: 0xF7F7F7))
    private var qrImgV = UIImageView().bgColor(.blue)
    private var qrTopImgV = UIImageView(imgName: "report_share_top_image").cntMode(.scaleAspectFit)
    private var shareTitleLabel = UILabel()
        .txtFont(UIFont.systemFont(ofSize: DHPXSW(s: 14), weight: .light))
        .txtColor(UIColor.color(hex: 0x666666))
        .txt("长按二维码\n加入Pethood和我一起遛宠")
        .lines(2)
    
    
    init( _ frame:CGRect ,_ share:Bool) {
        isShare = share
        super.init(frame: frame)
        addAllSubviews()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addAllSubviews()
    }
    
    private func addAllSubviews() {
        
        addSubview(topImagView)
        
        gradLayer.colors = [UIColor.color(hex: 0xffffff, alpha: 0).cgColor , UIColor.color(hex: 0xffffff, alpha: 0.75).cgColor  , UIColor.color(hex: 0xffffff, alpha: 1.0).cgColor]
        gradLayer.locations = [0 , 0.19 , 1]
        self.layer.addSublayer(gradLayer)
        
        [acvatorImagView, nickNameLabel , timeLabel ,
         distanceVue , timeVue , stepVue , eneryVue ,
         ].forEach {
            addSubview($0)
        }
        
        if(self.isShare!) {
            //二维码
            [lineVue , qrImgV , qrTopImgV , shareTitleLabel,].forEach {
                addSubview($0)
            }
            
        } else {
            [shareButton , shareImagView,].forEach {
                addSubview($0)
            }
        }
        
        shareButton.addTarget(self, action: #selector(shareAction), for: .touchUpInside)
        
        distanceVue.config("1.24", "距离(千米)")
        timeVue.config("00:23", "时长")
        eneryVue.config("233", "消耗(千卡)")
        stepVue.config("1990", "步数")
        nickNameLabel.txt("霸道总裁")
        timeLabel.txt("2024-06-12 11:50")
        
        
    }
    
    @objc func shareAction() {
        
        shareClosure?()

    
    }
    
   
    override func layoutSubviews() {
    
        
        let y = (self.size.height / 2.0 - DHPXSW(s: 44) / 2 - DHPXSW(s: 48) - DHPXSW(s: 100))
        gradLayer.frame = CGRect(x: 0, y: y, width: self.size.width, height: self.size.height - y)
        
        topImagView.lyt { make in
            make.top.left.right.bottom.equalTo(0)
            //            make.height.equalTo(DHPXSW(s: 500))
        }
        
        acvatorImagView.lyt { make in
            make.left.equalTo(DHPXSW(s: 16))
            make.centerY.equalTo(self.snp.centerY).offset(DHPXSW(s: -50))
            make.width.height.equalTo(DHPXSW(s: 44))
        }
        nickNameLabel.lyt { make in
            make.left.equalTo(acvatorImagView.snp.right).offset(DHPXSW(s: 6))
            make.top.equalTo(acvatorImagView.snp.top).offset(DHPXSW(s: 2))
            
        }
        
        timeLabel.lyt { make in
            make.left.equalTo(nickNameLabel.snp.left)
            make.top.equalTo(nickNameLabel.snp.bottom).offset(DHPXSW(s: 4))
        }
        
        distanceVue.lyt { make in
            make.top.equalTo(acvatorImagView.snp.bottom).offset(DHPXSW(s: 26))
            make.centerX.equalTo(self.snp.centerX).offset(-self.width / 4.0)
        }
        
        timeVue.lyt { make in
            make.centerY.equalTo(distanceVue.snp.centerY)
            make.centerX.equalTo(self.snp.centerX).offset(self.width / 4.0)
        }
        
        eneryVue.lyt { make in
            make.top.equalTo(distanceVue.snp.bottom).offset(DHPXSW(s: 26))
            make.centerX.equalTo(distanceVue.snp.centerX)
        }
        
        stepVue.lyt { make in
            make.centerY.equalTo(eneryVue.snp.centerY)
            make.centerX.equalTo(timeVue.snp.centerX)
        }
        if(self.isShare! == false) {
            
            shareButton.lyt { make in
                make.left.equalTo(DHPXSW(s: 20))
                make.right.equalTo(DHPXSW(s: -20))
                make.height.equalTo(DHPXSW(s: 56))
                make.top.equalTo(eneryVue.snp.bottom).offset(DHPXSW(s: 70))
            }
            shareImagView.lyt { make in
                make.bottom.equalTo(shareButton.snp.top).offset(10)
                make.centerX.equalTo(shareButton.snp.centerX)
            }
            
        }
        
        if(self.isShare! == true ) {
            lineVue.lyt { make in
                make.top.equalTo(eneryVue.snp.bottom).offset(DHPXSW(s: 15))
                make.left.equalTo(DHPXSW(s: 20))
                make.right.equalTo(DHPXSW(s: -20))
                make.height.equalTo(1)
            }
            
            qrImgV.lyt { make in
                make.right.equalTo(DHPXSW(s: -40))
                make.top.equalTo(lineVue.snp.bottom).offset(DHPXSW(s: 40))
                make.width.height.equalTo(DHPXSW(s: 80))
            }
            
            qrTopImgV.lyt { make in
                make.bottom.equalTo(qrImgV.snp.top).offset(5)
                make.centerX.equalTo(qrImgV.snp.centerX)
                make.height.equalTo(DHPXSW(s: 30))
            }
            
            shareTitleLabel.lyt { make in
                make.left.equalTo(DHPXSW(s: 40))
                make.centerY.equalTo(qrImgV.snp.centerY).offset(DHPXSW(s: 10))
            }
        }
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


class TrackDetailDataItemVue : UIView {
    private var titleLabel =  UILabel()
        .txtFont(UIFont.systemFont(ofSize: DHPXSW(s: 32), weight: .bold))
        .txtColor(UIColor.color(hex: 0x000000))
    
    private var subTitleLabel =  UILabel()
        .txtFont(UIFont.systemFont(ofSize: DHPXSW(s: 14), weight: .light))
        .txtColor(UIColor.color(hex: 0x666666))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel.add2(self).lyt { make in
            make.left.top.equalTo(0)
            make.right.equalTo(DHPXSW(s: 0))
        }
        
        subTitleLabel.add2(self).lyt { make in
            make.left.equalTo(titleLabel.snp.left)
            make.right.equalTo(DHPXSW(s: 0))
            make.top.equalTo(titleLabel.snp.bottom).offset(DHPXSW(s: -3))
            make.bottom.equalTo(0)
        }
        
        // 设置父视图宽度约束为两个子视图宽度中的最大值
        snp.makeConstraints { make in
            make.width.equalTo(titleLabel).priority(.high)
            make.width.equalTo(subTitleLabel).priority(.high)
        }
        
        titleLabel.txt("19")
        subTitleLabel.txt("时间")
    }
    
    func config(_ title:String , _ sub:String) {
        titleLabel.txt(title)
        subTitleLabel.txt(sub)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
