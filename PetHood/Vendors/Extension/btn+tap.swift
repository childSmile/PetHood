//
//  btn+tap.swift
//  AKExts
//
//  Created by edz on 2/23/21.
//

import UIKit

// MARK: - UIButton扩展 - 点击
extension UIButton {
    
    /// 运行时注册 替换方法
    static func init4Runtime() {
        UIButton.hook4DoubleTapped()
    }
    
    /// 类方法 初始化按钮 防止双击
    @discardableResult
    static func custom(_ title: String? = nil) -> Self {
        return self.init(type: .custom)
            .doubleTap()
            .preventDblTap()
            .exclusive(true)
            .title(title)
    }
}

// MARK: - UIButton扩展 - 对外链式
public extension UIButton {
    
    /// 设置行数
    /// - Parameter num: 行数
    /// - Returns: 自身(for chainable)
    @discardableResult
    func lines(_ num: Int) -> Self {
        titleLabel?.numberOfLines = num
        return self
    }
    
    /// 设置对齐方式
    /// - Parameter align: 方式
    /// - Returns: 自身(for chainable)
    @discardableResult
    func alignment(_ align: NSTextAlignment) -> Self {
        titleLabel?.textAlignment = align
        return self
    }
    
    /// 设置换行模式
    /// - Parameter mode: 模式
    /// - Returns: 自身(for chainable)
    @discardableResult
    func lineBreak(_ mode: NSLineBreakMode) -> Self {
        titleLabel?.lineBreakMode = mode
        return self
    }
    
    /// 设置标题
    /// - Parameters:
    ///   - title: 标题
    ///   - stat: 状态
    /// - Returns: 自身(for chainable)
    @discardableResult
    func title(_ title: String?, for stat: UIControl.State = .normal) -> Self {
        setTitle(title, for: stat)
        return self
    }
    
    /// 设置字体
    /// - Parameter font: 字体
    /// - Returns: 自身(for chainable)
    @discardableResult
    func titleFont(_ font: UIFont?) -> Self {
        titleLabel?.font = font
        return self
    }
    
    /// 设置标题颜色
    /// - Parameters:
    ///   - color: 颜色
    ///   - stat: 状态
    /// - Returns: 自身(for chainable)
    @discardableResult
    func titleColor(_ color: UIColor?, for stat: UIControl.State = .normal) -> Self {
        setTitleColor(color, for: stat)
        return self
    }
    
    /// 设置富文本标题
    /// - Parameters:
    ///   - attrs: 富文本
    ///   - stat: 状态
    /// - Returns: 自身(for chainable)
    @discardableResult
    func attrTitle(_ attrs: NSAttributedString?, for stat: UIControl.State = .normal) -> Self {
        setAttributedTitle(attrs, for: stat)
        return self
    }
    
    /// 设置icon image
    /// - Parameters:
    ///   - img: 图片
    ///   - stat: 状态
    /// - Returns: 自身(for chainable)
    @discardableResult
    func img(_ img: UIImage?, for stat: UIControl.State = .normal) -> Self {
        setImage(img, for: stat)
        return self
    }
    
    /// 设置image content mode
    /// - Parameters:
    ///   - mode: 模式
    /// - Returns: 自身(for chainable)
    @discardableResult
    func imgCntMode(_ mode: UIView.ContentMode) -> Self {
        imageView?.contentMode = mode
        return self
    }
    
    /// 设置image edge inset
    /// - Parameters:
    ///   - inset: inset
    /// - Returns: 自身(for chainable)
    @discardableResult
    func imgInsets(_ inset: UIEdgeInsets) -> Self {
        imageEdgeInsets = inset
        return self
    }
    
    /// 设置title edge inset
    /// - Parameters:
    ///   - inset: inset
    /// - Returns: 自身(for chainable)
    @discardableResult
    func titleInsets(_ inset: UIEdgeInsets) -> Self {
        titleEdgeInsets = inset
        return self
    }
    
    /// 设置content edge inset
    /// - Parameters:
    ///   - inset: inset
    /// - Returns: 自身(for chainable)
    @discardableResult
    func cntInsets(_ inset: UIEdgeInsets) -> Self {
        contentEdgeInsets = inset
        return self
    }
    
    /// 设置内容布局属性
    /// - Parameter attr: 属性
    /// - Returns: 自身(for chainable)
    @discardableResult
    func semanticCnt(_ attr: UISemanticContentAttribute) -> Self {
        semanticContentAttribute = attr
        return self
    }
    
    /// 设置背景图片
    /// - Parameters:
    ///   - img: 图片
    ///   - stat: 状态
    /// - Returns: 自身(for chainable)
    @discardableResult
    func bgImg(_ img: UIImage?, for stat: UIControl.State = .normal) -> Self {
        setBackgroundImage(img, for: stat)
        return self
    }
    
    /// 扩大点击区域
    /// - Parameter pt: 像素
    /// - Returns: 自身(for chainable)
    @discardableResult
    func expandTap(_ pt: CGFloat = 10) -> Self {
        expandTapZone(pt)
        return self
    }
    
    /// 阻止连击状态
    /// - Parameter prevent: 阻止
    /// - Returns: 自身(for chainable)
    @discardableResult
    func preventDblTap(_ prevent: Bool = true) -> Self {
        isPreventDouble = prevent
        return self
    }
    
    /// 连击间隔
    /// - Parameter interval: 间隔
    /// - Returns: 自身(for chainable)
    @discardableResult
    func doubleTap(_ interval: TimeInterval = 1) -> Self {
        eventInterval = interval
        return self
    }
    
    /// 设置专属点击
    /// - Parameter enable: 是否专属
    /// - Returns: 自身(for chainable)
    @discardableResult
    func exclusive(_ enable: Bool) -> Self {
        isExclusiveTouch = enable
        return self
    }
    
    /// 设置高亮
    /// - Parameter enable: 是否高亮
    /// - Returns: 自身(for chainable)
    @discardableResult
    func highlight(_ enable: Bool) -> Self {
        adjustsImageWhenHighlighted = enable
        return self
    }
}


// MARK: - 私有扩展
extension UIButton {
    private struct asKeys4Double {
        static var preventDouble = "preventDouble"
        static var eventInterval = "eventInterval"
        static var eventUnavailable = "eventUnavailable"
    }
    /// 重复点击的时间 属性设置
    fileprivate var eventInterval: TimeInterval {
        get {
            if let interval = objc_getAssociatedObject(self, &asKeys4Double.eventInterval) as? TimeInterval {
                return interval
            }
            return 1    //  默认1秒
        }
        set {
            objc_setAssociatedObject(self, &asKeys4Double.eventInterval, newValue as TimeInterval, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    /// 是否阻止双击事件(默认false)
    fileprivate var isPreventDouble: Bool {
        set {
            objc_setAssociatedObject(self, &asKeys4Double.preventDouble, newValue as Bool, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            if let prevent = objc_getAssociatedObject(self, &asKeys4Double.preventDouble) as? Bool {
                return prevent
            }
            return false
        }
    }
    /// 按钮不可点 属性设置
    fileprivate var eventUnavailable: Bool {
        get {
            if let unavailable = objc_getAssociatedObject(self, &asKeys4Double.eventUnavailable) as? Bool {
                return unavailable
            }
            return false
        }
        set {
            objc_setAssociatedObject(self, &asKeys4Double.eventUnavailable, newValue as Bool, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    /// 新建初始化方法,在这个方法中实现在运行时方法替换
    fileprivate class func hook4DoubleTapped() {
        let selector = #selector(UIButton.sendAction(_:to:for:))
        let newSelector = #selector(new_sendAction(_:to:for:))
        
        let method: Method = class_getInstanceMethod(UIButton.self, selector)!
        let newMethod: Method = class_getInstanceMethod(UIButton.self, newSelector)!
        
        if class_addMethod(UIButton.self, selector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod)) {
            class_replaceMethod(UIButton.self, newSelector, method_getImplementation(method), method_getTypeEncoding(method))
        } else {
            method_exchangeImplementations(method, newMethod)
        }
    }

    /// 在这个方法中
    @objc private func new_sendAction(_ action: Selector, to target: Any?, for event: UIEvent?) {
        guard isPreventDouble else {
            new_sendAction(action, to: target, for: event)
            return
        }
        if eventUnavailable == false {
            eventUnavailable = true
            new_sendAction(action, to: target, for: event)
            // 延时
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + eventInterval, execute: {
                self.eventUnavailable = false
            })
        }
    }
    /// 点击区域
    private struct asKeys4Hit {
        static var expandTap = "expandTap"
    }
    /// 扩大可点击区域 默认10像素
    fileprivate func expandTapZone(_ size: CGFloat = 10) {
        objc_setAssociatedObject(self, &asKeys4Hit.expandTap,size, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY)
    }
    /// 区域
    private func expandRect() -> CGRect {
        let expandSize = objc_getAssociatedObject(self, &asKeys4Hit.expandTap)
        if (expandSize != nil) {
            return CGRect(x: bounds.origin.x - (expandSize as! CGFloat), y: bounds.origin.y - (expandSize as! CGFloat), width: bounds.size.width + 2*(expandSize as! CGFloat), height: bounds.size.height + 2*(expandSize as! CGFloat))
        }else{
            return bounds
        }
    }
    /// 重写hitTest<extension需要去除public>
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let buttonRect = expandRect()
        if (buttonRect.equalTo(bounds)) {
            return super.point(inside: point, with: event)
        } else {
            return buttonRect.contains(point)
        }
    }
}
