//
//  DataPickerView.swift
//  PetHood
//
//  Created by MacPro on 2024/9/10.
//

import UIKit


class DataPickerView: UIView {
    
    var selectedValueChanged : ((String) -> Void)?
   
    var type : SelectDateType = .life
    fileprivate var values : [String] = []
    fileprivate var pickerView = UIPickerView()
    fileprivate var selectIndex = 0
    
    
    
    init(frame: CGRect , type:SelectDateType) {
        super.init(frame: frame)
        
        self.type = type
        createData()
        
        pickerView.add2(self).lyt { make in
            make.top.left.right.bottom.equalTo(0)
        }
        pickerView.delegate = self
        pickerView.dataSource = self
        
        selectIndex = values.count / 2
    }
    
    func selectValue( _ value:String?) {
        for (index , v) in values.enumerated() {
            if (v == value) {
                selectIndex = index
                break
            }
            
        }
        pickerView.selectRow(selectIndex, inComponent: 0, animated: true)
        pickerView.reloadComponent(0)
        selectedValueChanged?(values[selectIndex])
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createData() {
       
        switch type {
        case .weight:
            for i in 1...20 {
                values.append(("\(i)"))
            }
            break
        case .sex:
            values.append("男")
            values.append("女")
            break
        case .life:
            values.append("是")
            values.append("否")
            break
        case .avatar:
            values.append("相机")
            values.append("相册")
        default:
            break
        }
        
       
    }
    

}


extension DataPickerView : UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return values.count
    }
    
    //每一行的高度
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60.0
    }
    
    //每一行的文本
    //    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    //        return  SourceData[row]
    //    }
    //
    //每一行的样式
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let specificView = UILabel()
        specificView.frame = CGRect(x: 0, y: 0, width: 80, height: 60)

        specificView.textColor = .black
        specificView.textAlignment = .center
        specificView.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        if type == .weight && row == selectIndex {
            specificView.text = "\( values[row])kg"
        } else {
            specificView.text = values[row]
        }
        
        
        return specificView
    }
    
    
    
    
}
extension DataPickerView : UIPickerViewDelegate  {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectIndex = row
        selectedValueChanged?(values[selectIndex])
        pickerView.reloadComponent(0)
    }
    
    
}



