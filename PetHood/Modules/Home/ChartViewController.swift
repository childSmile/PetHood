//
//  ChartViewController.swift
//  PetHood
//
//  Created by MacPro on 2024/8/12.
//

import UIKit
import DGCharts

enum Option {
    case toggleValues
    case toggleIcons
    case toggleHighlight
    case animateX
    case animateY
    case animateXY
    case saveToGallery
    case togglePinchZoom
    case toggleAutoScaleMinMax
    case toggleData
    case toggleBarBorders
    // LineChart
    case toggleGradientLine
    // CandleChart
    case toggleShadowColorSameAsCandle
    case toggleShowCandleBar
    // CombinedChart
    case toggleLineValues
    case toggleBarValues
    case removeDataSet
    // CubicLineSampleFillFormatter
    case toggleFilled
    case toggleCircles
    case toggleCubic
    case toggleHorizontalCubic
    case toggleStepped
    // HalfPieChartController
    case toggleXValues
    case togglePercent
    case toggleHole
    case spin
    case drawCenter
    case toggleLabelsMinimumAngle
    // RadarChart
    case toggleXLabels
    case toggleYLabels
    case toggleRotate
    case toggleHighlightCircle
    
    var label: String {
        switch self {
        case .toggleValues: return "Toggle Y-Values"
        case .toggleIcons: return "Toggle Icons"
        case .toggleHighlight: return "Toggle Highlight"
        case .animateX: return "Animate X"
        case .animateY: return "Animate Y"
        case .animateXY: return "Animate XY"
        case .saveToGallery: return "Save to Camera Roll"
        case .togglePinchZoom: return "Toggle PinchZoom"
        case .toggleAutoScaleMinMax: return "Toggle auto scale min/max"
        case .toggleData: return "Toggle Data"
        case .toggleBarBorders: return "Toggle Bar Borders"
        // LineChart
        case .toggleGradientLine: return "Toggle Gradient Line"
        // CandleChart
        case .toggleShadowColorSameAsCandle: return "Toggle shadow same color"
        case .toggleShowCandleBar: return "Toggle show candle bar"
        // CombinedChart
        case .toggleLineValues: return "Toggle Line Values"
        case .toggleBarValues: return "Toggle Bar Values"
        case .removeDataSet: return "Remove Random Set"
        // CubicLineSampleFillFormatter
        case .toggleFilled: return "Toggle Filled"
        case .toggleCircles: return "Toggle Circles"
        case .toggleCubic: return "Toggle Cubic"
        case .toggleHorizontalCubic: return "Toggle Horizontal Cubic"
        case .toggleStepped: return "Toggle Stepped"
        // HalfPieChartController
        case .toggleXValues: return "Toggle X-Values"
        case .togglePercent: return "Toggle Percent"
        case .toggleHole: return "Toggle Hole"
        case .spin: return "Spin"
        case .drawCenter: return "Draw CenterText"
        case .toggleLabelsMinimumAngle: return "Toggle Labels Minimum Angle"
        // RadarChart
        case .toggleXLabels: return "Toggle X-Labels"
        case .toggleYLabels: return "Toggle Y-Labels"
        case .toggleRotate: return "Toggle Rotate"
        case .toggleHighlightCircle: return "Toggle highlight circle"
        }
    }
}


class ChartViewController: ZBaseViewController {
    
    var options : [Option]!
    var chartView : LChartView!
    
    var sc = UIScrollView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navTitle = "Line Chart"
        
        initUI()

    }
    func initUI() {
        
        sc.frame(CGRect(x: 0, y: 0, width: view.frame.width, height: 400))
        sc.backgroundColor = .black.withAlphaComponent(0.2)
        sc.contentSize = CGSize(width: view.frame.width * 3, height: 400)
        sc.isPagingEnabled = true
        view.addSubview(sc)
        sc.lyt { make in
            make.top.equalTo(z_navgationBar.snp.bottom).offset(DHPXSW(s: 20))
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(DHPXSW(s: 400))
        }
        chartView = LChartView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 400))
        
        sc.addSubview(chartView)
        
    }
   

}
