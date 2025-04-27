//
//  clv+chain.swift
//  AKExts
//
//  Created by edz on 6/19/21.
//

import UIKit

/// 链式扩展
public extension UICollectionView {
    
    /// 设置代理
    /// - Parameter target: 委托
    /// - Returns: 自身(for chainable)
    @discardableResult
    func dlgProxy(_ target: UICollectionViewDelegate) -> Self {
        delegate = target
        return self
    }
    
    /// 设置数据源
    /// - Parameter target: 委托
    /// - Returns: 自身(for chainable)
    @discardableResult
    func dataProxy(_ target: UICollectionViewDataSource?) -> Self {
        dataSource = target
        return self
    }
    
    /// 注册 Cell
    /// - Parameter cls: 类型
    /// - Returns: 自身(for chainable)
    @discardableResult
    func regCell<T: UICollectionViewCell>(_ cls: T.Type) -> Self {
        let idf = String(describing: cls)
        register(cls, forCellWithReuseIdentifier: idf)
        return self
    }
    
    /// 注册SB Cell
    /// - Parameter cls: 类型
    /// - Returns: 自身(for chainable)
    @discardableResult
    func regNibCell<T: UICollectionViewCell>(_ cls: T.Type) -> Self {
        let idf = String(describing: cls)
        let nib = UINib(nibName: idf, bundle: nil)
        register(nib, forCellWithReuseIdentifier: idf)
        return self
    }
    
    /// 重用Cell
    /// - Parameters:
    ///   - cls: 类型
    ///   - forIndexPath: 索引
    /// - Returns: cell
    func dequeueReusable<T: UICollectionViewCell>(_ cls: T.Type, for forIndexPath: IndexPath) -> T {
        let idf = String(describing: cls)
        guard let cell = dequeueReusableCell(withReuseIdentifier: idf, for: forIndexPath) as? T else {
            fatalError("\(idf) is not registed")
        }
        return cell
    }
    
    /// 分区kind类型
    enum SectionKindType: String, CaseIterable {
        case header
        case footer
        // king标识
        var idtifier: String {
            switch self {
            case .header:
                return UICollectionView.elementKindSectionHeader
            case .footer:
                return UICollectionView.elementKindSectionFooter
            }
        }
    }
    
    /// 注册头尾
    /// - Parameters:
    ///   - cls: 类型
    ///   - kind: 类别
    /// - Returns: 自身(for chainable)
    @discardableResult
    func regHeaderFooter<T: UICollectionReusableView>(_ cls: T.Type, for kind: SectionKindType = .header) -> Self {
        let idf = String(describing: cls)
        register(cls, forSupplementaryViewOfKind: kind.idtifier, withReuseIdentifier: idf)
        return self
    }
    
    /// 注册SB 头尾
    /// - Parameters:
    ///   - cls: 类型
    ///   - kind: 类别
    /// - Returns: 自身(for chainable)
    @discardableResult
    func regHeaderFooterNib<T: UICollectionReusableView>(_ cls: T.Type, for kind: SectionKindType) -> Self {
        let idf = String(describing: cls)
        let nib = UINib(nibName: idf, bundle: nil)
        register(nib, forSupplementaryViewOfKind:kind.idtifier , withReuseIdentifier: idf)
        return self
    }
    
    /// 重用头尾
    /// - Parameters:
    ///   - cls: 类型
    ///   - kind: 类别
    ///   - forIndexPath: 索引
    /// - Returns: 头尾
    func dequeueReusableHeaderFooter<T: UICollectionReusableView>(_ cls: T.Type, kind: SectionKindType, for forIndexPath: IndexPath) -> T {
        let idf = String(describing: cls)
        guard let vue = dequeueReusableSupplementaryView(ofKind: kind.idtifier, withReuseIdentifier: idf, for: forIndexPath) as? T else {
            fatalError("\(idf) is not registed")
        }
        return vue
    }
}
