//
//  PetKindVue.swift
//  PetHood
//
//  Created by MacPro on 2024/9/3.
//

import UIKit
import RxSwift

class PetKindVue: UIView {
    let disposeBag = DisposeBag()
    var nextClick : ((Int) -> Void)?
    var cancelClick : (() -> Void)?
    
    
    var nextButton = UIButton(type: .custom)
        .title("下一步", for: .normal)
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
            .txt("绑定成功\n添加宠物档案")
            .lines(0)
        
        topLabel.add2(self).lyt { make in
            make.top.equalTo(DHPXSW(s: 52))
            make.left.equalTo(DHPXSW(s: 20))
            make.right.equalTo(DHPXSW(s: -20))
        }
        
        
        
        
        let catVue = kindItemVue(imgName: "kind_cat", title: "喵星人")
        let dogVue = kindItemVue(imgName: "kind_dog", title: "汪星人")
        catVue.tag = 100
        dogVue.tag = 101
        
        catVue.add2(self).lyt { make in
            make.right.equalTo(self.snp.centerX).offset(DHPXSW(s: -20))
            make.size.equalTo(CGSize(width: DHPXSW(s: 124), height: DHPXSW(s: 112)))
            make.top.equalTo(topLabel.snp.bottom).offset(DHPXSW(s: 50))
        }
        
        dogVue.add2(self).lyt { make in
            make.left.equalTo(self.snp.centerX).offset(DHPXSW(s: 20))
            make.size.equalTo(CGSize(width: DHPXSW(s: 124), height: DHPXSW(s: 112)))
            make.top.equalTo(topLabel.snp.bottom).offset(DHPXSW(s: 50))
        }
        
        
        nextButton.add2(self).lyt { make in
            make.top.equalTo(catVue.snp.bottom).offset(DHPXSW(s: 70))
            make.left.equalTo(topLabel.snp.left)
            make.right.equalTo(topLabel.snp.right)
            make.height.equalTo(48)
        }.cornerRadius(24)
            .bgImg(UIImage.creatImage(color: UIColor(rgb: 0x4C96FF)), for: .normal)
            .bgImg(UIImage.creatImage(color: UIColor(rgb: 0x4C96FF).withAlphaComponent(0.6)), for: .disabled)
        nextButton.isEnabled = false
        
        let cancelButton = UIButton(type: .custom)
            .title("跳过", for: .normal)
            .titleColor(UIColor(rgb: 0x000000), for: .normal)
            .bgColor(UIColor(rgb: 0xffffff))
            .titleFont(UIFont.systemFont(ofSize: 14, weight: .light))
        
        cancelButton.add2(self).lyt { make in
            make.top.equalTo(nextButton.snp.bottom).offset(DHPXSW(s: 10))
            make.left.equalTo(nextButton.snp.left)
            make.right.equalTo(nextButton.snp.right)
            make.height.equalTo(48)
        }
        
        nextButton.rx.tap.subscribe { [weak self] _ in
            print("next")
            if self?.nextClick != nil {
                self?.nextClick!(self!.selectedTag - 100)
            }
 
            
        }.disposed(by: disposeBag)
        
        cancelButton.rx.tap.subscribe { [weak self] _ in
            print("cancel")
            if self?.cancelClick != nil {
                self?.cancelClick!()
            }
        }.disposed(by: disposeBag)
        
 
        
    }
    
    func kindItemVue(imgName:String , title:String) -> UIView {
        let vue = UIView()
        let imgv = UIButton(type: .custom)
            .img(UIImage(named: "\(imgName)_unselected"), for: .normal)
            .img(UIImage(named: "\(imgName)_selected"), for: .selected)
        
        imgv.tag = 10000
        imgv.add2(vue).lyt { make in
            make.centerX.equalTo(vue.snp.centerX)
            make.top.equalTo(DHPXSW(s: 10))
            
        }
        
        let label = UILabel()
            .txtFont(UIFont.systemFont(ofSize: 14, weight: .regular))
            .txtColor(UIColor(rgb: 0x3d3d3d))
            .txt(title)
        label.add2(vue).lyt { make in
            make.centerX.equalTo(imgv.snp.centerX)
            make.top.equalTo(imgv.snp.bottom).offset(-12)
        }
        
        imgv.rx.tap.subscribe { [weak self] _ in
            imgv.isSelected = !imgv.isSelected
            self?.nextEnable(selected: imgv.isSelected , tag: vue.tag)
        }.disposed(by: disposeBag)
        
        return vue
    }
    
    var selectedTag : Int = 0
    private func nextEnable(selected:Bool , tag:Int) {
        
        print("tag ==\(tag)")
        if selected {
            if selectedTag == 0 {
                selectedTag = tag
                
            } else if(selectedTag != tag ) {
                selectedTag = tag
                if tag == 100 {
                    (self.viewWithTag(101)?.viewWithTag(10000) as! UIButton).isSelected = false
                }
                if tag == 101 {
                    (self.viewWithTag(100)?.viewWithTag(10000) as! UIButton).isSelected = false
                }
            }
            
        } else {
            selectedTag = 0
        }
      
        
        nextButton.isEnabled = selectedTag != 0
    }

}
