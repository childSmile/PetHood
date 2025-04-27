//
//  lab+chain.swift
//  AKExts
//
//  Created by edz on 4/29/21.
//

import UIKit

/// UIlabel扩展 链式
public extension UILabel {
    
    /// 设置文本
    /// - Parameter txt: 文本
    /// - Returns: 自身(for chainable)
    @discardableResult
    func txt(_ txt: String?) -> Self {
        text = txt
        return self
    }
    
    /// 设置富文本
    /// - Parameter txt: 富文本
    /// - Returns: 自身(for chainable)
    @discardableResult
    func attrTxt(_ txt: NSAttributedString?) -> Self {
        attributedText = txt
        return self
    }
    
    /// 设置字体
    /// - Parameter font: 字体
    /// - Returns: 自身(for chainable)
    @discardableResult
    func txtFont(_ font: UIFont?) -> Self {
        self.font = font
        return self
    }
    
    /// 设置字体颜色
    /// - Parameter color: 颜色
    /// - Returns: 自身(for chainable)
    @discardableResult
    func txtColor(_ color: UIColor?) -> Self {
        textColor = color
        return self
    }
    
    /// 设置文本对其方式
    /// - Parameter align: 方式
    /// - Returns: 自身(for chainable)
    @discardableResult
    func alignment(_ align: NSTextAlignment) -> Self {
        textAlignment = align
        return self
    }
    
    /// 设置行数
    /// - Parameter num: 行数
    /// - Returns: 自身(for chainable)
    @discardableResult
    func lines(_ num: Int) -> Self {
        numberOfLines = num
        return self
    }
    
    /// 设置换行模式
    /// - Parameter mode: 模式
    /// - Returns: 自身(for chainable)
    @discardableResult
    func lineBreak(_ mode: NSLineBreakMode) -> Self {
        lineBreakMode = mode
        return self
    }
    
    /// 设置字体适应宽度
    /// - Parameter fit: 自适应
    /// - Returns: 自身(for chainable)
    @discardableResult
    func adjust2FitWidth(_ fit: Bool) -> Self {
        self.adjustsFontSizeToFitWidth = fit
        return self
    }
    
    /// 设置最大布局宽度
    /// - Parameter width: 宽度
    /// - Returns: 自身(for chainable)
    @discardableResult
    func maxWidth(_ width: CGFloat) -> Self {
        self.preferredMaxLayoutWidth = width
        return self
    }
}
