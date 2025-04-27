//
//  BluetoothTool.swift
//  PetHood
//
//  Created by MacPro on 2024/7/25.
//

import Foundation

class BluetoothTool : NSObject {
    
    //通过蓝牙信号计算距离
   
    class func calculateDistance(_ RSSI: Int) -> Double? {
        /**
         d： 计算所得距离
         RSSI： 接收信号强度（负值）
         txPower： 发射端和接收端相隔1米时的信号强度
         pathLossFactor： 环境衰减因子
         */
        let txPower = -59  // 假设的发射单位的功率 (RSSI = txPower + N * 10^n)
        let pathLossFactor = 2.0 // 环境损失因子，通常取决于金属物体、墙壁、地板等
        let distance: Double
     
        if RSSI == 0 {
            return nil
        } else {
            distance = pow(10.0, (Double(RSSI) - Double(txPower)) / (10.0 * pathLossFactor))
        }
     
        return distance
    }
}
