//
//  ShareBottomVue.swift
//  PetHood
//
//  Created by MacPro on 2024/7/17.
//

import UIKit

class ShareBottomVue: UIView {
    
    var shareClickClouse:((Int)->Void)?
    
    private var bgVue = UIView().bgColor(.white).cornerRadius(16)
    private var titleLabel = UILabel()
        .txt("分享到")
        .txtFont(UIFont.systemFont(ofSize: 18, weight: .bold))
        .txtColor(UIColor.color(hex: 0x000000))
    
    private var cancelButton = UIButton(type: .custom)
        .title("取消", for: .normal)
        .titleColor(UIColor.color(hex: 0x000000), for: .normal)
        .titleFont(UIFont.systemFont(ofSize: 16, weight: .light))
    
    private var lineView = UIView().bgColor(UIColor.color(hex: 0xF7F7F7))
    
    private var saveButton = ShareButton(frame: .zero)
    private var wechatButton = ShareButton(frame: .zero)

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.color(hex: 0x000000 , alpha: 0.4)
        
        bgVue.add2(self)
        
        saveButton.config("report_share_save_icon", "保存到本地")
        
        wechatButton.config("report_share_wechat_icon", "微信")
        
        [titleLabel , cancelButton , lineView , saveButton , wechatButton].forEach {
            $0.add2(bgVue)
        }
        
        saveButton.clickClouse = { [weak self] in
            self?.shareClickClouse?(0)
        }
        wechatButton.clickClouse = { [weak self] in
            self?.shareClickClouse?(1)
        }
        cancelButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        
    }
    
    @objc func dismiss() {
        removeFromSuperview()
    }
    
    
    override func layoutSubviews() {
        bgVue.lyt { make in
            make.left.right.equalTo(0)
            make.bottom.equalTo(PHDHPXscaleH(16))
            make.height.equalTo(PHDHPXscaleH(208 + 16))
        }
        
        
        titleLabel.lyt { make in
            make.centerX.equalTo(bgVue.snp.centerX)
            make.top.equalTo(DHPXSW(s: 16))
        }
        
        cancelButton.lyt { make in
            make.bottom.equalTo(DHPXSW(s: -(16 + SafeArea_Bottom())))
            make.left.right.equalTo(0)
            make.height.equalTo(PHDHPXscaleH(40))
        }
        
        lineView.lyt { make in
            make.bottom.equalTo(cancelButton.snp.top)
            make.left.right.equalTo(0)
            make.height.equalTo(4)
        }
        
        saveButton.lyt { make in
            make.centerX.equalTo(bgVue.snp.centerX).offset(DHPXSW(s: -(25 + 48 / 2)))
            make.bottom.equalTo(lineView.snp.top).offset(PHDHPXscaleH(-5))
            make.width.equalTo(DHPXSW(s: 60))
        }
        
        wechatButton.lyt { make in
            make.centerX.equalTo(bgVue.snp.centerX).offset(DHPXSW(s: (25 + 48 / 2)))
            make.top.equalTo(saveButton.snp.top)
            make.width.equalTo(DHPXSW(s: 60))
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


class ShareButton : UIView {
    
    var clickClouse:(()->Void)?
    private var iconImgV  = UIImageView()
    private var titleLabel = UILabel()
        .txtFont(UIFont.systemFont(ofSize: DHPXSW(s: 12), weight: .light))
        .txtColor(UIColor.color(hex: 0x000000))
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        
        addAllSubviews()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        self.addGestureRecognizer(tap)
    }
    
    @objc func tapAction() {
        clickClouse?()
    }
    
    private func addAllSubviews() {
        iconImgV.add2(self).lyt { make in
            make.top.equalTo(DHPXSW(s: 15))
            make.centerX.equalTo(self.snp.centerX)
            make.size.equalTo(CGSize(width: DHPXSW(s: 48), height: DHPXSW(s: 48)))
        }
        
        titleLabel.add2(self).lyt { make in
            make.centerX.equalTo(self.snp.centerX)
            make.bottom.equalTo(DHPXSW(s: -5))
            make.top.equalTo(iconImgV.snp.bottom).offset(10)
        }
        
    }
    
    
    func config(_ icon:String  , _ title:String ) {
        iconImgV.img(UIImage(named: icon))
        titleLabel.txt(title)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
