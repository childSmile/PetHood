//
//  ProfileHeaderVue.swift
//  PetHood
//
//  Created by MacPro on 2024/9/11.
//

import UIKit



class ProfileHeaderVue: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        setupUI()
    }
    
    private func setupUI() {
        
        iconVue.add2(self).lyt { make in
            make.centerY.equalTo(self.snp.centerY)
            make.left.equalTo(DHPXSW(s: 20))
            make.size.equalTo(CGSize(width: DHPXSW(s: 54), height: DHPXSW(s: 54)))
        }.borderColor(.white)
            .borderWidth(2)
            .cornerRadius(DHPXSW(s: 27))
        
        titleVue.add2(self).lyt { make in
            make.top.equalTo(iconVue.snp.top)
            make.left.equalTo(iconVue.snp.right).offset(10)
        }
        
        subtitleVue.add2(self).lyt { make in
            make.bottom.equalTo(iconVue.snp.bottom)
            make.left.equalTo(titleVue.snp.left)
        }
        
        
        
        let imgV = UIImageView(frame: .zero)
        
        imgV.add2(self).lyt { make in
            make.left.equalTo(titleVue.snp.right)
            make.centerY.equalTo(titleVue.snp.centerY)
        }

        let originalImage = UIImage(named: "cell_arrow_right_grey")
//        let resizedImage = originalImage?.resized(to: CGSize(width: 24, height: 24))
        //修改图片颜色
        imgV.tintColor = UIColor(rgb: 0x000000)
        imgV.image = originalImage?.withRenderingMode(.alwaysTemplate)
//        imgV.image = originalImage?.withTintColor(.red)  //失败

    }
    
    
    fileprivate var iconVue = UIImageView().bgColor(UIColor(rgb: 0xf8f8f8))
    fileprivate var titleVue = UILabel()
        .txtFont(UIFont.systemFont(ofSize: 22, weight: .bold))
        .txtColor(UIColor(rgb: 0x000000))
        .txt("莱德主人")
    
    fileprivate var subtitleVue = UILabel()
        .txtFont(UIFont.systemFont(ofSize: 14, weight: .light))
        .txtColor(UIColor(rgb: 0x666666))
        .txt("宠物 *2 丨 穿戴设备*2")
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

