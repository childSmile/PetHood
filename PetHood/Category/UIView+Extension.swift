//
//  UIView+toast.swift
//  PetHood
//
//  Created by MacPro on 2024/7/15.
//

import Foundation

extension UIView {
    //时间默认3秒
    func toast(_ title:String) {
        self.makeToast(title , position: .center )
    }
    
    
    
    func toImage() -> UIImage? {
        // 开始图形上下文并设置缩放比例
        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0.0)
        defer { UIGraphicsEndImageContext() } // 确保上下文能被清除
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        // 将UIView渲染到图形上下文中
        layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        return image
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
           let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
           let mask = CAShapeLayer()
           mask.path = path.cgPath
           self.layer.mask = mask
       }
    
    
    
    func addDashedLine(from point1: CGPoint, to point2: CGPoint, dashColor: UIColor, lineWidth: CGFloat, dashLength: Int, spaceLength: Int) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = dashColor.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.fillColor = nil
 
        let path = UIBezierPath()
        path.move(to: point1)
        path.addLine(to: point2)
 
        let dashes: [NSNumber] = [NSNumber(value: dashLength), NSNumber(value: spaceLength)]
        shapeLayer.lineDashPattern = dashes
 
        shapeLayer.path = path.cgPath
        layer.addSublayer(shapeLayer)
    }
}


