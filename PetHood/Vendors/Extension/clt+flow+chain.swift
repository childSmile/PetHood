//
//  clt+flow+chain.swift
//  AKExts
//
//  Created by edz on 6/30/21.
//

import UIKit

/// 链式扩展
public extension UICollectionViewFlowLayout {
    
    /// 滚动方向
    /// - Parameters:
    ///   - direct: 方向
    /// - Returns: 自身(for chainable)
    @discardableResult
    func scrollDirect(_ direct: UICollectionView.ScrollDirection) -> Self {
        scrollDirection = direct
        return self
    }
    
    /// 设置item-size
    /// - Parameters:
    ///   - sz: size
    /// - Returns: 自身(for chainable)
    @discardableResult
    func setItemSize(_ sz: CGSize) -> Self {
        itemSize = sz
        return self
    }
    
    /// item行间距
    /// - Parameters:
    ///   - sapce: 间距
    /// - Returns: 自身(for chainable)
    @discardableResult
    func minSpacingLine(_ space: CGFloat) -> Self {
        minimumLineSpacing = space
        return self
    }
    
    /// item最小间距
    /// - Parameters:
    ///   - space: 间距
    /// - Returns: 自身(for chainable)
    @discardableResult
    func minSpacingInter(_ space: CGFloat) -> Self {
        minimumInteritemSpacing = space
        return self
    }
    
    /// section inset
    /// - Parameters:
    ///   - inset: UIEdgeInset
    /// - Returns: 自身(for chainable)
    @discardableResult
    func inset4Section(_ inset: UIEdgeInsets) -> Self {
        sectionInset = inset
        return self
    }
    
    /// sticky header
    /// - Parameters:
    ///   - pinned: pinned for header
    /// - Returns: 自身(for chainable)
    @discardableResult
    func headerSticky(_ pinned: Bool) -> Self {
        sectionHeadersPinToVisibleBounds = pinned
        return self
    }
    
    /// sticky footer
    /// - Parameters:
    ///   - pinned: pinned for footer
    /// - Returns: 自身(for chainable)
    @discardableResult
    func footerSticky(_ pinned: Bool) -> Self {
        sectionFootersPinToVisibleBounds = pinned
        return self
    }
    
    /// head size
    /// - Parameter sz: size
    /// - Returns: 自身(for chainable)
    @discardableResult
    func headerSize(_ sz: CGSize) -> Self {
        headerReferenceSize = sz
        return self
    }
    
    /// foot size
    /// - Parameter sz: size
    /// - Returns: 自身(for chainable)
    @discardableResult
    func footerSize(_ sz: CGSize) -> Self {
        footerReferenceSize = sz
        return self
    }
}
