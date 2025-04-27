//
//  CustomAlertView.swift
//  PetHood
//
//  Created by MacPro on 2024/7/16.
//

import UIKit

class CustomAlertView: UIView {
    
    @objc var okClosure:(() -> Void)?
    
    private var bgVue = UIView().bgColor(.white).cornerRadius(DHPXSW(s: 16))
    private var topImgV = UIImageView()//imgName: "lookfor_alert_top_image"
    private var titleLabel = UILabel()
        .txtFont(UIFont.systemFont(ofSize: DHPXSW(s: 20), weight: .bold))
        .txtColor(UIColor.color(hex: 0x000000))
//        .txt("寻宠模式")
    
    private var messageLabel = UILabel()
        .txtFont(UIFont.systemFont(ofSize: 16, weight: .light))
        .txtColor(UIColor.color(hex: 0x000000))
//        .txt("设备将调用一切数据全力协助您找回「霸总莱德」。寻宠模式开启后将保持打开，直至您手动关闭！")
        .lines(0)
    
    private var tipsLabel = UILabel()
        .txtFont(UIFont.systemFont(ofSize: 16, weight: .light))
        .txtColor(UIColor.color(hex: 0x666666))
//        .txt("*此模式下功耗较大，当前电量可维持20分钟")
        .lines(0)
    
    private var okButton = UIButton(type: .custom)
        .titleFont(UIFont.systemFont(ofSize: 16, weight: .regular))
        .titleColor(UIColor.color(hex: 0xffffff), for: .normal)
        .bgColor(UIColor.color(hex: 0x4C96FF))
        .cornerRadius(DHPXSW(s: 24))
        
//        .title("开启寻宠", for: .normal)
    
    private var cancelButton = UIButton(type: .custom)
        .titleFont(UIFont.systemFont(ofSize: DHPXSW(s: 16), weight: .light))
        .titleColor(UIColor.color(hex: 0x666666), for: .normal)
//        .title("取消", for: .normal)
    private var bgSize = CGSize(width: 100, height: 100)
    private var hiddenCancel : Bool? = false
    
    private var rightCloseButton = UIButton(type: .custom)
        .img(UIImage(named: "alert_close_button_icon"), for: .normal)

    
    
    init(frame:CGRect? , title:String? = "" , message:String? = "" , tip:String? = "" , topImage:String? = "" , okTitle:String? = "" , okBorderColor:UIColor? = nil , cancelTitle:String? = "" , rightShow:Bool? = false) {
        super.init(frame: .zero)
        
        bgSize = frame?.size ?? CGSize(width: DHPXSW(s: 308), height: DHPXSW(s: 100))
        hiddenCancel = cancelTitle?.isEmpty
        
        addAllSubviews()
        
        titleLabel.txt(title ?? "")
        titleLabel.isHidden = title?.isEmpty ?? true

        
        messageLabel.txt(message ?? "")
        messageLabel.isHidden = message?.isEmpty ?? true
        
        tipsLabel.txt(tip ?? "")
        tipsLabel.isHidden = tip?.isEmpty ?? true
        
        topImgV.img(UIImage(named: topImage ?? ""))
        topImgV.isHidden = topImage?.isEmpty ?? true
        
        
        okButton.title(okTitle ?? "", for: .normal)
        okButton.isHidden = okTitle?.isEmpty ?? true
        
        cancelButton.title(cancelTitle ?? "", for: .normal)
        cancelButton.isHidden = cancelTitle?.isEmpty ?? true
        
        rightCloseButton.isHidden = !(rightShow ?? false)
        
       
        guard let borderColor = okBorderColor else{
            return
        }
        okButton.borderColor(borderColor)
            .borderWidth(1)
            .titleColor(borderColor)
            .bgColor(.white)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addAllSubviews()
    }
    
    func addAllSubviews() {
        backgroundColor = UIColor.color(hex: 0x000000, alpha: 0.4)
        
        [bgVue , topImgV  ,titleLabel , messageLabel ,tipsLabel , okButton , cancelButton , rightCloseButton].forEach {
            addSubview($0)
        }
        okButton.addTarget(self, action: #selector(lookAction), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        rightCloseButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
    }
    
    @objc private  func lookAction() {
        okClosure?()
        dismiss()
    }
    @objc  func closeAction() {
        dismiss()
        
    }
    
    override func layoutSubviews() {
        bgVue.lyt { make in
            make.center.equalTo(self.center)
            make.width.equalTo(bgSize.width)
            make.height.equalTo(bgSize.height)
        }
        topImgV.lyt { make in
            make.bottom.equalTo(bgVue.snp.top).offset(DHPXSW(s: 78 / 2.0))
            make.centerX.equalTo(bgVue.snp.centerX)
        }
        
        titleLabel.lyt { make in
            make.top.equalTo( topImgV.isHidden ? bgVue.snp.top : topImgV.snp.bottom).offset(DHPXSW(s: topImgV.isHidden ? 24 : 12))
            make.centerX.equalTo(bgVue.snp.centerX)
        }
        
        messageLabel.lyt { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(DHPXSW(s: 16))
//            make.centerX.equalTo(self.centerX)
            make.left.equalTo(bgVue.snp.left).offset(DHPXSW(s: 24))
            make.right.equalTo(bgVue.snp.right).offset(DHPXSW(s: -24))
        }
        
        tipsLabel.lyt { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(DHPXSW(s: 8))
//            make.centerX.equalTo(self.centerX)
            make.left.equalTo(messageLabel.snp.left)
            make.right.equalTo(messageLabel.snp.right)
        }
        
        cancelButton.lyt { make in
//            make.centerX.equalTo(self.centerX)
            make.left.equalTo(messageLabel.snp.left)
            make.right.equalTo(messageLabel.snp.right)
            make.bottom.equalTo(bgVue.snp.bottom).offset(DHPXSW(s: -8))
            make.height.equalTo(DHPXSW(s: hiddenCancel! ? 0 : 40))
        }
        
        okButton.lyt { make in
//            make.centerX.equalTo(self.centerX)
            make.left.equalTo(messageLabel.snp.left)
            make.right.equalTo(messageLabel.snp.right)
            make.bottom.equalTo(cancelButton.snp.top).offset(DHPXSW(s: -8))
            make.height.equalTo(DHPXSW(s: 48))
        }
        
        rightCloseButton.lyt { make in
            make.top.equalTo(bgVue.snp.top).offset(DHPXSW(s: 8))
            make.right.equalTo(bgVue.snp.right).offset(DHPXSW(s: -8))
            make.size.equalTo(CGSize(width: DHPXSW(s: 30), height: DHPXSW(s: 30)))
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}


extension CustomAlertView {
    func show() {
        guard let window = UIApplication.shared.windows.first else{return}
        window.addSubview(self)
        self.add2(window).lyt { make in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0  ))
        }
       
    }
    
    func dismiss() {
        self.removeFromSuperview()
    }
}




class CusomCloseAlertView {
    
}
