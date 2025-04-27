//
//  PHData.swift
//  PetHood
//
//  Created by MacPro on 2024/9/6.
//

import UIKit

let serviceUUID               = "FFF0"
let writeCharacteristicUUID   = "FFF1"
let notifyCharacteristicUUID  = "FFF2"

let packageHeadData : UInt8  = 0xAA
let packageFootData : UInt8 = 0x55


enum PHBLUEDATATYPE : UInt8 {
    case control   = 0x00 // 控制爆闪灯
    case syncTime  = 0x01 // 时间同步
    case syncData  = 0x10 // 运动数据获取
}

enum LightType : UInt8 {
    case alwaysOn          = 0x00  // 常亮
    case alwaysOff         = 0x01  // 常灭
    case quickFlashing     = 0x02  // 快闪   0.2s 频率闪烁
    case slowFlashing      = 0x03  // 快灭   0.5s 频率闪烁
    case breathingLight    = 0x04  // 呼吸灯
}

enum DataStep : UInt8 {
    case request        = 0x00  // 数据请求步骤码
    case package        = 0x01  // 分包步骤码
    case clear          = 0x02  // 擦除步骤码
}

let packageHeadLength           = 1
let packageDataTypeLength       = 1
let packageDataLength           = 2
let packageCrcLength            = 1
let packageFootLength           = 1
/**
 
 包头(1) + 数据类型(1) + 数据长度(2) + 数据内容 + 校验码(1) + 包尾(1)
 包头 U8 ：packageHeadData
 数据类型 U8： PHBLUEDATATYPE
 数据长度 U16： 数据内容的长度
 校验码 U8： (包头 + 数据类型 + 数据长度 + 数据内容)异或校验
 包尾 U8：packageFootData
 
 */

class PHData: NSObject {
    
    
    class func controlLight(_ status:UInt8) -> Data {
        
        var values = [
            packageHeadData ,
            PHBLUEDATATYPE.control.rawValue ,
        ]
        
        values.append(contentsOf: numberTobytes((0x01),length: 2))
        values.append(status)
        
        let crc = xorCalc(values)
        values.append(crc)
        values.append(packageFootData)
        
        let data = Data(values)
        
        return data
    }
    
    class func syncTime(_ time:Int) -> Data {
        
        var values = [
            packageHeadData ,
            PHBLUEDATATYPE.syncTime.rawValue ,
        ]
        
        values.append(contentsOf: numberTobytes((0x04),length: 2))
        values.append(contentsOf: numberTobytes(Int(time),length: 4))
        
        let crc = xorCalc(values)
        values.append(crc)
        values.append(packageFootData)
        
        let data = Data(values)
        
        return data
        
    }
    
    class func syncDataRequest() -> Data {
        var values = [
            packageHeadData ,
            PHBLUEDATATYPE.syncData.rawValue ,
        ]
        values.append(contentsOf: numberTobytes((0x01),length: 2))
        values.append(DataStep.request.rawValue) // 步骤码
        
        let crc = xorCalc(values)
        values.append(crc)
        values.append(packageFootData)
        
        let data = Data(values)
        
        return data
    }
    
  
    class func syncDataPackage(_ number:Int) -> Data {
        var values = [
            packageHeadData ,
            PHBLUEDATATYPE.syncData.rawValue ,
        ]
        values.append(contentsOf: numberTobytes((0x05),length: 2))
        values.append(DataStep.package.rawValue) // 步骤码
        values.append(contentsOf: numberTobytes((number),length: 4))
        
        let crc = xorCalc(values)
        values.append(crc)
        values.append(packageFootData)
        
        let data = Data(values)
        
        return data
    }
    
    class func syncDataClear() -> Data {
        var values = [
            packageHeadData ,
            PHBLUEDATATYPE.syncData.rawValue ,
        ]
        values.append(contentsOf: numberTobytes((0x01),length: 2))
        values.append(DataStep.clear.rawValue) // 步骤码
        
        let crc = xorCalc(values)
        values.append(crc)
        values.append(packageFootData)
        
        let data = Data(values)
        
        return data
    }

}

// MARK: - data 工具
extension PHData {
    
   class func xorCalc(_ values:[UInt8]) -> UInt8 {
        var crc : UInt8 = 0
        for (_, item) in values.enumerated() {
            crc ^= item
        }
       print("xor==\(crc)")
        return crc
    }
    
    
    class func xorDataCalc(_ data:Data) -> UInt8 {
        let bytes = [UInt8](data)
        return xorCalc(bytes)
     }
    
    
    
    /// Int -> Data
    /// - Parameters:
    ///   - num: 需要转换的数据
    ///   - length: 转成几位
    ///   - big: 是否转为大端 , 默认 false 即小端
    /// - Returns: [UInt8]
    class func numberTobytes(_ num:Int ,  length:Int = 2 ,  big:Bool = false) -> [UInt8] {
        
        switch length {
        case 2:
            var value = UInt16(num)
            value = big ? UInt16(bigEndian: value) : value
            return withUnsafeBytes(of: &value, Array.init)
        case 4:
            var value = UInt32(num)
            value = big ? UInt32(bigEndian: value) : value
            return withUnsafeBytes(of: &value, Array.init)
        case 8:
            var value = UInt64(num)
            value = big ? UInt64(bigEndian: value) : value
            return withUnsafeBytes(of: &value, Array.init)
    
        default:
            break
        }
        
        return []
    }
    
    /// data ->int
    /// - Parameters:
    ///   - data: data
    ///   - big: 是否是大端 , 默认 false 即小端
    /// - Returns: int
    class func dataToInt(_ data:Data? , _ big:Bool = false) -> Int {
 
        guard let originData = data else {return 0}
        let bytes = [UInt8](originData)
        let res = PHData.bytesToInt(bytes, big)
        print("dataToInt==\(res)")
        
        return res
    }
    
    class func bytesToInt(_ array:[UInt8] , _ big:Bool = false) -> Int {
        var value : UInt32 = 0
        let data = NSData(bytes: array, length: array.count)
        data.getBytes(&value, length: array.count)
        if big {
            value = UInt32(bigEndian: value)
        }
        return Int(value)
    }
}
