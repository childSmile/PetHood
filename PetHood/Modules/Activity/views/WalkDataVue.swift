//
//  WalkDataVue.swift
//  PetHood
//
//  Created by MacPro on 2024/7/12.
//

import UIKit

class WalkDataVue: UIView {
    
    var endClosure:(() -> Void)?
    var pauseClosure:(() -> Void)?
    var goonClosure:(() -> Void)?
    var pullControlClosure:(() -> Void)?
    
    private var bgVue = UIImageView()
        .bgColor(.white)
        .cornerRadius(8)
        .img(UIImage(named: "walk_menu_bg_image"))
    
    private var pullControlBtn = UIButton(type: .custom)
        .titleFont(UIFont.systemFont(ofSize: 12, weight: .light))
        .titleColor(UIColor.color(hex: 0x666666), for: .normal)
        .title("电子牵引", for: .normal)
    
 
    private var distanceVue = DataItemVue(frame: .zero)
    private var timeVue = DataItemVue(frame: .zero)
    private var stepVue = DataItemVue(frame: .zero)
    private var energyVue = DataItemVue(frame: .zero)
        
    
    private var endBtn = UIButton(type: .custom)
//        .titleFont(UIFont.systemFont(ofSize: 12, weight: .light))
//        .titleColor(UIColor.color(hex: 0x666666), for: .normal)
//        .title("结束", for: .normal)
        .img(UIImage(named: "walk_stop_icon"), for: .normal)
//        .bgColor(.red)
        
    private var pauseBtn = UIButton(type: .custom)
//        .titleFont(UIFont.systemFont(ofSize: 12, weight: .light))
//        .titleColor(UIColor.color(hex: 0x666666), for: .normal)
//        .title("暂停", for: .normal)
//        .title("继续", for: .selected)
        .img(UIImage(named: "walk_pause_icon"), for: .normal)
        .img(UIImage(named: "walk_start_icon"), for: .selected)
//        .bgColor(.green)
        

    override init(frame: CGRect) {
        super.init(frame: frame)
        addAllSubviews()
    }
    

    
    private func addAllSubviews() {
        bgVue.isUserInteractionEnabled = true
        
        bgVue.add2(self).lyt { make in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
        pullControlBtn.add2(bgVue).lyt { make in
            make.right.equalTo((DHPXSW(s: -12)))
            make.top.equalTo(DHPXSW(s: 12))
            make.width.equalTo(DHPXSW(s: 60))
            make.height.equalTo(DHPXSW(s: 30))
        }
        
        pullControlBtn.addTarget(self, action: #selector(pullControlAction), for: .touchUpInside)
        
        distanceVue.add2(bgVue).lyt { make in
            make.centerX.equalTo(bgVue.snp.centerX)
            make.top.equalTo(DHPXSW(s: 12))
        }
        
        timeVue.add2(bgVue)
        stepVue.add2(bgVue)
        energyVue.add2(bgVue)
    
        
        let array = [timeVue , stepVue , energyVue]
        
        array.snp.distributeViewsAlong(axisType: .horizontal, fixedItemLength: DHPXSW(s: 120), leadSpacing: DHPXSW(s: 10) , tailSpacing: DHPXSW(s: 10))
        
        array.snp.makeConstraints {
            $0.top.equalTo(DHPXSW(s: 75))
        }
        
        
        configData()
        
        let btnW = DHPXSW(s: 80)
        let space = DHPXSW(s: 24)
        
        endBtn.add2(bgVue).lyt { make in
            make.bottom.equalTo(DHPXSW(s: -12))
            make.size.equalTo(CGSize(width: btnW, height: btnW))
            make.centerX.equalTo(bgVue.snp.centerX).offset( -DHPXSW(s: (btnW + space) / 2))
        }
        pauseBtn.add2(bgVue).lyt { make in
            make.bottom.equalTo(endBtn.snp.bottom)
            make.size.equalTo(endBtn.snp.size)
            make.centerX.equalTo(bgVue.snp.centerX).offset( DHPXSW(s: (btnW + space) / 2))
        }
       
        endBtn.addTarget(self, action: #selector(endAction), for: .touchUpInside)
        pauseBtn.addTarget(self, action: #selector(pauseAction), for: .touchUpInside)
        
    }
    
    @objc private func pullControlAction() {
        
        self.pullControlClosure?()
    }
    @objc private func endAction() {
        
        self.endClosure?()
    }
    
    @objc private func pauseAction(sender:UIButton) {
        
        sender.isSelected  = !sender.isSelected
        
        sender.isSelected ? self.pauseClosure?() : self.goonClosure?()
    }
    
    
    
     func configData() {
         distanceVue.dataLabel.txt("1.23")
         distanceVue.unitLabel.txt("距离(千米)")
         
         timeVue.dataLabel.txt("48")
         timeVue.unitLabel.txt("时间(分钟)")
         
         stepVue.dataLabel.txt("123")
         stepVue.unitLabel.txt("步数")
         
         energyVue.dataLabel.txt("466")
         energyVue.unitLabel.txt("消耗(千卡)")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


class DataItemVue : UIView {
    
     var dataLabel = UILabel()
        .txtFont(UIFont.systemFont(ofSize: 32, weight: .bold))
        .txtColor(UIColor.color(hex: 0x000000))
        
    
     var unitLabel = UILabel()
        .txtFont(UIFont.systemFont(ofSize: 14, weight: .light))
        .txtColor(UIColor.color(hex: 0x000000))
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addAllSubviews()
    }
    
    private func addAllSubviews() {
        
        dataLabel.add2(self).lyt { make in
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(DHPXSW(s: 20))
        }
        
        unitLabel.add2(self).lyt { make in
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(dataLabel.snp.bottom).offset(2)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
