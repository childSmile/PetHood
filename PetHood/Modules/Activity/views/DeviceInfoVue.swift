//
//  DeviceInfoVue.swift
//  PetHood
//
//  Created by MacPro on 2024/7/11.
//

import UIKit


class DeviceInfoVue: UIView {
    
    private var onlineStatusLabel = UILabel()
        .txtFont(UIFont.systemFont(ofSize: DHPXSW(s: 12), weight: .light))
        .txtColor(UIColor.color(hex: 0xFE4B01))
        .txt("设备已离线")
    private var signalVue = UIImageView()
    private var gpsVue = UIImageView()
    private var elecVue = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addAllSubviews()
        onlineStatusLabel.isHidden = true
        
//        let svgURL = Bundle.main.url(forResource: "example", withExtension: "svg")!
//        let svgImage = SVGKImage(contentsOf: svgURL) //SVGKImage(contentsOf: svgURL)
//        let svgView = SVGKFastImageView(svgkImage: svgImage) // SVGKFastImageView(image: svgImage)
        
//        mobile_signal_icon
//        let imageView = UIImageView(image: UIImage(named: "mobile_signal_icon"))
//        imageView.add2(self).lyt { make in
//            make.centerY.equalTo(self.snp.centerY)
//            make.left.equalTo(DHPXSW(s: 3))
//        }
//        imageView.tintColor = UIColor.red
        
        
    }
    
    private func addAllSubviews() {
        onlineStatusLabel.add2(self).lyt { make in
            make.right.equalTo(DHPXSW(s: 0))
            make.centerY.equalTo(self.snp.centerY)
        }
        
        signalVue.add2(self).lyt { make in
            make.left.equalTo(DHPXSW(s: 0))
            make.centerY.equalTo(self.snp.centerY)
        }
        gpsVue.add2(self).lyt { make in
            make.left.equalTo(signalVue.snp.right).offset(16)
            make.centerY.equalTo(self.snp.centerY)
    
        }
        elecVue.add2(self).lyt { make in
            make.left.equalTo(gpsVue.snp.right).offset(16)
            make.centerY.equalTo(self.snp.centerY)
            make.right.equalTo(DHPXSW(s: 0))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func config(_ signal:String ,_ gps:String , _ elec:String ) {
        
        let res = Int(signal) == 0
        
        onlineStatusLabel.isHidden = !res
        signalVue.isHidden = res
        gpsVue.isHidden = res
        elecVue.isHidden = res
        
        signalVue.img(UIImage(named: "\(signal)_4g_icon"))
        gpsVue.img(UIImage(named: "\(gps)_gps_icon"))
        elecVue.img(UIImage(named: "\(elec)_battery_icon"))
       
    }
    
}
