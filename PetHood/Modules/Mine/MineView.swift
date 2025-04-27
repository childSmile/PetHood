//
//  MineView.swift
//  PetHood
//
//  Created by MacPro on 2024/9/5.
//

import UIKit

class MineView: UIView {
    
    var titles = ["意见反馈" , "设置"]
    var icons = ["mine_feedback_icon" , "mine_setting_icon"]
    var pets : [String] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        for i in 0..<Int.random(in: 1...5) {
            pets.append("皮卡丘\(i)")
        }
        
        setupUI()
    }
    
    private func setupUI() {
        
        backgroundColor = UIColor(rgb: 0xF0F3F7)
        
        //navi
        let topV = UIImageView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: DHPXSW(s: 200))).bgColor(.white)
        topV.add2(self)
        topV.image = UIColor.gradientColorImage(fromColors: [UIColor(rgba: 0x0075FFff) , UIColor(rgba: 0xF0F3F7ff) ], gradientType: .topToBottom, imgSize: topV.size)
        
        //navi button
        let addButton = UIButton(type: .custom)
            .img(UIImage(named: "nav_add_icon"))
        addButton.add2(self).lyt { make in
            make.right.equalTo(DHPXSW(s: -20))
            make.size.equalTo(CGSizeMake(DHPXSW(s: 32), DHPXSW(s: 32)))
            make.top.equalTo(DHPXSW(s: 56))
        }.cornerRadius(8)
        
        
        let messageButton = UIButton(type: .custom)
            .img(UIImage(named: "nav_message_icon"))
            .hidden(true)
        
        messageButton.add2(self).lyt { make in
            make.right.equalTo(addButton.snp.left).offset(DHPXSW(s: -8))
            make.size.equalTo(CGSizeMake(DHPXSW(s: 32), DHPXSW(s: 32)))
            make.centerY.equalTo(addButton.snp.centerY)
        }.cornerRadius(8)
        
        //profile data
        let profileVue = ProfileHeaderVue(frame: .zero)
        profileVue.add2(topV).lyt { make in
            make.left.right.equalTo(0)
            make.top.equalTo(messageButton.snp.bottom).offset(DHPXSW(s: 10))
            make.height.equalTo(DHPXSW(s: 60))
        }
       
        
        //数据
        tabelView.add2(self).lyt { make in
            make.top.equalTo(topV.snp.bottom).offset(DHPXSW(s: -20))
            make.left.equalTo(DHPXSW(s: 20))
            make.right.equalTo(DHPXSW(s: -20))
            make.bottom.equalTo(DHPXSW(s: -(tabBarHeight() + 10)))
        
        }.footerVue(UIView())
            .dlgProxy(self)
            .dataProxy(self)
            .regCell(MineCell.self)
            .regCell(MinePetCell.self)
            .bgColor(.clear)
            .scrollIndicator(false, vShow: false)
        
        
        tabelView.separatorStyle = .none
        
        
    }
    
    
    fileprivate var tabelView = UITableView(frame: .zero, style: .plain)
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension MineView : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if (indexPath.section == 0 && indexPath.row == 0) || indexPath.section == 1 {
            let cell = tableView.dequeueReusable(MineCell.self, for: indexPath)
            
            cell.configItem(icons[indexPath.row], titles[indexPath.row])
            
            if indexPath.row == 0 {
                cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            } else {
                if indexPath.section == 1 && indexPath.row == icons.count - 1 {
                    cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
                } else {
                    cell.layer.maskedCorners = []
                }
            }
            
            cell.layer.masksToBounds = true
            cell.line.isHidden = indexPath.row == titles.count - 1
            
            if indexPath.section == 0 && indexPath.row == 0 {
                cell.line.isHidden = true
                cell.configItem("mine_pet_icon", "我的宠物")
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusable(MinePetCell.self, for: indexPath)
            
            cell.configItem("", pets[indexPath.row - 1])
            
            if indexPath.row == pets.count {
                cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            } else {
                cell.layer.maskedCorners = []
            }
            
            cell.layer.masksToBounds = true
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 1 ? 2 : pets.count + 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return indexPath.section == 1 ? DHPXSW(s: 56) : indexPath.section == 0 && indexPath.row == 0 ? DHPXSW(s: 56) : DHPXSW(s: 70)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return section == 1 ? UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 8)) : UIView()
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 1  ? DHPXSW(s: 8) : 0.1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let cell = tableView.cellForRow(at: indexPath) {
            print("didselected == \(cell)")
        }
    }
}
