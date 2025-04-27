//
//  WalkCutdownVue.swift
//  PetHood
//
//  Created by MacPro on 2024/7/17.
//

import UIKit

class WalkCutdownVue: UIView {
    
    private var timer : Timer?
    private var count = 3
    
    private var numberLabel = UILabel()
        .txtFont(UIFont.systemFont(ofSize: 160, weight: .bold))
        .txtColor(UIColor.color(hex: 0xFED700))
        

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.color(hex: 0x000000, alpha: 0.4)
        
        numberLabel.add2(self).lyt { make in
            make.centerX.equalTo(self.snp.centerX)
            make.centerY.equalTo(self.snp.centerY)
        }
        numberLabel.txt("\(count)")
        
    }
    
    @objc func timerAction() {
        print("count==\(count)")
        
        count -= 1;
        if count == 0 {
            timer?.invalidate()
            numberLabel.txt("GO")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.dismiss()
            }
          
        } else {
            numberLabel.txt("\(count)")
        }
        
    }
    
    func show() {
        // 创建Timer
        timer = Timer(timeInterval: 1.0, repeats: true, block: { [weak self] _ in
            self?.timerAction()
        })
        
        RunLoop.current.add(timer!, forMode: .common)
    }
    
     func dismiss() {
         
         if(self.superview != nil) {
             removeFromSuperview()
         }
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
