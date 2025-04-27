//
//  InputSearchEndView.swift
//  PetHood
//
//  Created by MacPro on 2024/7/15.
//

import UIKit
import RxSwift

class InputSearchEndView: UIView {
    
    var mapManager = MapManager()
    var location:AMapGeoPoint?
    
    var backClick:(()->Void)?
    var searchClick:((String)->Void)?
    var desClick:((POIAnnotation)->Void)?
    
    var textInput = UITextField()
        .bgColor(UIColor.color(hex: 0xF3F5F9))
//        .cornerRadius(12)
    
    var backButton = UIButton(type: .custom)
//        .bgColor(.red)
        .img(UIImage(named: "nav_back_icon"), for: .normal)
    
    var searchButton = UIButton(type: .custom)
        .title("搜索", for: .normal)
        .titleFont(UIFont.systemFont(ofSize: DHPXSW(s: 16)))
        .titleColor(UIColor.color(hex: 0x4C96FF), for: .normal)
    //关键字搜索结果
    var poiAnnotations:[POIAnnotation] = []
    
    private lazy var tableView = UITableView(frame: .zero, style: .plain)
        .bgColor(.white)
        .regCell(SearchResultCell.self)
        .dlgProxy(self)
        .dataProxy(self)
        .disabeiOS15NewFeatures()
        .sepStyle(.singleLine)
        .scrollIndicator(false, vShow: true)
        .rowH(DHPXSW(s: 44))
        .footerVue(UIView().frame(CGRect(x: 0, y: 0, width: 100, height: 0.1)).bgColor(.white))
    
    let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        
        mapManager.delegate = self
        
        addAllSubviews()
     
    }
    
    private func addAllSubviews() {
        backButton.add2(self).lyt { make in
            make.top.equalTo(DHPXSW(s: 44))
            make.left.equalTo(DHPXSW(s: 16))
            make.width.equalTo(DHPXSW(s: 40))
            make.height.equalTo(DHPXSW(s: 44))
        }
        
        backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        
        textInput.add2(self).lyt { make in
            make.left.equalTo(DHPXSW(s: 52))
            make.height.equalTo(DHPXSW(s: 44))
            make.centerY.equalTo(backButton.snp.centerY)
            make.left.equalTo(backButton.snp.right).offset(DHPXSW(s: 5))
        }
        
        let att = NSAttributedString(string: "请输入目的地", attributes: [
            .foregroundColor : UIColor.color(hex: 0x848A9B) ,
                .font : UIFont.systemFont(ofSize: DHPXSW(s: 16), weight: .light)
        ])
        textInput.attributedPlaceholder = att
        textInput.font = UIFont.systemFont(ofSize: DHPXSW(s: 16), weight: .light)
        textInput.textColor = UIColor.color(hex: 0x000000)
        textInput.clearButtonMode = .always
        textInput.delegate = self
        textInput.borderStyle = .roundedRect
        
        let leftV = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textInput.height))
        textInput.leftView = leftV
        textInput.leftViewMode = .always
        
        searchButton.add2(self).lyt { make in
            make.right.equalTo(DHPXSW(s: -16))
            make.centerY.equalTo(backButton.snp.centerY)
            make.height.equalTo(DHPXSW(s: 44))
            make.left.equalTo(textInput.snp.right).offset(DHPXSW(s: 5))
        }
        
        searchButton.addTarget(self, action: #selector(searchAction), for: .touchUpInside)
        
        
        tableView.add2(self).lyt { make in
            make.top.equalTo(textInput.snp.bottom).offset(DHPXSW(s: 10))
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
//            make.height.equalTo(DHPXSW(s: 100))
            
        }
        
        
        textInput.rx.text.subscribe { [weak self] value  in
            
            print("textfield _changed ==\(String(describing: value))")
            self?.searchAction()
            
        }.disposed(by: disposeBag)
    }
    
    @objc func searchAction() {
        guard let text = textInput.text else{
//            backClick?()
            return
        }
//        searchClick?(text)
        poiAnnotations.removeAll()
        let request = AMapPOIKeywordsSearchRequest()
        request.keywords = text;
        request.location = location
        mapManager.search(withRequest: request)
        
    }
    
    @objc func backAction() {
        backClick?()
        
    }
    
    func show() {
        textInput.becomeFirstResponder()
    }
    
    func dismiss() {
        textInput.resignFirstResponder()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("\(self) === deinit")
    }
    
    
}


extension InputSearchEndView : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if let clearButton = textField.value(forKey: "clearButton") as? UIButton {
                    clearButton.setImage(UIImage(named: "icon_close_search"), for: .normal) // 替换图标
                    clearButton.setTitleColor(.red, for: .normal) // 设置标题颜色
//                    clearButton.tintColor = .green // 设置颜色
                }
                return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("键盘收起")
        textField.resignFirstResponder()
        searchAction()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
       
    }
    
   
}


extension InputSearchEndView : MapMangerDelegate {
    func onPOISearchDone(_ request: AMapPOISearchBaseRequest, response: AMapPOISearchResponse) {
        if(response.pois.count == 0) {
            print("没有搜索到");
            poiAnnotations.removeAll();
            tableView.reloadData();
            return;
        }
        //解析POI信息
        for (_,obj) in response.pois.enumerated() {
            poiAnnotations.append(POIAnnotation(poi: obj))
        }
        
        tableView.reloadData()
        
        print("poinannotations ==\(poiAnnotations)")
    }
    
}

extension InputSearchEndView : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusable(SearchResultCell.self, for: indexPath)
        let poi = poiAnnotations[indexPath.row]
         
        let attributedString = NSString.string(withHighLightSubstring: poi.poi.name, substring: textInput.text ?? "" , color: UIColor.color(hex: 0x4C96FF))
        cell.config(attributedString)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  poiAnnotations.count
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        textInput.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        desClick?(poiAnnotations[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.1))
        if poiAnnotations.count == 0 {
            v.frame = CGRect(x: 0, y: 0, width: 0, height: DHPXSW(s: 30))
            let label = UILabel().txtColor(UIColor.color(hex: 0x999999)).txtFont(UIFont.systemFont(ofSize: 14, weight: .light)).txt("暂无结果")
            label.add2(v).lyt { make in
                make.center.equalTo(v.snp.center)
            }
        }
        return v
    }
}






class SearchResultCell : UITableViewCell {
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        
        iconImgV.add2(contentView).lyt { make in
            make.centerY.equalTo(contentView.snp.centerY)
            make.left.equalTo(DHPXSW(s: 20))
            make.size.equalTo(CGSize(width: DHPXSW(s: 16), height: DHPXSW(s: 16)))
        }
        titleLabel.add2(contentView).lyt { make in
            make.left.equalTo(iconImgV.snp.right).offset(DHPXSW(s: 12))
            make.centerY.equalTo(contentView.snp.centerY)
            make.right.equalTo(contentView.snp.right).offset(DHPXSW(s: -20))
        }
    }
    
    func config(_ item: NSAttributedString) {
        
        titleLabel.attrTxt(item)
        
//        guard let searchResult = item.poi.name else {return}
        // 创建显示在搜索框中的富文本字符串
//        let attributedString = NSMutableAttributedString(string: searchResult)
//        
//        let searchText = "浪浪浪"
        
//        for ch in searchResult {
//            guard let range = searchResult.range(of: String(ch))  else {
//                return
//            }
////            attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: NSRange(range, in: searchResult))
//        }
//       
      
        
         //遍历搜索文本和搜索结果中的共同字符
//        for index in searchText.indices {
//            print(searchText[index], terminator: " ")
//            if let range = searchResult.ranges(of: String()) {
//                // 为每个相同的字符设置不同的颜色
//                attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: NSRange(range, in: searchResult))
//            }
//        }
        
        // 设置显示在搜索框中的富文本字符串
//        searchBar.attributedText = attributedString
        
        
    }


    
    private var titleLabel = UILabel()
        .txtColor(UIColor.color(hex: 0x3D3D3D))
        .txtFont(UIFont.systemFont(ofSize: 14, weight: .light))
    
    private var iconImgV = UIImageView(imgName: "icon_serach")
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
