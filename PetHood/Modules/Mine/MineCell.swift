//
//  MineCell.swift
//  PetHood
//
//  Created by MacPro on 2024/9/5.
//

import UIKit

class MineCell: BaseTableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .white
        layer.cornerRadius = 16
        accessoryType = .none
        
        iconVue.add2(contentView).lyt { make in
            make.centerY.equalTo(contentView.snp.centerY)
            make.left.equalTo(DHPXSW(s: 20))
        }
        
        titleVue.add2(contentView).lyt { make in
            make.centerY.equalTo(iconVue.snp.centerY)
            make.left.equalTo(iconVue.snp.right).offset(5)
        }
        
        
    }
    
    func configItem( _ icon:String = "" , _ title:String) {
        titleVue.txt(title)
        if icon.count == 0  {return}
        iconVue.img(UIImage(named: icon))
    }
    
    
    fileprivate var iconVue = UIImageView()
    fileprivate var titleVue = UILabel().txtFont(UIFont.systemFont(ofSize: 16, weight: .light))
        .txtColor(UIColor(rgb: 0x000000))
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



class MinePetCell : BaseTableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        layer.cornerRadius = 16
        line.isHidden = true
        arrowVue.isHidden = true
        
        bgVue.add2(contentView).lyt { make in
            make.top.equalTo(DHPXSW(s: 0))
            make.left.equalTo(DHPXSW(s: 16))
            make.right.equalTo(DHPXSW(s: -16))
            make.bottom.equalTo(DHPXSW(s: -10))
        }.img(UIColor.gradientColorImage(fromColors: [UIColor(rgb: 0xB9D6FF, alpha: 0.2) , UIColor(rgb: 0x8BBCFF, alpha: 0.04)], gradientType: .leftToRight, imgSize: CGSizeMake(self.width - DHPXSW(s: 16 * 2), self.height)))
            .cornerRadius(12)
        
        iconVue.add2(bgVue).lyt { make in
            make.centerY.equalTo(bgVue.snp.centerY)
            make.left.equalTo(DHPXSW(s: 8))
            make.size.equalTo(CGSize(width: DHPXSW(s: 32), height: DHPXSW(s: 32)))
        }.borderColor(.white)
            .borderWidth(2)
            .cornerRadius(DHPXSW(s: 16))
        
        titleVue.add2(bgVue).lyt { make in
            make.top.equalTo(iconVue.snp.top)
            make.left.equalTo(iconVue.snp.right).offset(8)
        }
        
        subtitleVue.add2(bgVue).lyt { make in
            make.bottom.equalTo(iconVue.snp.bottom)
            make.left.equalTo(titleVue.snp.left)
        }
        
    }
    
    func configItem( _ icon:String = "" , _ title:String) {
        titleVue.txt(title)
        if icon.count == 0  {return}
        iconVue.img(UIImage(named: icon))
    }
    
    fileprivate var bgVue = UIImageView()
        
    fileprivate var iconVue = UIImageView().bgColor(UIColor(rgb: 0xf8f8f8))
    fileprivate var titleVue = UILabel()
        .txtFont(UIFont.systemFont(ofSize: 14, weight: .light))
        .txtColor(UIColor(rgb: 0x000000))
    
    fileprivate var subtitleVue = UILabel()
        .txtFont(UIFont.systemFont(ofSize: 12, weight: .light))
        .txtColor(UIColor(rgb: 0x999999))
        .txt("10个月5天  10.0公斤")
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
