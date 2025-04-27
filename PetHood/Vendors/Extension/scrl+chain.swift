//
//  scrl+chain.swift
//  AKExts
//
//  Created by edz on 6/19/21.
//

import UIKit

/// vue链式协议默认实现
public extension UIScrollView {
    
    /// 设置代理
    /// - Parameter target: 委托
    /// - Returns: 自身(for chainable)
    @discardableResult
    func proxy(_ target: UIScrollViewDelegate) -> Self {
        delegate = target
        return self
    }
    
    /// 设置分页
    /// - Parameter enable: 是否分页
    /// - Returns: 自身(for chainable)
    @discardableResult
    func paging(_ enable: Bool) -> Self {
        isPagingEnabled = enable
        return self
    }
    
    /// 设置contentOffset
    /// - Parameter offset: 偏移量
    /// - Returns: 自身(for chainable)
    @discardableResult
    func offset(_ offset: CGPoint) -> Self {
        contentOffset = offset
        return self
    }
    
    /// 设置contentSize
    /// - Parameter sz: 尺寸
    /// - Returns: 自身(for chainable)
    @discardableResult
    func cntSize(_ sz: CGSize) -> Self {
        contentSize = sz
        return self
    }
    
    /// 设置弹性效果
    /// - Parameter enable: 使能
    /// - Returns: 自身(for chainable)
    @discardableResult
    func bounce(_ enbale: Bool) -> Self {
        self.bounces = enbale
        return self
    }
    
    /// 设置方向弹性效果(如果true前提是bounce也得为true)
    /// - Parameter enable: 使能
    /// - Parameter axis: 轴向
    /// - Returns: 自身(for chainable)
    @discardableResult
    func alwaysBounce(_ enable: Bool, on axis: UIView.AxisDirect) -> Self {
        switch axis {
        case .vertical:
            alwaysBounceVertical = enable
        case .horizontal:
            alwaysBounceHorizontal = enable
        }
        return self
    }
    
    /// 设置滚动
    /// - Parameter enable: 是否滚动
    /// - Returns: 自身(for chainable)
    @discardableResult
    func scrollable(_ enable: Bool) -> Self {
        isScrollEnabled = enable
        return self
    }
    
    /// 是否可滚动到顶部
    /// - Parameter enable: Value
    /// - Returns: 自身(for chainable)
    @discardableResult
    func scrollTopable(_ enable: Bool) -> Self {
        scrollsToTop = enable
        return self
    }
    
    /// 设置滚动条
    /// - Parameter hShow: 水平条
    /// - Parameter vShow: 垂直条
    /// - Returns: 自身(for chainable)
    @discardableResult
    func scrollIndicator(_ hShow: Bool, vShow: Bool) -> Self {
        showsVerticalScrollIndicator = vShow
        showsHorizontalScrollIndicator = hShow
        return self
    }
    
    /// 设置内容调整模式
    /// - Parameter behavior: 样式
    /// - Returns: 自身(for chainable)
    @discardableResult
    @available(iOS 11.0, *)
    func adjustBehavior(_ behavior:ContentInsetAdjustmentBehavior) -> Self {
        contentInsetAdjustmentBehavior = behavior
        return self
    }
    
    /// 设置内容内嵌
    /// - Parameter inset: 内嵌
    /// - Returns: 自身(for chainable)
    @discardableResult
    func cntInset(_ inset: UIEdgeInsets) -> Self {
        contentInset = inset
        return self
    }
}
