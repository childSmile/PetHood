//
//  Date+Extension.swift
//  PetHood
//
//  Created by MacPro on 2024/9/4.
//

import Foundation

extension Date {
    func toString(dateFormat: String = "yyyy-MM-dd") -> String {
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = dateFormat
           return dateFormatter.string(from: self)
       }
    
    
    func toTimeinterval() -> Int {
        return Int(self.timeIntervalSince1970 * 1000)
    }
    
}

extension String {
    func toDate(dateFormat format: String = "yyyy-MM-dd") -> Date {
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = format
          dateFormatter.locale = Locale(identifier: "zh_CN")
          dateFormatter.timeZone = TimeZone(secondsFromGMT: 0) // 根据需要设置时区
          return dateFormatter.date(from: self) ?? Date()
      }
}

extension Data {
    
    func hexString() -> String {
        return self.withUnsafeBytes { buffer -> String in
            return buffer.map { byte in
                String(format: "%02x", byte)
            }.joined()
        }
    }
  
    
}
