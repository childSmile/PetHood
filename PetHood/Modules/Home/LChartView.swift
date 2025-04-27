//
//  LChartView.swift
//  PetHood
//
//  Created by MacPro on 2024/8/26.
//

import UIKit
import DGCharts

class LChartView: UIView {
    
    var chartView : LineChartView!
    var options : [Option]!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initUI()
        
    }
    
    func initUI() {
        options = [.toggleValues, // 是否在点上显示数值 drawValuesEnabled
                   .toggleFilled, //是否有填充色 drawFilledEnabled
                   .toggleCircles, //是否画点 drawCirclesEnabled
                   .toggleCubic, // 连线方式 线型or弧度  set.mode = (set.mode == .cubicBezier) ? .linear : .cubicBezier
                   .toggleHorizontalCubic,
                   .toggleIcons,  //设置点的图片 drawIconsEnabled
                   .toggleStepped, // 连线方式
                   .toggleHighlight,  // 是否可以选中 isHighlightEnabled
                   .toggleGradientLine,
                   .animateX,
                   .animateY,
                   .animateXY,
                   .saveToGallery, //保存到相册 UIImageWriteToSavedPhotosAlbum(chartView.getChartImage(transparent: false)!, nil, nil, nil)
                   .togglePinchZoom,
                   .toggleAutoScaleMinMax,
                   .toggleData]
        
        chartView = LineChartView(frame: CGRect(x: 0, y: 0, width: self.frame.width * 3, height: 400))
        
        self.addSubview(chartView)
        
        chartView.delegate = self
        chartView.chartDescription.enabled = false
        chartView.dragEnabled = false
        chartView.setScaleEnabled(false)
        chartView.pinchZoomEnabled = false
        
        //x 限制线
        let llxAxis = ChartLimitLine(limit: 20 , label: "Index 10")
        llxAxis.lineWidth = 4
        llxAxis.lineDashLengths = [10 , 10 , 0]
        llxAxis.labelPosition = .rightBottom
        llxAxis.valueFont = .systemFont(ofSize: 10)
        llxAxis.lineColor = .red
        
        
        // 竖轴
        chartView.xAxis.gridLineDashLengths = [10 , 5]
        chartView.xAxis.gridLineDashPhase = 0
        chartView.xAxis.gridColor = .red
        chartView.xAxis.labelTextColor = .purple
        chartView.xAxis.labelFont = .boldSystemFont(ofSize: 10)
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.labelCount = 10
        
        
        // y-max 限制线
        let ll1 = ChartLimitLine(limit: 150, label: "Upper Limit")
        ll1.lineWidth = 4
        ll1.lineDashLengths = [5 ,5]
        ll1.labelPosition = .rightTop
        ll1.valueFont = .systemFont(ofSize: 10)
        
        
        // y-min 限制线
        let ll2 = ChartLimitLine(limit: -30, label: "Lower Limit")
        ll2.lineWidth = 4
        ll2.lineDashLengths = [10, 5]
        ll2.labelPosition = .rightBottom
        ll2.valueFont = .systemFont(ofSize: 10)
        ll2.lineColor = .blue
        
        
        //横轴
        let leftAxis = chartView.leftAxis
        leftAxis.removeAllLimitLines()
//        leftAxis.addLimitLine(ll1)
//        leftAxis.addLimitLine(ll2)
        leftAxis.axisMaximum = 150 //表格 y-max
        leftAxis.axisMinimum = -50 //表格 y-min
        leftAxis.gridLineDashLengths = [5 , 5]
        leftAxis.drawLimitLinesBehindDataEnabled = true
        leftAxis.gridColor = .yellow
        //y 轴 label
        leftAxis.labelTextColor = .brown
        leftAxis.labelFont = .systemFont(ofSize: 8)
        leftAxis.labelPosition = .outsideChart
        
        
    
        
        chartView.rightAxis.enabled = false
        
        //选中点的mark
        let marker = BalloonMarker(color: .cyan,
                                   font: .systemFont(ofSize: 12),
                                   textColor: .random(),
                                   insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8))
        marker.chartView = chartView
        marker.minimumSize = CGSizeMake(80, 40)
        chartView.marker = marker
        
        //表名前的显示 line --
        chartView.legend.form = .circle
        
        chartView.animate(xAxisDuration: 2.5)
        
        setDataCount(30, range: 100)
        
    }
    
    func setDataCount( _ count:Int , range:UInt32) {
        let values = (0..<count).map { (i) -> ChartDataEntry   in
            let val = Double(arc4random_uniform(range) + 3)
            return ChartDataEntry(x: Double(i), y: val )
            //设置自定义图片
//            return ChartDataEntry(x: Double(i), y: val, icon: #imageLiteral(resourceName: "icon"))
        }
        
        let set1 = LineChartDataSet(entries: values, label: "DataSet 1")
        set1.drawCirclesEnabled = true
        setup(set1)
        
        //额外添加的点
        let value = ChartDataEntry(x: Double(3), y: 10)
        set1.addEntryOrdered(value)
        
        //渐变色
        let gradientColors = [ChartColorTemplates.colorFromString("#0000ff00").cgColor,
                              ChartColorTemplates.colorFromString("#ff00ff00").cgColor]
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!

        set1.fillAlpha = 1
        set1.fill = LinearGradientFill(gradient: gradient, angle: 90)
        set1.drawFilledEnabled = true

        let data = LineChartData(dataSet: set1)

        chartView.data = data
        
        
    }
    
    
    //连线所有的点 ， 连线的样式
    func setup(_ dataSet:LineChartDataSet) {
        if dataSet.isDrawLineWithGradientEnabled {
            dataSet.lineDashLengths = nil
            dataSet.highlightLineDashLengths = nil
            dataSet.setColors(.black , .red , .white)
            dataSet.setCircleColor(.blue)
            dataSet.gradientPositions = [0 , 40 , 100]
            dataSet.lineWidth  = 1
            dataSet.circleRadius = 3
            dataSet.drawCircleHoleEnabled = false
            dataSet.valueFont = .systemFont(ofSize: 9)
            dataSet.formLineDashLengths = nil
            dataSet.formLineWidth = 1
            dataSet.formSize = 15
        } else {
            dataSet.lineDashLengths = [5, 0]
            dataSet.highlightLineDashLengths = [5, 2.5]
            dataSet.setColor(.blue)
            dataSet.setCircleColor(.red)
            dataSet.gradientPositions = nil
            dataSet.lineWidth = 1
            dataSet.circleRadius = 3
            dataSet.drawCircleHoleEnabled = true
            dataSet.valueFont = .systemFont(ofSize: 9)
            dataSet.valueColors = [.green]
            dataSet.formLineDashLengths = [5, 2.5]
            dataSet.formLineWidth = 1
            dataSet.formSize = 15
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}


extension LChartView : ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print("chartValueSelected==x:\(entry.x) , y:\(entry.y)")
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        print("chartValueNothingSelected")
    }
    
}
