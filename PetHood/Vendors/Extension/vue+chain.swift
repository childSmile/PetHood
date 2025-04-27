//
//  vue+chan.swift
//  AKExts
//
//  Created by edz on 3/22/21.
//

import UIKit
import SnapKit

/// vue链式协议默认实现
public extension UIView {
    
    /// 配置vue
    /// - Parameter config: 配置块
    /// - Returns: 自身(for chainable)
    @discardableResult
    func cfg(_ config: (Self)->Void) -> Self {
        config(self)
        return self
    }
    
    /// 添加到UI层级
    /// - Parameter sp: 父view
    /// - Returns: 自身(for chainable)
    @discardableResult
    func add2(_ sp: UIView) -> Self {
        sp.addSubview(self)
        return self
    }
    
    /// 设置tag
    /// - Parameter tg: tag值
    /// - Returns: 自身(for chainable)
    @discardableResult
    func tagged(_ tg: Int) -> Self {
        tag = tg
        return self
    }
    
    /// 是否加入响应链
    /// - Parameter enable: 是否加入
    /// - Returns: 自身(for chainable)
    @discardableResult
    func respondable(_ enable: Bool) -> Self {
        self.isUserInteractionEnabled = enable
        return self
    }
    
    /// 设置frame
    /// - Parameter frm: 相对位置
    /// - Returns: 自身(for chainable)
    @discardableResult
    func frame(_ frm: CGRect) -> Self {
        self.frame = frm
        return self
    }
    
    /// 设置bounds
    /// - Parameter bds: 绝对位置
    /// - Returns: 自身(for chainable)
    @discardableResult
    func bounds(_ bds: CGRect) -> Self {
        self.bounds = bds
        return self
    }
    
    /// 背景色
    /// - Parameter color: 颜色
    /// - Returns: 自身(for chainable)
    @discardableResult
    func bgColor(_ color: UIColor) -> Self {
        self.backgroundColor = color
        return self
    }
    
    /// 前景色
    /// - Parameter color: 颜色
    /// - Returns: 自身(for chainable)
    @discardableResult
    func tint(_ color: UIColor) -> Self {
        self.tintColor = color
        return self
    }
    
    /// 设置边界裁剪
    /// - Parameter clip: 是否裁剪
    /// - Returns: 自身(for chainable)
    @discardableResult
    func clipBounds(_ clip: Bool) -> Self {
        self.layer.masksToBounds = clip
        return self
    }
    
    /// 边框色
    /// - Parameter color: 颜色
    /// - Returns: 自身(for chainable)
    @discardableResult
    func borderColor(_ color: UIColor) -> Self {
        self.layer.borderColor = color.cgColor
        self.layer.masksToBounds = true
        return self
    }
    
    /// 边框宽
    /// - Parameter width: 宽度
    /// - Returns: 自身(for chainable)
    @discardableResult
    func borderWidth(_ width: CGFloat) -> Self {
        self.layer.borderWidth = width
        return self
    }
    
    /// 圆角弧度
    /// - Parameter radii: 弧度
    /// - Returns: 自身(for chainable)
    @discardableResult
    func cornerRadius(_ radii: CGFloat) -> Self {
        self.layer.cornerRadius = radii
        self.layer.masksToBounds = true
        return self
    }
    
    /// 阴影path 防止离屏渲染
    /// - Parameter path: 路径
    /// - Returns: 自身(for chainable)
    @discardableResult
    func shadowPath(_ path: CGPath) -> Self {
        self.layer.shadowPath = path
        return self
    }
    
    /// 阴影颜色
    /// - Parameter color: 颜色
    /// - Returns: 自身(for chainable)
    @discardableResult
    func shadowColor(_ color: UIColor) -> Self {
        self.layer.shadowColor = color.cgColor
        return self
    }
    
    /// 阴影弧度
    /// - Parameter radii: 弧度
    /// - Returns: 自身(for chainable)
    @discardableResult
    func shadowRadius(_ radii: CGFloat) -> Self {
        self.layer.shadowRadius = radii
        return self
    }
    
    /// 阴影偏移
    /// - Parameter offset: 偏移
    /// - Returns: 自身(for chainable)
    @discardableResult
    func shadowOffset(_ offset: CGSize) -> Self {
        self.layer.shadowOffset = offset
        return self
    }
    
    /// 阴影不透明度
    /// - Parameter opacity: 度数
    /// - Returns: 自身(for chainable)
    @discardableResult
    func shadowOpacity(_ opacity: Float) -> Self {
        self.layer.shadowOpacity = opacity
        return self
    }
    
    /// 内容模式
    /// - Parameter mode: 模式
    /// - Returns: 自身(for chainable)
    @discardableResult
    func cntMode(_ mode: UIView.ContentMode) -> Self {
        contentMode = mode
        return self
    }
    
    /// 是否隐藏
    /// - Parameter enbale: 隐藏
    /// - Returns: 自身(for chainable)
    @discardableResult
    func hidden(_ enable: Bool) -> Self {
        isHidden = enable
        return self
    }
    
    /**
     小屏幕隐藏(默认 iPhone5S)
     - Parameter screen: 参考屏幕
     - Returns: 自身(for chainable)
     */
    @discardableResult
    func hiddenOnNarrow(_ screen: CGFloat = 320.0) -> Self {
        self.isHidden = UIScreen.main.bounds.width <= screen
        return self
    }
    
    /// snapkit make布局
    /// - Parameter maker: 布局描述
    /// - Returns: 自身(for chainable)
    @discardableResult
    func lyt(_ maker: (ConstraintMaker)->Void) -> Self {
        self.snp.makeConstraints(maker)
        return self
    }
    
    /// snapkit remake布局
    /// - Parameter maker: 布局描述
    /// - Returns: 自身(for chainable)
    @discardableResult
    func relyt(_ maker: (ConstraintMaker)->Void) -> Self {
        self.snp.remakeConstraints(maker)
        return self
    }
    
    /// snapkit update布局
    /// - Parameter maker: 布局描述
    /// - Returns: 自身(for chainable)
    @discardableResult
    func uplyt(_ maker: (ConstraintMaker)->Void) -> Self {
        self.snp.updateConstraints(maker)
        return self
    }
    
    /// snapkit remove布局
    /// - Returns: 自身(for chainable)
    @discardableResult
    func rmlyt() -> Self {
        self.snp.removeConstraints()
        return self
    }
    
    /// 圆角化处理
    /// - Parameters:
    ///   - radius: 弧度
    ///   - corners: 四角集合
    /// - Returns: 自身(for chainable)
    @discardableResult
    func fillet(_ radius: CGFloat, with corners: UIRectCorner = .allCorners) -> Self {
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
        return self
    }
    
    /// 渐变方向
    enum AxisDirect {
        case horizontal
        case vertical
    }
    
    /// 添加渐变背景
    /// - Parameters:
    ///   - colors: 颜色集合
    ///   - locations: 渐变位置
    ///   - direct: 渐变方向
    /// - Returns: 自身(for chainable)
    @discardableResult
    func mkGradientBg(_ colors: [UIColor], at locations:[NSNumber], direct: AxisDirect = .horizontal) -> Self{
        // 处理渐变色
        guard colors.count > 1, colors.count == locations.count else {
            return self
        }
        let cols = colors.map { (c) -> CGColor in
            return c.cgColor
        }
        let gly = CAGradientLayer()
        gly.frame = self.bounds
        // 处理渐变方向
        switch direct {
        case .horizontal:
            gly.startPoint = CGPoint(x: 0, y: 0)
            gly.endPoint = CGPoint(x: 1, y: 0)
        case .vertical:
            gly.startPoint = CGPoint(x: 0, y: 0)
            gly.endPoint = CGPoint(x: 0, y: 1)
        }
        gly.colors = cols
        // 渐变分割点
        gly.locations = locations
        self.layer.insertSublayer(gly, at: 0)
        return self
    }
    
    /// 不可压缩的方向(默认水平方向)
    /// - Parameter on: 方向
    /// - Returns: 自身(for chainable)
    @discardableResult
    func mkIncompressible(_ on: NSLayoutConstraint.Axis = .horizontal) -> Self {
        self.setContentHuggingPriority(UILayoutPriority.required, for: on)
        self.setContentCompressionResistancePriority(UILayoutPriority.required, for: on)
        return self
    }
    
    /// 失效固有布局size
    /// - Returns: 自身(for chainable)
    @discardableResult
    func invalidateInstrictSize() -> Self {
        invalidateIntrinsicContentSize()
        return self
    }
}
