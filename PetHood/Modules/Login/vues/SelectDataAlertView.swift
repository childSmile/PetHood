//
//  SelectDataAlertView.swift
//  PetHood
//
//  Created by MacPro on 2024/9/4.
//

import UIKit

enum SelectDateType : Int {
    case sex = 2
    case date
    case weight
    case life
    case avatar
    
    var title : String {
        switch self {
        case .date:
            return "选择生日"
        case .weight:
            return "选择身高"
        case .sex:
            return "选择性别"
        case .life:
            return "选择绝育"
        case .avatar:
            return "选择方式"
            
        }
    }
    
}

class SelectDataAlertView: UIView {
    
    var confirmClick:((String?) -> Void)?
    var selectValue: String?
    
    var type : SelectDateType = .date
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(rgb: 0x000000, alpha: 0.4)
        
        setupUI()
    }
    
    init(frame: CGRect , dataType:SelectDateType = .date , value:String?) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(rgb: 0x000000, alpha: 0.4)
        selectValue = value
        type = dataType
        setupUI()
    }
    
    
    fileprivate var bgVue = UIView().bgColor(.white)
    fileprivate var titleLabel = UILabel()
        .txtFont(UIFont.systemFont(ofSize: 17))
        .txtColor(UIColor(rgb: 0x000000))
    
    fileprivate var confirmButton = UIButton(type: .custom)
        .titleFont(UIFont.systemFont(ofSize: 17 , weight: .light))
        .titleColor(UIColor(rgb: 0x1677FF))
        .title("确定")
    
    fileprivate var cancelButton = UIButton(type: .custom)
        .titleFont(UIFont.systemFont(ofSize: 17 , weight: .light))
        .titleColor(UIColor(rgb: 0x1677FF))
        .title("取消")
    
   
    
    private func setupUI() {
        
        bgVue.add2(self).lyt { make in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(DHPXSW(s: 280))
        }
        
        bgVue.layer.cornerRadius = 24
        bgVue.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        titleLabel.add2(bgVue).lyt { make in
            make.centerX.equalTo(bgVue.snp.centerX)
            make.top.equalTo(DHPXSW(s: 0))
            make.height.equalTo(DHPXSW(s: 42))
        }.txt(type.title)
        
        cancelButton.add2(bgVue).lyt { make in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.left.equalTo(DHPXSW(s: 20))
            
        }
        
        confirmButton.add2(bgVue).lyt { make in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.right.equalTo(DHPXSW(s: -20))
            
        }
        
        let line = UIView().bgColor(UIColor(rgb: 0xDDDDDD))
        line.add2(bgVue).lyt { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.right.equalTo(0)
            make.height.equalTo(0.5)
        }
        
        if type == .date {
           let pickerView = DatePickerView(frame: CGRect(x: 0, y: 50, width: self.bounds.width, height: 120))
           
            
            pickerView.backgroundColor = .white
            
            
            pickerView.add2(bgVue).lyt { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(DHPXSW(s: 20))
                make.left.equalTo(DHPXSW(s: 20))
                make.right.equalTo(DHPXSW(s: -20))
                make.bottom.equalTo(0)
            }
            
            
            pickerView.selectedDateChanged = { [weak self] date in
                print("selectd ==\(date)")
                self?.selectValue = date.toString(dateFormat: "yyyy-MM-dd")
            }
            
            print("init==\(selectValue ?? "nil")")
            let date = (selectValue ?? "").toDate(dateFormat: "yyyy-MM-dd")
            //设置选中的日期
            pickerView.selectedDate(date)
            
        } else {
           let pickerView = DataPickerView(frame: CGRect(x: 0, y: 50, width: self.bounds.width, height: 120), type: type)
            
            
            pickerView.add2(bgVue).lyt { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(DHPXSW(s: 20))
                make.left.equalTo(DHPXSW(s: 20))
                make.right.equalTo(DHPXSW(s: -20))
                make.bottom.equalTo(0)
            }
            pickerView.selectedValueChanged = { [weak self] value in
                print("selectd ==\(value)")
                self?.selectValue = value
                
            }
            
            pickerView.selectValue(selectValue)
           
            
            
        }
        
        
        
        confirmButton.addTarget(self, action: #selector(confirmAction), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
       
        
    }
    
    @objc func cancelAction() {
        if let block = confirmClick {
            block(nil)
        }
        self.removeFromSuperview()
    }
    
    @objc func confirmAction() {
        if let block = confirmClick {
            block(selectValue)
        }
        self.removeFromSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}

