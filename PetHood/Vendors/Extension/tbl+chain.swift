//
//  tbl+chain.swift
//  AKExts
//
//  Created by edz on 6/19/21.
//

import UIKit

/// 链式扩展
public extension UITableView {
    
    /// 设置代理
    /// - Parameter target: 委托
    /// - Returns: 自身(for chainable)
    @discardableResult
    func dlgProxy(_ target: UITableViewDelegate) -> Self {
        delegate = target
        return self
    }
    
    /// 设置数据源
    /// - Parameter target: 委托
    /// - Returns: 自身(for chainable)
    @discardableResult
    func dataProxy(_ target: UITableViewDataSource?) -> Self {
        dataSource = target
        return self
    }
    
    /// 注册 Cell
    /// - Parameter cls: 类型
    /// - Returns: 自身(for chainable)
    @discardableResult
    func regCell<T: UITableViewCell>(_ cls: T.Type) -> Self {
        let idf = String(describing: cls)
        register(cls, forCellReuseIdentifier: idf)
        return self
    }
    
    /// 注册SB Cell
    /// - Parameter cls: 类型
    /// - Returns: 自身(for chainable)
    @discardableResult
    func regNibCell<T: UITableViewCell>(_ cls: T.Type) -> Self {
        let idf = String(describing: cls)
        let nib = UINib(nibName: idf, bundle: nil)
        register(nib, forCellReuseIdentifier: idf)
        return self
    }
    
    /// 重用Cell
    /// - Parameters:
    ///   - cls: 类型
    ///   - forIndexPath: 索引
    /// - Returns: cell
    func dequeueReusable<T: UITableViewCell>(_ cls: T.Type, for forIndexPath: IndexPath) -> T {
        let idf = String(describing: cls)
        guard let cell = dequeueReusableCell(withIdentifier: idf, for: forIndexPath) as? T else {
            fatalError("\(idf) is not registed")
        }
        return cell
    }
    
    /// 注册头尾
    /// - Parameters:
    ///   - cls: 类型
    ///   - kind: 类别
    /// - Returns: 自身(for chainable)
    @discardableResult
    func regHeaderFooter<T: UIView>(_ cls: T.Type) -> Self {
        let idf = String(describing: cls)
        register(cls, forHeaderFooterViewReuseIdentifier: idf)
        return self
    }
    /// 注册SB 头尾
    /// - Parameters:
    ///   - cls: 类型
    ///   - kind: 类别
    /// - Returns: 自身(for chainable)
    @discardableResult
    func regHeaderFooterNib<T: UIView>(_ cls: T.Type) -> Self {
        let idf = String(describing: cls)
        let nib = UINib(nibName: idf, bundle: nil)
        register(nib, forHeaderFooterViewReuseIdentifier: idf)
        return self
    }
    
    /// 重用头尾
    /// - Parameters:
    ///   - cls: 类型
    ///   - kind: 类别
    ///   - forIndexPath: 索引
    /// - Returns: 头尾
    func dequeueReusableHeaderFooter<T: UIView>(_ cls: T.Type) -> T {
        let idf = String(describing: cls)
        guard let vue = dequeueReusableHeaderFooterView(withIdentifier: idf) as? T else {
            fatalError("\(idf) is not registed")
        }
        return vue
    }
    
    /// 设置背景view
    /// - Parameters:
    ///   - vue: view
    /// - Returns: 自身(for chainable)
    @discardableResult
    func bgVue(_ vue: UIView?) -> Self {
        backgroundView = vue
        return self
    }
    
    /// 设置头部
    /// - Parameters:
    ///   - vue: view
    /// - Returns: 自身(for chainable)
    @discardableResult
    func headerVue(_ vue: UIView?) -> Self {
        tableHeaderView = vue
        return self
    }
    
    /// 设置尾部
    /// - Parameters:
    ///   - vue: view
    /// - Returns: 自身(for chainable)
    @discardableResult
    func footerVue(_ vue: UIView?) -> Self {
        tableFooterView = vue
        return self
    }
    
    /// 设置行高
    /// - Parameters:
    ///   - height: 高度
    /// - Returns: 自身(for chainable)
    @discardableResult
    func rowH(_ height: CGFloat) -> Self {
        rowHeight = height
        return self
    }
    
    /// 设置预估行高
    /// - Parameters:
    ///   - height: 高度
    /// - Returns: 自身(for chainable)
    @discardableResult
    func estimatedRowH(_ height: CGFloat) -> Self {
        estimatedRowHeight = height
        return self
    }
    
    /// 设置预估header height
    /// - Parameters:
    ///   - height: 高度
    /// - Returns: 自身(for chainable)
    @discardableResult
    func estimatedHeaderH(_ height: CGFloat) -> Self {
        estimatedSectionHeaderHeight = height
        return self
    }
    
    /// 设置预估footer height
    /// - Parameters:
    ///   - height: 高度
    /// - Returns: 自身(for chainable)
    @discardableResult
    func estimatedFooterH(_ height: CGFloat) -> Self {
        estimatedSectionFooterHeight = height
        return self
    }
    
    /// 设置分割样式
    /// - Parameters:
    ///   - style: 样式
    /// - Returns: 自身(for chainable)
    @discardableResult
    func sepStyle(_ style: UITableViewCell.SeparatorStyle) -> Self {
        separatorStyle = style
        return self
    }
    
    /// 设置是否可选
    /// - Parameters:
    ///   - enable: 使能
    /// - Returns: 自身(for chainable)
    @discardableResult
    func allowSelect(_ enable: Bool) -> Self {
        allowsSelection = enable
        return self
    }
    
    /// 设置分割内嵌
    /// - Parameters:
    ///   - inset: inset
    /// - Returns: 自身(for chainable)
    @discardableResult
    func sepInset(_ inset: UIEdgeInsets) -> Self {
        separatorInset = inset
        return self
    }
    
    /// 设置分割颜色
    /// - Parameters:
    ///   - color: 颜色
    /// - Returns: 自身(for chainable)
    @discardableResult
    func sepColor(_ color: UIColor?) -> Self {
        separatorColor = color
        return self
    }
    
    /// 设置section header 高度
    /// - Parameter height: 高度
    /// - Returns: 自身(for chainable)
    @discardableResult
    func sectH4Header(_ height: CGFloat) -> Self {
        sectionHeaderHeight = height
        return self
    }
    
    /// 设置section footer 高度
    /// - Parameter height: 高度
    /// - Returns: 自身(for chainable)
    @discardableResult
    func sectH4Footer(_ height: CGFloat) -> Self {
        sectionFooterHeight = height
        return self
    }
    
    /// 设置section header top padding 高度
    /// - Parameter height: 高度
    /// - Returns: 自身(for chainable)
    @discardableResult
    func sectHeaderTopPadding(_ pad: CGFloat) -> Self {
        if #available(iOS 15.0, *) {
            sectionHeaderTopPadding = pad
        }
        return self
    }
    
    /// 设置filler row高度
    /// - Parameter height: 高度
    /// - Returns: 自身(for chainable)
    @discardableResult
    func fillerRowH(_ height: CGFloat) -> Self {
        if #available(iOS 15.0, *) {
            fillerRowHeight = height
        }
        return self
    }
    
    /// 设置prefetching
    /// - Parameter enable: 使能
    /// - Returns: 自身(for chainable)
    @discardableResult
    func prefetching(_ enable: Bool) -> Self {
        if #available(iOS 15.0, *) {
            isPrefetchingEnabled = enable
        }
        return self
    }
    
    /// 禁用iOS15新特性
    /// - Returns: 自身(for chainable)
    @discardableResult
    func disabeiOS15NewFeatures() -> Self {
        return self
            .fillerRowH(0)
            .prefetching(false)
            .sectHeaderTopPadding(0)
    }
    
    /// 确保滚动到顶部
    /// - Returns: 自身(for chainable)
    @discardableResult
    func ensureScroll2Top() -> Self {
        beginUpdates()
        setContentOffset(.zero, animated: false)
        endUpdates()
        return self
    }
}
