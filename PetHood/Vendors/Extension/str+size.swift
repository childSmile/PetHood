//
//  str+size.swift
//  AKExts
//
//  Created by edz on 2/20/21.
//

import Foundation
import UIKit

// MARK: - 字符串扩展 - 字体大小
extension String {
    /**
     给定宽度，计算字符高度
     - parameter width: 最大宽度
     - parameter number: 限制行数 默认0即不限制
     */
    func height4(_ font: UIFont, with width: CGFloat, lines number: Int = 0) -> CGFloat {
        
        guard number > 0 else {
            let attrs: [NSAttributedString.Key: Any] = [.font: font]
            let rect = NSString(string: self).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: attrs, context: nil)
            return ceil(rect.height)
        }
        // 限制行数时使用UILabel渲染计算
        let lab = UILabel()
        lab.font = font
        lab.text = self
        lab.numberOfLines = number
        lab.lineBreakMode = .byWordWrapping
        let size = lab.sizeThatFits(CGSize.init(width: width, height: CGFloat.greatestFiniteMagnitude))
        return ceil(size.height)
    }
    
    /**
     给定高度，计算字符宽度
     - parameter height: 最大宽度
     */
    func width4(_ font: UIFont, with height: CGFloat) -> CGFloat {
        let attrs: [NSAttributedString.Key: Any] = [.font: font]
        let rect = NSString(string: self).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: height), options: .usesLineFragmentOrigin, attributes: attrs, context: nil)
        return ceil(rect.width)
    }
    
    var mixedPhone: String {
        if self.count > 7 {
            let start = self.index(self.startIndex, offsetBy: 3)
            let end = self.index(self.endIndex, offsetBy: -4)
            let range = Range(uncheckedBounds: (lower: start, upper: end))
            return self.replacingCharacters(in: range, with: "****")
        }
        return self
    }
    
    /// 获取URL query参数
    func queryParamsFromURL() -> [String: Any] {
        guard let component = URLComponents.init(string: self), let queryItemList = component.queryItems else {
            return [:]
        }
        var para : [String : Any] = [:]
        for item in queryItemList {
            para[item.name] = item.value
        }
        return para
    }
}

// MARK: - 富文本字符串扩展 - 字体大小
extension NSAttributedString {
    /**
     给定宽度，计算字符高度
     - parameter width: 最大宽度
     - parameter number: 限制行数 默认0即不限制
     */
    func height4(_ font: UIFont, with width: CGFloat, lines number: Int = 0) -> CGFloat {
        
        guard number > 0 else {
            let rect = self.boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, context: nil)
            return ceil(rect.height)
        }
        // 限制行数时使用UILabel渲染计算
        let lab = UILabel()
        lab.font = font
        lab.numberOfLines = number
        lab.attributedText = self
        lab.lineBreakMode = .byWordWrapping
        let size = lab.sizeThatFits(CGSize.init(width: width, height: CGFloat.greatestFiniteMagnitude))
        return ceil(size.height)
    }
    
    /**
     给定高度，计算字符宽度
     - parameter height: 最大宽度
     */
    func width4(_ font: UIFont, with height: CGFloat) -> CGFloat {
        let rect = self.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: height), options: .usesLineFragmentOrigin, context: nil)
        return ceil(rect.width)
    }
}
