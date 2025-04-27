//
//  PetInfoVue.swift
//  PetHood
//
//  Created by MacPro on 2024/9/4.
//

import UIKit

class PetInfoVue: UIView {
    
    var photoClick : (()->Void)?
    var nextClick : (()->Void)?
    var cellClick : ((IndexPath)->Void)?
    var petModel : PetModel?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        
    }
    
    
    fileprivate var tableView = UITableView(frame: .zero, style: .plain)
        .regCell(PetInfoCell.self)
        .rowH(DHPXSW(s: 48))
        .bgColor(.white)
    
    fileprivate var titles = ["昵称" , "品种" , "性别" , "生日" , "体重" , "是否绝育"]
     var subTitles : [Int:String]  = [:]
        
    
    fileprivate var photoVue = UIButton(type: .custom)
        .img(UIImage(named: "phtot_add"))
    fileprivate var nextVue = UIButton(type: .custom)
        .title("创建宠物档案")
        .titleFont(UIFont.systemFont(ofSize: 16, weight: .light))
        .titleColor(.white, for: .normal)
        .titleColor(.white.withAlphaComponent(0.6), for: .disabled)
        
        
    
    private func setupUI() {
        
        photoVue.add2(self).lyt { make in
            make.top.equalTo(48)
            make.centerX.equalTo(self.snp.centerX)
            make.size.equalTo(CGSizeMake(DHPXSW(s: 80), DHPXSW(s: 80)))
        }.cornerRadius(DHPXSW(s: 40))
            .borderColor(.white)
            .borderWidth(1.6)
        
        
        tableView.add2(self).lyt { make in
            make.left.equalTo(DHPXSW(s: 20))
            make.right.equalTo(DHPXSW(s: -20))
            make.top.equalTo(photoVue.snp.bottom).offset(DHPXSW(s: 20))
            make.height.equalTo(DHPXSW(s: 48 * 6))
            
        }
        .cornerRadius(DHPXSW(s: 12))
        .dataProxy(self)
        .dlgProxy(self)
        .sepStyle(.none)
        
        nextVue.add2(self).lyt { make in
            make.bottom.equalTo(self.snp.bottom).offset(DHPXSW(s: -SafeArea_Bottom() - DHPXSW(s: 20)))
            make.left.equalTo(tableView.snp.left)
            make.right.equalTo(tableView.snp.right)
            make.height.equalTo(48)
        }.cornerRadius(24)
            .bgImg(UIImage.creatImage(color: UIColor(rgb: 0x4C96FF)), for: .normal)
            .bgImg(UIImage.creatImage(color: UIColor(rgb: 0x4C96FF).withAlphaComponent(0.6)), for: .disabled)
        
        photoVue.addTarget(self, action: #selector(photoAction), for: .touchUpInside)
        nextVue.addTarget(self, action: #selector(nextAction), for: .touchUpInside)
        
        
    }
    
    func updatePetModel( _ model:PetModel?) {
        if let petModel = model {
            //["昵称" , "品种" , "性别" , "生日" , "体重" , "是否绝育"]
            subTitles.updateValue(petModel.name ?? "", forKey: 0)
            subTitles.updateValue(petModel.breed ?? "", forKey: 1)
            subTitles.updateValue(petModel.gender ?? "", forKey: 2)
            subTitles.updateValue(petModel.birthdate ?? "", forKey: 3)
            subTitles.updateValue(petModel.weight ?? "", forKey: 4)
            subTitles.updateValue(petModel.isLife ?? "", forKey: 5)
            
            tableView.reloadData()
        }
        
        
    }
    
    func updatePhoto(_ image:UIImage) {
        photoVue.img(image)
    }
    
    @objc func nextAction() {
        self.nextClick?()
    }
    
    @objc func photoAction() {
        self.photoClick?()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
 
}


extension PetInfoVue : UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusable(PetInfoCell.self, for: indexPath)
        cell.titleLabel.text = titles[indexPath.row]
        cell.infoLabel.text = subTitles[indexPath.row] ?? ""
        cell.line.isHidden = indexPath.row == titles.count - 1
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("selectd == \(titles[indexPath.row])")
        
        cellClick?(indexPath)
        
    }
    
    
    
    
}



class PetInfoCell : BaseTableViewCell {
    
    var titleLabel = UILabel()
        .txtFont(UIFont.systemFont(ofSize: 16, weight: .light))
        .txtColor(UIColor(rgb: 0x000000))
    
    var infoLabel = UILabel()
        .txtFont(UIFont.systemFont(ofSize: 14, weight: .light))
        .txtColor(UIColor(rgb: 0x999999))
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        titleLabel.add2(contentView).lyt { make in
            make.centerY.equalTo(contentView.snp.centerY)
            make.left.equalTo(DHPXSW(s: 16))
        }
        infoLabel.add2(contentView).lyt { make in
            make.centerY.equalTo(contentView.snp.centerY)
            make.right.equalTo(arrowVue.snp.left).offset(DHPXSW(s: -4))
        }
      
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
