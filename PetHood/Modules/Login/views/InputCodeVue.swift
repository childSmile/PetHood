//
//  InputCodeVue.swift
//  PetHood
//
//  Created by MacPro on 2024/9/3.
//

import UIKit
import RxSwift

class InputCodeVue: UIView {
    
    let disposeBag = DisposeBag()
    
    var buttonClick:(() -> Void)?
    var backClick:(() -> Void)?
    var code : String = ""
    
    fileprivate var phoneNumber:String = ""
    fileprivate var codeButton = UIButton(type: .custom)
        .title("获取验证码", for: .normal)
        .titleColor(.white, for: .normal)
        .titleColor(.white.withAlphaComponent(0.6), for: .disabled)
    
     init(frame: CGRect , phone:String? = "") {
        super.init(frame: frame)
        phoneNumber = phone ?? ""
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        let back = UIButton(type: .custom)
            .img(UIImage(named: "back_arrow_icon"))
        
        back.add2(self).lyt { make in
            make.left.equalTo(DHPXSW(s: 16))
            make.top.equalTo(DHPXSW(s: 16))
            make.width.equalTo(DHPXSW(s: 44))
            make.height.equalTo(DHPXSW(s: 30))
        }
        
        let topLabel = UILabel()
            .txtFont(UIFont.systemFont(ofSize: 28, weight: .medium))
            .txtColor(UIColor(rgb: 0x000000))
            .txt("输入验证码")
        topLabel.add2(self).lyt { make in
            make.top.equalTo(DHPXSW(s: 52))
            make.left.equalTo(DHPXSW(s: 20))
            make.right.equalTo(DHPXSW(s: -20))
        }
        
        let subLabel = UILabel()
            .txtFont(UIFont.systemFont(ofSize: 14, weight: .light))
            .txtColor(UIColor(rgb: 0x000000))
            .txt("已发送6位验证码至 +86 \(phoneNumber)")
        subLabel.add2(self).lyt { make in
            make.top.equalTo(topLabel.snp.bottom).offset(8)
            make.left.equalTo(DHPXSW(s: 20))
            make.right.equalTo(DHPXSW(s: -20))
        }
       
        let codeLength = 6
        let codeVue = CodeView.init(frame: CGRect.init(x: DHPXSW(s: 20), y: 0, width: PHMaxScreenSizeWidth() - DHPXSW(s: 20 * 2), height: 48),codeNumber: codeLength,style: .CodeStyle_border , mainColor: UIColor(rgb: 0x4C96FF) , normalColor:  UIColor(rgb: 0xF3F5F9) , margin:16)
        codeVue.codeBlock = { [weak self] code in
            print("\n\n=======>您输入的验证码是：\(code)")
            self?.code = code
            self?.codeButton.isEnabled = code.count == codeLength
        }
        
        codeVue.add2(self).lyt { make in
            make.left.equalTo(topLabel.snp.left)
            make.right.equalTo(topLabel.snp.right)
            make.top.equalTo(topLabel.snp.bottom).offset(DHPXSW(s: 50))
            make.height.equalTo(48)
        }
        codeVue.labelTextColor = UIColor(rgb: 0x000000)
        
        
        codeButton.add2(self).lyt { make in
            make.top.equalTo(codeVue.snp.bottom).offset(DHPXSW(s: 24))
            make.left.equalTo(codeVue.snp.left)
            make.right.equalTo(codeVue.snp.right)
            make.height.equalTo(48)
        }.cornerRadius(24)
            .bgImg(UIImage.creatImage(color: UIColor(rgb: 0x4C96FF)), for: .normal)
            .bgImg(UIImage.creatImage(color: UIColor(rgb: 0x4C96FF).withAlphaComponent(0.6)), for: .disabled)
        codeButton.isEnabled = false
        
        codeButton.rx.tap.subscribe {[weak self] _ in
            if self?.buttonClick != nil {
                self?.buttonClick!()
            }
            
        }.disposed(by: disposeBag)
        
        back.rx.tap.subscribe {[weak self] _ in
            if self?.backClick != nil {
                self?.backClick!()
            }
            
        }.disposed(by: disposeBag)
        
    
 
        
    }
    

}
