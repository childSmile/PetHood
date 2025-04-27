//
//  str+ext.swift
//  MeritInternation
//
//  Created by merit on 2023/11/11.
//

import UIKit

// MARK: - 字符串扩展 - 字体大小
extension String {
    /// 默认一位小数 向上取整
    func convertCeilDecimal(_ point: Int = 1) -> String {
        var tmp:Double = 1.0
        for _ in 0..<point {
            tmp *= 10
        }
        return String(format: "%.\(point)f",ceil(((Double(self) ?? 0) * tmp)) / tmp)
    }
    
    /// 默认一位小数 向下取整
    func convertFloorDecimal(_ point: Int = 1) -> String {
        var tmp:Double = 1.0
        for _ in 0..<point {
            tmp *= 10
        }
        return String(format: "%.\(point)f", floor(((Double(self) ?? 0)*tmp))/tmp)
    }
    
    /// 默认一位小数 四舍五入
    func convertDecimal(_ point: Int = 1) -> String {
        return String(format: "%.\(point)f", (Double(self) ?? 0))
    }
}
