//
//  DatePickerView.swift
//  PetHood
//
//  Created by MacPro on 2024/9/4.
//

import UIKit

let latestYear = 1949

class DatePickerView: UIView {
    
    var selectedDateChanged : ((Date) -> Void)?
   
    
    fileprivate var years : [Int] = []
    fileprivate var months : [Int] = []
    fileprivate var days : [Int] = []
    
    fileprivate var selectYear : Int = 0
    fileprivate var selectMonth : Int = 0
    fileprivate var selectDay : Int = 0
    
    fileprivate var pickerView = UIPickerView()
    fileprivate var components = DateComponents()
    
    fileprivate var maxYear : Int = 0
    fileprivate var maxMonth : Int = 0
    fileprivate var maxDay : Int = 0
    fileprivate var maxDate : Date?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createData()
        pickerView.add2(self).lyt { make in
            make.top.left.right.bottom.equalTo(0)
        }
        pickerView.delegate = self
        pickerView.dataSource = self
        
        //默认设置
        setMaxDate(Date())
        
    }
    
    func setMaxDate(_ date:Date) {
        maxDate = date
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        
        maxYear = (components.year ?? 2124)
        maxMonth = (components.month ?? 12 )
        maxDay = (components.day ?? 31)
        
        pickerView.reloadAllComponents()
        
    }
    
    func selectedDate(_ date:Date) {
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        
        selectYear = ((components.year ?? 1949) - latestYear)
        selectMonth = ((components.month ?? 10) - 1)
        selectDay = ((components.day ?? 1) - 1)
        
        print("init=date=\(date)")
        print("year==\(selectYear) , month==\(selectMonth) , day==\(selectDay)")
        
        reloadDays(years[selectYear], months[selectMonth])
        
        pickerView.selectRow(selectYear, inComponent: 0, animated: true)
        pickerView.selectRow(selectMonth, inComponent: 1, animated: true)
        pickerView.selectRow(selectDay, inComponent: 2, animated: true)
        
        
        pickerView.reloadAllComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createData() {
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: Date())
        let year = components.year ?? 2024
        let count = year - latestYear
        
        for i in 0...count {
            years.append((year - count + i))
        }
        
        for i in 0..<12 {
            months.append((i+1))
        }
        
    }
    

}


extension DatePickerView : UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return component == 0 ? years.count : component == 1 ? months.count : days.count
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
        
        
  
        let array = component == 0 ? years : component == 1 ? months : days
        
        if component == 0 && row == selectYear {
            specificView.text = "\(array[row])年"
            specificView.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        } else if component == 1 && row == selectMonth {
            specificView.text = "\(array[row])月"
            specificView.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        } else if component == 2 && row == selectDay {
            specificView.text = "\(array[row])日"
            specificView.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        } else {
            specificView.text = "\(array[row])"
            specificView.font = UIFont.systemFont(ofSize: 16, weight: .light)
        }
//        print("ww====year==\(selectYear) , month==\(selectMonth) , day==\(selectDay) , row==\(row) , com==\(component)")
        
        return specificView
    }
    
    
    
}
extension DatePickerView : UIPickerViewDelegate  {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let year = years[pickerView.selectedRow(inComponent: 0)]
        let month = months[pickerView.selectedRow(inComponent: 1)]
        
        
        if component == 0 {
            //年 / 2月
            selectYear = row
            if(month == 2) {
            }
        }
        //月
        if component == 1 {
            selectMonth = row
        }
        
        //日
        if component == 2 {
            selectDay = row
        }
        
        reloadDays(year, month)
        
        pickerView.reloadComponent(component)
        
//        print("year==\(selectYear) , month==\(selectMonth) , day==\(selectDay) , row==\(row) , com==\(component)")
    }
    
    func reloadDays(_ year:Int , _ month:Int) {
        
        var count = 0;
        
        if [1,3,5,7,8,10,12].contains(month) {
            count = 31
        } else if [4,6,9,11].contains(month) {
            count = 30
        } else if month == 2 {
            let year = years[pickerView.selectedRow(inComponent: 0)]
            count = isLeapYear(year) ? 29 : 28
        }
        
        if year == maxYear {
            months.removeAll()
            for i in 0..<maxMonth {
                months.append(i+1)
            }
            
            if month == maxMonth {
                if count >= maxDay {
                    count = maxDay
                }
            }
            
            
        } else {
            months.removeAll()
            for i in 0..<12 {
                months.append(i+1)
            }
            
        }
        
        //更新月
        if selectMonth > months.count - 1 {
            selectMonth = months.count - 1
        }
        pickerView.reloadComponent(1)
        
        
        //更新日
        days.removeAll()
        for i in 0..<count {
            days.append(i+1)
        }
        
        if selectDay > days.count - 1 {
            selectDay = days.count - 1
        }
        
        pickerView.reloadComponent(2)
        
        
        //回调日期
        let day = days[selectDay]
        
        components.year = year
        components.month = months[selectMonth]
        components.day = day
        components.timeZone = TimeZone(secondsFromGMT: 0)
        components.calendar = Calendar(identifier: .gregorian)
         
        if let date = components.date {
            selectedDateChanged?(date)
        }
           
        
    }
    
    func isLeapYear(_ year: Int) -> Bool {
        return year % 4 == 0 && year % 100 != 0 || year % 400 == 0
    }
}



