//
//  GuideVue.swift
//  PetHood
//
//  Created by MacPro on 2024/9/3.
//

import UIKit
import RxSwift

class GuideVue: UIView {
    
    
    let disposeBag = DisposeBag()
    var bindClick : (() -> Void)?
    var cancelClick : (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        
    }
    
    private func setupUI() {
        
        let topLabel = UILabel()
            .txtFont(UIFont.systemFont(ofSize: 28, weight: .medium))
            .txtColor(UIColor(rgb: 0x000000))
            .txt("HELLO\n欢迎来到PETHOOD")
            .lines(0)
        topLabel.add2(self).lyt { make in
            make.top.equalTo(DHPXSW(s: 50))
            make.left.equalTo(DHPXSW(s: 20))
            make.right.equalTo(DHPXSW(s: -20))
        }
        
        let qrImgv = UIImageView(imgName: "guide_qr")
        qrImgv.add2(self).lyt { make in
            make.top.equalTo(topLabel.snp.bottom).offset(DHPXSW(s: 42))
            make.centerX.equalTo(self.snp.centerX)
            make.size.equalTo(CGSize(width: DHPXSW(s: 289), height: DHPXSW(s: 132)))
        }
        
        let bindButton = UIButton(type: .custom)
            .title("扫一扫绑定定位器", for: .normal)
            .titleColor(.white, for: .normal)
            .bgColor(UIColor(rgb: 0x4C96FF))
            .titleFont(UIFont.systemFont(ofSize: 18, weight: .regular))
        
        bindButton.add2(self).lyt { make in
            make.top.equalTo(qrImgv.snp.bottom).offset(DHPXSW(s: 76))
            make.left.equalTo(topLabel.snp.left)
            make.right.equalTo(topLabel.snp.right)
            make.height.equalTo(48)
        }.cornerRadius(24)
        
        
        let cancelButton = UIButton(type: .custom)
            .title("暂不绑定", for: .normal)
            .titleColor(UIColor(rgb: 0x000000), for: .normal)
            .bgColor(UIColor(rgb: 0xffffff))
            .titleFont(UIFont.systemFont(ofSize: 14, weight: .light))
        
        cancelButton.add2(self).lyt { make in
            make.top.equalTo(bindButton.snp.bottom).offset(DHPXSW(s: 10))
            make.left.equalTo(bindButton.snp.left)
            make.right.equalTo(bindButton.snp.right)
            make.height.equalTo(48)
        }
        
        bindButton.rx.tap.subscribe { [weak self] _ in
            print("扫一扫")
            if self?.bindClick != nil {
                self?.bindClick!()
            }
            
            
        }.disposed(by: disposeBag)
        
        cancelButton.rx.tap.subscribe { [weak self] _ in
            print("暂不绑定")
            if self?.cancelClick != nil {
                self?.cancelClick!()
            }
        }.disposed(by: disposeBag)
        
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
