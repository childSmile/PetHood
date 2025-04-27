//
//  HomeTableViewCell.swift
//  PetHood
//
//  Created by MacPro on 2024/7/29.
//

import UIKit

class HomeTableViewCell: BaseTableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private var topVue = UIView().bgColor(.white)
    private var bottomVue = UIView().bgColor(UIColor.color(hex: 0xF7F7F7))
    private var lineVue = UIView().bgColor(.white)
    
    private var leftImageV = UIImageView().bgColor(UIColor.color(hexString: "#4C96FF", alpha: 0.5)).cornerRadius(6)
    
    private var timeLabel = UILabel()
        .txtColor(UIColor.color(hex: 0x000000))
        .txtFont(UIFont.systemFont(ofSize: 16, weight: .regular))
        .txt("17:25")
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        
        [topVue , lineVue ,bottomVue ,leftImageV ,timeLabel ].forEach { vue in
            contentView.addSubview(vue)
        }
        
        
    }
    
    override func layoutSubviews() {
        topVue.lyt { make in
            make.top.equalTo(0)
            make.left.equalTo(DHPXSW(s: 16))
            make.right.equalTo(DHPXSW(s: -16))
            make.height.equalTo(DHPXSW(s: 30))
        }
        
        lineVue.lyt { make in
            
            make.left.equalTo(topVue.snp.left).offset(DHPXSW(s: 20))
            make.width.equalTo(1)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
        }
        
        
        leftImageV.lyt { make in
//            make.left.equalTo(topVue.snp.left).offset(DHPXSW(s: 20))
            make.centerX.equalTo(lineVue.snp.centerX)
            make.centerY.equalTo(topVue.snp.centerY)
            make.size.equalTo(CGSize(width: 12, height: 12))
        }
        
        
        
        timeLabel.lyt { make in
            make.left.equalTo(leftImageV.snp.right).offset(DHPXSW(s: 16))
            make.centerY.equalTo(topVue.snp.centerY)
            make.right.equalTo(DHPXSW(s: -8))
        }
        
        bottomVue.lyt { make in
            make.bottom.equalTo(DHPXSW(s: -8))
            make.left.equalTo(timeLabel.snp.left)
            make.right.equalTo(topVue.snp.right)
            make.top.equalTo(topVue.snp.bottom).offset(DHPXSW(s: 8))
            make.height.equalTo(DHPXSW(s: 50))
        }
        
       
        
        
    }
    
    override func configItem(item: Any, _ indexPath: IndexPath) {
        
//        if indexPath.row == 0 {
//            lineVue.addDashedLine(from: CGPoint(x: 0.2, y: 20), to: CGPoint(x: 0.2, y: DHPXSW(s: 96)), dashColor: UIColor.color(hexString: "#4C96FF", alpha: 0.5), lineWidth: 0.6, dashLength: 5, spaceLength: 2)
//
//        } else {
//            
//            lineVue.addDashedLine(from: CGPoint(x: 0.5, y: 0), to: CGPoint(x: 0.5, y: DHPXSW(s: 96)), dashColor: UIColor.color(hexString: "#4C96FF", alpha: 0.5), lineWidth: 0.6, dashLength: 5, spaceLength: 2)
//        }
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
