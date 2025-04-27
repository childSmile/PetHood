//
//  BlueOperationManager.swift
//  PetHood
//
//  Created by MacPro on 2024/9/11.
//

import Foundation
import CoreBluetooth

//泰凌微OTA
let kOTAServiceUUID      =    "00010203-0405-0607-0809-0A0B0C0D1912"
let kOTACharacteristics  =    "00010203-0405-0607-0809-0A0B0C0D2B12"

//设备信息
let kDeviceInfoServiceUUID = "180A"
let kPowerCharacteristics  = "2A23"

//通信
let kDataServiceUUID           =    "FFF0"
let kDataWriteCharacteristics  =    "FFF1"
let kDatanReadCharacteristics  =    "FFF2"

struct ConnectPeriphralModel {
    var localName: String
    var peripheral: CBPeripheral
    var writeCharacteristics : CBCharacteristic?
    var otaCharacteristics : CBCharacteristic?
}


class BlueOperationManager : NSObject{
    
    static let shared = BlueOperationManager()
    
    //电量
    var syncPower : ((Int)->Void)?
    var syncDeviceInfo: ((String , String)->Void)?
    
    //同步数据
    var syncDataPackage : (( Int, Int)->Void)?
    var syncData : ((Int, Data)->Void)?
    var syncClear : ((Int)->Void)?
    
    //连接以后存储
    var peripheralDic : [String : ConnectPeriphralModel] = [:]
    fileprivate var connectName : String?
    
    private override init() {
        super.init()
        let manager = BluetoothManager.shared
        manager.centerDelegate = self
        
    }
    
    
    func connectDevice(name:String) {
        connectName = name
        BluetoothManager.shared.startScan()
    }
    
    func startScan() {
        BluetoothManager.shared.startScan()
    }
    
    
//    func startSyncData(_ localName:String) {
//        guard let model = peripheralDic[localName] else {return}
//        var data = PHData.syncDataRequest()
//        sendData(localName , data)
//        
//        
//    }
    
    func sendData(_ localName:String , _ data:Data) {
        guard let model = peripheralDic[localName] else {return}
        BluetoothManager.shared.sendData(data, model.writeCharacteristics, model.peripheral)
    }
    
}

// MARK: - CBCentralManagerDelegate
extension BlueOperationManager : CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("centralManagerDidUpdateState==\(central.state)")
        if central.state != CBManagerState.poweredOn {
            peripheralDic.removeAll()
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        guard let localName = peripheral.name else{
            return
        }
        
        
        if (localName == connectName) {
            BluetoothManager.shared.connectPeriphral(peripheral)
        }
        //        let distance = BluetoothTool.calculateDistance(RSSI.intValue)
        print("discover===\(peripheral),RSSI==\(RSSI)))") //kCBAdvDataLocalName
    }
    
    
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("连接成功")
        
        if let localName = connectName {
            let model = ConnectPeriphralModel(localName: localName, peripheral: peripheral)
            peripheralDic.updateValue(model, forKey: localName)
        }
        
        connectName = nil
        
        peripheral.delegate = self
        
        peripheral.discoverServices(nil)
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: (any Error)?) {
        print("断开连接 === \(peripheral) , error==\(String(describing: error?.localizedDescription))")
        guard let model = self.connectModelFromPeriphral(peripheral) else {return}
        peripheralDic.removeValue(forKey: model.localName)
    }
    
}

// MARK: - CBPeripheralDelegate
extension BlueOperationManager : CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: (any Error)?) {
        print("didDiscoverServices==")
        
        guard let services = peripheral.services else {return}
        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: (any Error)?) {
        print("didDiscoverCharacteristicsFor==")
        
        guard let chs = service.characteristics ,
              var model = self.connectModelFromPeriphral(peripheral) else {return}
        
        for ch in chs {
            if ch.properties == .read {
                peripheral.readValue(for: ch)
            } else if service.uuid.uuidString.uppercased() == kOTAServiceUUID && ch.uuid.uuidString.uppercased() == kOTACharacteristics {
                model.otaCharacteristics = ch
            } else if service.uuid.uuidString.uppercased() == kDataServiceUUID && ch.uuid.uuidString.uppercased() == kDataWriteCharacteristics {
                model.writeCharacteristics = ch
            }
        }
        
    }
    
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: (any Error)?) {
        print("接收到蓝牙数据===\(characteristic)")
        
        if characteristic.service?.uuid.uuidString.uppercased() == kDeviceInfoServiceUUID {
            guard let value = characteristic.value else {return}
            let data = PHData.dataToInt(value)
            syncDeviceInfo?(characteristic.uuid.uuidString.uppercased() , String(data))
            
//            if characteristic.uuid.uuidString.uppercased() == kPowerCharacteristics {
//                print("获取到电量==")
//                guard let value = characteristic.value else {return}
//                let power = PHData.dataToInt(value)
//                syncPower?(power)
//            }
        }
        
        if characteristic.service?.uuid.uuidString.uppercased() == kDataServiceUUID {
            if characteristic.uuid.uuidString.uppercased() == kDatanReadCharacteristics {
                let value = characteristic.value
                dealData(value, characteristic, peripheral)
            }
        }
    }
    
    
    
    func connectModelFromPeriphral( _ periphral:CBPeripheral) -> ConnectPeriphralModel? {
        var model : ConnectPeriphralModel?
        for m in peripheralDic.values {
            if m.peripheral.isEqual(periphral) {
                model = m
                break
            }
        }
        return model
    }
    
    
}

// MARK: - 处理数据
extension BlueOperationManager {
    
    func dealData(_ data:Data? , _ characteristic:CBCharacteristic? , _ peripheral:CBPeripheral?) {
        guard let value = data else {return}
        
        var endIndex = 0
        var startIndex = 0
        
        endIndex = value.count - packageCrcLength - packageFootLength
        let crcContentData = value.subdata(in: startIndex..<endIndex)
        let crc = PHData.xorDataCalc(crcContentData)
        
        print("crcContentData==\(crcContentData.hexString())")
        
        startIndex = value.count - 1 - packageFootLength
        endIndex = startIndex + packageCrcLength
        let crcData = value.subdata(in:startIndex..<endIndex)
        
        print("crcData==\(crcData.hexString())")
        
        //校验crc
        if crcData != Data([crc]) {
            return
        }
        
        startIndex = packageHeadLength
        endIndex = startIndex + packageDataTypeLength
        let cmdData = value.subdata(in: startIndex..<endIndex)
        
        print("cmdData=\(cmdData.hexString())")
        
        startIndex = endIndex
        endIndex = startIndex + packageDataLength
        let lengthData = value.subdata(in: startIndex..<endIndex)
        
        print("lengthData=\(lengthData.hexString())")
        let length = PHData.dataToInt(lengthData)
        
        startIndex = endIndex
        endIndex = value.count - packageCrcLength - packageFootLength
        let contentData = value.subdata(in: startIndex..<endIndex)
        
        print("contentData=\(contentData.hexString())")
        
        //长度校验
        if contentData.count != length {
            return
        }
        
        if cmdData == Data([PHBLUEDATATYPE.control.rawValue]) {
            //控制
            
        } else if cmdData == Data([PHBLUEDATATYPE.syncTime.rawValue]) {
            //同步时间
            
        } else if cmdData == Data([PHBLUEDATATYPE.syncData.rawValue]) {
            //同步数据
            let stepData = contentData[0..<1]
            if stepData == Data([DataStep.request.rawValue]) {
                //开始分包发送数据
                startIndex = 1
                endIndex = startIndex + 4 //起始时间 4个字节
                let timeData = contentData[startIndex..<endIndex]
                let time = PHData.dataToInt(timeData)
                print("timeData==\(timeData.hexString()) == \(time)")
                
                startIndex = endIndex
                endIndex = startIndex + 4 //数据包数量 4个字节
                let totalPackageData = contentData[startIndex..<endIndex]
                let total = PHData.dataToInt(totalPackageData)
                print("totalPackageData==\(totalPackageData.hexString()) ==\(total)")
                
                syncDataPackage?(time , total)
                
            } else if stepData == Data([DataStep.package.rawValue]) {
                startIndex = 1
                endIndex = startIndex + 4 //包序号 4个字节
                let indexData = contentData[startIndex..<endIndex]
                let index = PHData.dataToInt(indexData)
                let valueData = contentData[endIndex..<contentData.count]
                
                print("valueData==\(valueData.hexString())")
                
                syncData?(index , value)
                
            } else if stepData == Data([DataStep.clear.rawValue]) {
                let clearStatusData = contentData[1..<2]
                let clearStatus = PHData.dataToInt(clearStatusData)
                if clearStatus == 0x00 {
                    print("开始擦除")
                } else if clearStatus == 0x01 {
                    print("擦除完成")
                    syncClear?(clearStatus)
                }
            }
            
        }
        
    }
    
}
