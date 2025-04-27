//
//  PetTrackTableViewCell.swift
//  PetHood
//
//  Created by MacPro on 2024/7/12.
//

import UIKit

class PetTrackTableViewCell: BaseTableViewCell {
    
    
    private var bgVue = UIView().bgColor(.white).cornerRadius(DHPXSW(s: 16))
    private var imgV = UIImageView()
        .cornerRadius(DHPXSW(s: 8))
        .bgColor(.green)
    private var  modeLabel = UILabel()
        .txtFont(UIFont.systemFont(ofSize: 14, weight: .bold))
        .txtColor(UIColor.color(hex: 0x000000))
        .txt("遛宠模式")
    
    private var  distanceLabel = UILabel()
        .txtFont(UIFont.systemFont(ofSize: 14, weight: .bold))
        .txtColor(UIColor.color(hex: 0x000000))
        .txt("12.5千米")
    
    private var  timeLabel = UILabel()
        .txtFont(UIFont.systemFont(ofSize: 12, weight: .light))
        .txtColor(UIColor.color(hex: 0x666666))
        .txt("00:23")
    
    private var  stepLabel = UILabel()
        .txtFont(UIFont.systemFont(ofSize: 12, weight: .light))
        .txtColor(UIColor.color(hex: 0x666666))
        .txt("20000步")
    private var rightImgV = UIImageView(imgName: "track_right_bg_image")
    
    private var timeImgV = UIImageView(imgName: "icon_exercise_record_time")
    
    private var stepImgV = UIImageView(imgName: "report_step_icon")
        
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor.color(hex: 0xf6f6f6)
        addAllSubviews()
        
    }
    
    override func addAllSubviews() {
        
        bgVue.add2(contentView).lyt { make in
            make.edges.equalTo(UIEdgeInsets(top: DHPXSW(s: 10), left: DHPXSW(s: 20), bottom: DHPXSW(s: 0), right: DHPXSW(s: 20)))
        }
        imgV.add2(bgVue).lyt { make in
            make.left.equalTo(DHPXSW(s: 8))
            make.top.equalTo(DHPXSW(s: 8))
            make.bottom.equalTo(DHPXSW(s: -8))
            make.width.height.equalTo(DHPXSW(s: 56))
        }
        modeLabel.add2(bgVue).lyt { make in
            make.top.equalTo(imgV.snp.top).offset(DHPXSW(s: 4))
            make.left.equalTo(imgV.snp.right).offset(DHPXSW(s: 16))
        }
        
        distanceLabel.add2(bgVue).lyt { make in
            make.centerY.equalTo(modeLabel.snp.centerY)
            make.left.equalTo(modeLabel.snp.right).offset(DHPXSW(s: 16))
        }
        
        timeImgV.add2(bgVue).lyt { make in
            make.left.equalTo(modeLabel.snp.left)
            make.top.equalTo(modeLabel.snp.bottom).offset(DHPXSW(s: 8))
        }
        timeLabel.add2(bgVue).lyt { make in
            make.left.equalTo(timeImgV.snp.right).offset(DHPXSW(s: 2))
            make.centerY.equalTo(timeImgV.snp.centerY)
        }
        
        stepImgV.add2(bgVue).lyt { make in
            make.centerY.equalTo(timeImgV.snp.centerY)
            make.left.equalTo(timeLabel.snp.right).offset(DHPXSW(s: 16))
        }
        stepLabel.add2(bgVue).lyt { make in
            make.centerY.equalTo(timeImgV.snp.centerY)
            make.left.equalTo(stepImgV.snp.right).offset(DHPXSW(s: 2))
        }
        rightImgV.add2(bgVue).lyt { make in
            make.right.equalTo(DHPXSW(s: 0))
            make.centerY.equalTo(bgVue.snp.centerY)
            make.width.equalTo(DHPXSW(s: 76))
            make.top.bottom.equalTo(DHPXSW(s: 0))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
