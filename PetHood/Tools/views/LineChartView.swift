//
//  LineChartView.swift
//  PetHood
//
//  Created by MacPro on 2024/7/25.
//

import UIKit

/*
class LineChartView: UIView {

    private let lineColor = UIColor.blue.cgColor
    private let fillColor = UIColor.lightGray.cgColor
 
    var dataPoints: [CGFloat] = [] {
        didSet {
            setNeedsDisplay()
        }
    }
 
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
 
        let chartRect = rect.insetBy(dx: 20, dy: 20)
        let maxValue = dataPoints.max() ?? 0
        let points = dataPoints.map { CGFloat($0 / maxValue) * chartRect.height }
 
        // Draw the line path
        let linePath = UIBezierPath()
        for (index, point) in points.enumerated() {
            if index == 0 {
                linePath.move(to: CGPoint(x: chartRect.minX, y: point))
            } else {
                linePath.addLine(to: CGPoint(x: chartRect.minX + CGFloat(index) * chartRect.width / CGFloat(dataPoints.count - 1), y: point))
            }
        }
 
        // Configure the line
        context.setStrokeColor(lineColor)
        context.setLineWidth(2)
        context.addPath(linePath.cgPath)
        context.strokePath()
 
        // Fill the area under the line
        context.move(to: CGPoint(x: chartRect.minX, y: chartRect.maxY))
        context.addLine(to: CGPoint(x: chartRect.minX, y: chartRect.maxY - (points.last ?? 0)))
        for (index, point) in points.enumerated() {
            context.addLine(to: CGPoint(x: chartRect.minX + CGFloat(index) * chartRect.width / CGFloat(dataPoints.count - 1), y: chartRect.maxY - point))
        }
        context.closePath()
        context.setFillColor(fillColor)
        context.fillPath()
    }

}
*/
