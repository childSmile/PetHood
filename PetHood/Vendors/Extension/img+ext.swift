//
//  img+ext.swift
//  MeritInternation
//
//  Created by merit on 2023/10/31.
//

import Foundation
import UIKit

/// 渐变类型
public enum AKGradientType {
    case t2b    //  由上至下
    case l2r    //  由左至右
    case tl2br  //  左上至右下
    case tr2bl  //  右上至左下
}

extension UIImage {
    
    static func creatImage(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let img = image else { return UIImage() }
        return img
    }
    
    /**
    生成一个纯色的UIImage
    - parameter color: 颜色
                size：图片大小
    */
    static func createImg(_ color: UIColor, with size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(CGRect.init(origin: .zero, size: size))
        let resImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resImg
    
    }
    
    /**
     生成一个渐变 的UIImage
     - parameter colors: 渐变颜色数组
                 gradientType ：渐变样式
                 size：图片大小
     */
    static func createGradient(_ colors: [UIColor], with size: CGSize, and type: AKGradientType = .l2r) -> UIImage? {
        var cgColorArray : [CGColor] = []
        for color in colors {
            cgColorArray.append(color.cgColor)
        }
        UIGraphicsBeginImageContextWithOptions(size, true, 1.0)
        let context = UIGraphicsGetCurrentContext()
        context?.saveGState()
        let colorSpace = colors.last?.cgColor.colorSpace
        let gradient = CGGradient.init(colorsSpace: colorSpace,
                                       colors: cgColorArray as CFArray,
                                       locations: nil)
        var start = CGPoint.init(x: 0, y: 0)
        var end = CGPoint.init()
        switch type {
        case .t2b:
            end = CGPoint.init(x: 0, y: size.height)
        case .l2r:
            end = CGPoint.init(x: size.width, y: 0)
        case .tl2br:
            end = CGPoint.init(x: size.width, y: size.height)
        case .tr2bl:
            start = CGPoint.init(x: size.width, y: 0)
            end = CGPoint.init(x: 0, y: size.height)
        }
        guard let gradWrap = gradient else {
            return nil
        }
        context?.drawLinearGradient(gradWrap, start: start, end: end, options: [.drawsBeforeStartLocation, .drawsAfterEndLocation])
        let resImg = UIGraphicsGetImageFromCurrentImageContext()
        context?.restoreGState()
        UIGraphicsEndImageContext()
        return resImg
    }
    
    /**
     圆角化处理
     */
    func fillet(_ radius: CGFloat, with corners: UIRectCorner = .allCorners) -> UIImage? {
        let sz = self.size
        let bds = CGRect(origin: .zero, size: sz)
        //开始图形上下文
        UIGraphicsBeginImageContextWithOptions(sz, false, UIScreen.main.scale)
        defer {
            UIGraphicsEndImageContext() //关闭上下文
        }
        guard let ctx = UIGraphicsGetCurrentContext() else {
            return nil
        }
        let path = UIBezierPath(roundedRect: bds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        ctx.addPath(path.cgPath)
        ctx.clip()  //裁剪
        draw(in: bds) //将原图片画到图形上下文
        ctx.drawPath(using: .fillStroke)
        let output = UIGraphicsGetImageFromCurrentImageContext()
        return output
    }
    
    /// 生成纯色/描边/圆角图片
    /// - Parameters:
    ///   - fillColor: 底色
    ///   - size: 大小
    ///   - radius: 弧度
    ///   - borderWidth: 边框宽度
    ///   - borderColor: 边框颜色
    /// - Returns: 图片
    static func createRoundCorner(_ fillColor: UIColor, with size: CGSize, and radius: CGFloat, borderWidth: CGFloat = 0, borderColor: UIColor = .white) -> UIImage? {
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let destSize = CGSize(width: size.width*scale, height: size.height*scale)
        let rect = CGRect.init(origin: .zero, size: destSize)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(UIColor.clear.cgColor)
        context?.fill(rect)
        context?.setLineWidth(borderWidth)
        context?.setFillColor(fillColor.cgColor)
        context?.setStrokeColor(borderColor.cgColor)
        let bezi = UIBezierPath.init(roundedRect: rect, cornerRadius: radius)
        bezi.fill()
        bezi.stroke()
        let resImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resImg
    }
}
