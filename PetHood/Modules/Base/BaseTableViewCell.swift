//
//  BaseTableViewCell.swift
//  PetHood
//
//  Created by MacPro on 2024/7/12.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
    
    var line = UIView().bgColor(UIColor(rgb: 0xeeeeee))
    var arrowVue = UIImageView(image: UIImage(named: "cell_arrow_right_grey"))
    
   
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        accessoryType = .none
        selectionStyle = .none
        backgroundColor = .white
        
        line.add2(contentView).lyt { make in
            make.left.equalTo(DHPXSW(s: 12))
            make.right.equalTo(0)
            make.bottom.equalTo(0)
            make.height.equalTo(1)
        }
        arrowVue.add2(self).lyt { make in
            make.right.equalTo(DHPXSW(s: -12))
            make.centerY.equalTo(contentView.snp.centerY)
        }
        
        //修改图片颜色
        
//        var  image = UIImage(named: "cell_arrow_right_grey")
//        image = image?.withRenderingMode(.alwaysTemplate)
//        arrowVue.image = image
//        
//        arrowVue.tintColor = .red
        
    }
    

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addAllSubviews() {
        
    }
    
    func configItem(item:Any , _ indexPath:IndexPath) {
        
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
