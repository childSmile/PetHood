//
//  PhoneView.swift
//  PetHood
//
//  Created by MacPro on 2024/9/3.
//

import UIKit
import RxSwift

class PhoneView: UIView, UITextFieldDelegate {
    
    var nextClick:((String)->Void)?
    var protocolClick:((String?)->Void)?
    var phoneNumber:String = ""
    
    fileprivate var phoneTextField = UITextField()

    fileprivate var agreeButton = UIButton(type: .custom)
        .img(UIImage(named: "agreen_unselected"), for: .normal)
        .img(UIImage(named: "agreen_selected"), for: .selected)
    
    
    fileprivate var codeButton = UIButton(type: .custom)
        .title("获取验证码", for: .normal)
        .titleColor(.white, for: .normal)
        .titleColor(.white.withAlphaComponent(0.6), for: .disabled)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        let topLabel = UILabel()
            .txtFont(UIFont.systemFont(ofSize: 28, weight: .medium))
            .txtColor(UIColor(rgb: 0x000000))
            .txt("手机号登录/注册")
        topLabel.add2(self).lyt { make in
            make.top.equalTo(DHPXSW(s: 45))
            make.left.equalTo(DHPXSW(s: 20))
            make.right.equalTo(DHPXSW(s: -20))
        }
        
        let phoneVue = UIView()
            .bgColor(UIColor(rgb: 0xF3F5F9))
            .cornerRadius(DHPXSW(s: 24))
        phoneVue.add2(self).lyt { make in
            make.left.equalTo(topLabel.snp.left)
            make.right.equalTo(topLabel.snp.right)
            make.top.equalTo(topLabel.snp.bottom).offset(DHPXSW(s: 50))
            make.height.equalTo(48)
        }
        
        let prefixLabel = UILabel()
            .txtFont(UIFont.systemFont(ofSize: 18, weight: .regular))
            .txtColor(UIColor(rgb: 0x000000))
            .txt("+86")
        prefixLabel.add2(phoneVue).lyt { make in
            make.centerY.equalTo(phoneVue.snp.centerY)
            make.left.equalTo(DHPXSW(s: 16))
            make.width.equalTo(DHPXSW(s: 35))
        }
        
        let lineVue = UIView().bgColor(UIColor(rgb: 0xD8D8D8))
        lineVue.add2(phoneVue).lyt { make in
            make.centerY.equalTo(phoneVue.snp.centerY)
            make.width.equalTo(0.5)
            make.height.equalTo(20)
            make.left.equalTo(prefixLabel.snp.right).offset(8)
        }
        
        phoneTextField.add2(phoneVue).lyt { make in
            make.centerY.equalTo(phoneVue.snp.centerY)
            make.left.equalTo(lineVue.snp.right).offset(DHPXSW(s: 8))
            make.right.equalTo(phoneVue.snp.right).offset(DHPXSW(s: -8))
        }
        
        let att = NSAttributedString(string: "请输入手机号", attributes: [.foregroundColor : UIColor.lightGray , .font : UIFont.systemFont(ofSize: 16, weight: .light)])
        phoneTextField.attributedPlaceholder = att
        phoneTextField.textColor = UIColor(rgb: 0x000000)
        phoneTextField.keyboardType = .numberPad
        
        
        codeButton.add2(self).lyt { make in
            make.top.equalTo(phoneVue.snp.bottom).offset(DHPXSW(s: 16))
            make.left.equalTo(phoneVue.snp.left)
            make.right.equalTo(phoneVue.snp.right)
            make.height.equalTo(48)
        }.cornerRadius(24)
            .bgImg(UIImage.creatImage(color: UIColor(rgb: 0x4C96FF)), for: .normal)
            .bgImg(UIImage.creatImage(color: UIColor(rgb: 0x4C96FF).withAlphaComponent(0.6)), for: .disabled)
        
        
        agreeButton.add2(self).lyt { make in
            make.left.equalTo(topLabel.snp.left)
            make.top.equalTo(codeButton.snp.bottom).offset(DHPXSW(s: 26))
            make.size.equalTo(CGSizeMake(24, 24))
        }
        
        let agreenLabel = UILabel()
        
        agreenLabel.numberOfLines = 0
        
        // 创建NSAttributedString
        // 设置"正常"部分的属性
        let normalAttributes: [NSAttributedString.Key: Any] =
        [.font:UIFont.systemFont(ofSize: 12, weight: .light) , .foregroundColor : UIColor(rgb: 0x000000) ,]
        
        // 设置"可点击的链接"部分的属性
        let linkAttributes: [NSAttributedString.Key: Any] = [
            .font:UIFont.systemFont(ofSize: 12, weight: .light),
            .foregroundColor: UIColor(rgb: 0x4C96FF),
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        
        // 添加可点击的部分
        let linkString = "《用户协议》"
        let linkString2 = "《隐私政策》"
        
        let attributedString = NSMutableAttributedString(string: "我已阅读并同意\(linkString)和\(linkString2)" , attributes: normalAttributes)
        
        let linkRange = (attributedString.string as NSString).range(of: linkString)
        attributedString.addAttributes(linkAttributes, range: linkRange)
        
        let linkRange2 = (attributedString.string as NSString).range(of: linkString2)
        attributedString.addAttributes(linkAttributes, range: linkRange2)
        
        // 设置label的attributedText
        agreenLabel.attributedText = attributedString
        
        
        // 添加到视图
        agreenLabel.add2(self).lyt { make in
            make.left.equalTo(agreeButton.snp.right).offset(0)
            make.centerY.equalTo(agreeButton.snp.centerY)
        }
        
        
        
        ///添加事件
        agreenLabel.yb_addAttributeTapAction(with: [linkString , linkString2]) { label, string, range, index in
            print("click === \(String(describing: string))")
            if self.protocolClick != nil {
                self.protocolClick!(string)
            }
        }
        
    
        agreeButton.addTarget(self, action: #selector(agreenAction), for: .touchUpInside)
        
        codeButton.addTarget(self, action: #selector(codeAction), for: .touchUpInside)
        
        codeButton.isEnabled = false
        
        phoneTextField.delegate = self
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        phoneTextField.resignFirstResponder()
    }
    
    @objc func agreenAction() {
        agreeButton.isSelected = !agreeButton.isSelected
        codeButton.isEnabled = !phoneNumber.isEmpty && agreeButton.isSelected
    }
    @objc func codeAction() {
        if self.nextClick != nil {
            self.nextClick!(phoneNumber)
        }
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // 输入变化时会调用这里的代码
        if let text = textField.text,
           let r = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: r, with: string)
            // 在这里处理更新后的文本
            print("Updated text: \(updatedText)")
            
            if updatedText.count > 11 {
                phoneNumber = (updatedText as NSString).substring(to: 11)
                codeEnable()
                return false
                
            } else {
                phoneNumber = updatedText
            }
            
        }
        
        codeEnable()
       
        return true
    }
    
    func codeEnable()  {
        codeButton.isEnabled = (phoneNumber.count > 0) && agreeButton.isSelected
    }
    

}
