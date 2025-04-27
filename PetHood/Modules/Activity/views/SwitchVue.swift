//
//  SwitchVue.swift
//  PetHood
//
//  Created by MacPro on 2024/7/12.
//

import UIKit
import RxSwift

class SwitchVue: UIView {
    
    
    var tapClosure:(()->Void)?
    var isOnSubject = BehaviorSubject(value: false)
    private var isOn : Bool = false
    private var timer : Timer?
    private var count = 10
    private let icon = UIImageView().bgColor(.clear).img(UIImage(named: "switch_light_icon"))
    private let titleLabel = UILabel()
        .txtFont(UIFont.systemFont(ofSize: DHPXSW(s: 12), weight: .light))
        .txtColor(UIColor.color(hex: 0x000000))
        .txt("灯光")
    
    private let timeLabel = UILabel()
        .txtFont(UIFont.systemFont(ofSize: DHPXSW(s: 12), weight: .light))
        .txtColor(UIColor.color(hex: 0x999999))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.cornerRadius(DHPXSW(s: 12)).bgColor(.white)
        
        icon.add2(self)

        titleLabel.add2(self)

        timeLabel.add2(self)
        
        let tap = UITapGestureRecognizer()
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
        tap.addTarget(self, action: #selector(tapAction))
        
//        icon.img(UIImage.svgNamed("mobile_signal", cgColor: UIColor.red.cgColor))
//        let svgImage =  SVGKImage(named: "mobile_signal.svg")
//        let svgImageView = SVGKFastImageView(svgkImage: svgImage)
//        
//        
//        svgImageView?.add2(self).lyt({ make in
//            make.centerX.equalTo(self.snp.centerX)
//            make.top.equalTo(DHPXSW(s: 6))
//            make.width.height.equalTo(DHPXSW(s: 14))
//        })
        
//        // 加载SVG图片
//        SVGKImage *image = [SVGKImage imageNamed:@"mobile_signal.svg"];
//         
//        // 创建SVG图层
//        SVGKFastImageView *imageView = [[SVGKFastImageView alloc] initWithSVGKImage:image];
//         
//        // 设置大小
//        imageView.frame = CGRectMake(x, y, width, height);
//         
//        // 设置颜色（可选，会应用到SVG图片中的所有填充颜色）
//        imageView.fillColor = [UIColor redColor];
//         
//        // 将图层添加到视图
//        [self.view addSubview:imageView];
        
    }
    
    @objc func timerAction() {
        print("count==\(count)")
        count -= 1;
        if count == 0 {
            timeLabel.txt("")
            timer!.invalidate()
            timer = nil
            isOn = false
            count = 10
            isOnSubject.onNext(isOn)
            
        } else {
            timeLabel.txt("\(count)s")
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func tapAction() {
        if(isOn) {
            return
        }
        print("tap")
        isOn = !isOn
        tapClosure?()
        isOnSubject.onNext(isOn)
        
        // 创建Timer
        timer = Timer(timeInterval: 1.0, repeats: true, block: { [weak self] _ in
            self?.timerAction()
        })
        
        RunLoop.current.add(timer!, forMode: .common)

        
    }
    
    override func layoutSubviews() {
        icon.lyt { make in
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(DHPXSW(s: 6))
            make.size.equalTo(CGSize(width: DHPXSW(s: 10), height: DHPXSW(s: 12)))
        }
        titleLabel.lyt { make in
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(icon.snp.bottom).offset(DHPXSW(s: 6))
        }
        
        timeLabel.lyt { make in
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(titleLabel.snp.bottom).offset(DHPXSW(s: 3))
        }
    }
    
  
   

}


