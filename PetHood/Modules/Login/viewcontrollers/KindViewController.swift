//
//  KindViewController.swift
//  PetHood
//
//  Created by MacPro on 2024/9/5.
//

import UIKit

struct KindListModel {
    var key : String?
    var list : [String]?
}
struct KindModel {
    var type : String?
    var name : String?
}


class KindViewController: ZBaseViewController {
    
    var selectKind : ((String) -> Void)?
    
    fileprivate var sortedKeys : [String] = []
    fileprivate var listArr : [KindListModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        z_navgationBar.title = NSMutableAttributedString(string: "选择品类", attributes: [.font : UIFont.systemFont(ofSize: 17)])
        z_navgationBar.reloadTitleViewAlign(.center)
        
        view.backgroundColor = UIColor(rgb: 0xF0F3F7)
        
        
        // 构造大写字母表
        var alphabetUppercase = ""
        for scalar in Unicode.Scalar("A").value...Unicode.Scalar("Z").value {
            if let scalarValue = Unicode.Scalar(scalar) {
                let character = Character(scalarValue)
                alphabetUppercase.append(character)
            }
        }
        
        for letter in alphabetUppercase {
            let count = Int.random(in: 1...10)
            var list : [String] = []
            for i in 0..<count {
                list.append("\(letter)\(i)")
            }
            listArr.append(KindListModel(key: "\(letter)" ,list: list))
            sortedKeys.append("\(letter)")
        }
        
        setupUI()
        
        tableView.reloadData()
    }
    

    fileprivate var tableView = UITableView(frame: .zero, style: .plain).bgColor(.clear)
    fileprivate var searchBar = UISearchBar()
    
    private func setupUI() {
        
        let searchBar = UISearchBar()
        searchBar.backgroundColor = .clear
        searchBar.placeholder = "搜索"
        searchBar.tintColor = .black
        searchBar.barTintColor = .white
        searchBar.searchBarStyle = .minimal
        searchBar.delegate = self
        
        
        searchBar.add2(view).lyt { make in
            make.top.equalTo(z_navgationBar.snp.bottom).offset(DHPXSW(s: 10))
            make.left.equalTo(DHPXSW(s: 10))
            make.right.equalTo(DHPXSW(s: -10))
        }
        
        
        tableView.add2(view).lyt { make in
            make.top.equalTo(searchBar.snp.bottom).offset(DHPXSW(s: 24))
            make.bottom.equalTo(0)
            make.left.equalTo(DHPXSW(s: 10))
            make.right.equalTo(DHPXSW(s: -10))
        }.dlgProxy(self)
        .dataProxy(self)
        .regCell(UITableViewCell.self)
        .sepStyle(.none)
        
        //索引字体颜色
        tableView.sectionIndexColor = UIColor(rgb: 0x999999)
        tableView.sectionIndexBackgroundColor = .clear
        
        
        
        
        
        
    }
    
    override func zNavigationBarBackgroundImage(_ navigationBar: ZBaseNavigationBar) -> UIImage {
        return UIImage.createImg(UIColor.white, with: navigationBar.bounds.size) ?? UIImage(named: "")!
    }
    
   
}

extension KindViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
         print("textDidChange==\(searchText)")
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("CancelButtonClicked")
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("SearchButtonClicked")
    }
    
}

extension KindViewController : UITableViewDataSource , UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let array = listArr[indexPath.section].list {
            let kind = array[indexPath.row]
            selectKind?(kind)
            navigationController?.popViewController(animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArr[section].list?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusable(UITableViewCell.self, for: indexPath)
        cell.backgroundColor = .white
        
        var showLine = false
        
       if let array = listArr[indexPath.section].list {
           
           cell.textLabel?.text = "\(array[indexPath.row])"
           cell.layer.cornerRadius = DHPXSW(s: 12)
           
           if (indexPath.row == 0 && indexPath.row == array.count - 1) {
               cell.layer.maskedCorners = [.layerMinXMinYCorner , .layerMaxXMinYCorner , .layerMinXMaxYCorner , .layerMaxXMaxYCorner]
               showLine = false
               
           } else if indexPath.row == 0 {
               cell.layer.maskedCorners = [.layerMinXMinYCorner , .layerMaxXMinYCorner]
               showLine = true
               
           } else if indexPath.row == array.count - 1 {
               cell.layer.maskedCorners = [.layerMinXMaxYCorner , .layerMaxXMaxYCorner]
               
               showLine = false
           }  else {
               cell.layer.maskedCorners = []
               showLine = true
           }
           
       }
        cell.viewWithTag(100)?.removeFromSuperview()
        if showLine {
            let lineV = UIView().bgColor(UIColor(rgb: 0xEEEEEE)).tagged(100)
            lineV.add2(cell).lyt { make in
                make.right.bottom.equalTo(0)
                make.height.equalTo(1)
                make.left.equalTo(12)
            }
        }
        
        
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.textColor = .black
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return listArr.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let listM = listArr[section]
        return "\(listM.key ?? "")"
       
    }
    //设置tableview section 样式
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let headerView = view as! UITableViewHeaderFooterView
        headerView.contentView.backgroundColor = UIColor(rgb: 0xF0F3F7)
        headerView.textLabel?.textColor = UIColor(rgb: 0x3D3D3D)
        headerView.textLabel?.font = UIFont.systemFont(ofSize: 16, weight: .light)
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        return UIView().bgColor(UIColor(rgb: 0xF0F3F7))
//    }
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return DHPXSW(s: 30)
//    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sortedKeys
    }

    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        self.view.endEditing(true)
        return index
    }
    
   
    
}


