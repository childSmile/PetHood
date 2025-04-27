//
//  BluetoothManager.swift
//  PetHood
//
//  Created by MacPro on 2024/7/25.
//

import Foundation
import CoreBluetooth



class BluetoothManager : NSObject {
    
    var centerDelegate : (any CBCentralManagerDelegate)? {
        set {
            centeralManager.delegate = newValue
        } get {
            return centeralManager.delegate
        }
    }
    var peripheralDelegate : (any CBPeripheralDelegate)?
    
    static let shared = BluetoothManager()
    fileprivate var centeralManager:CBCentralManager!
    fileprivate var peri : CBPeripheral?
    fileprivate var write : CBCharacteristic?
    
    private override init() {
        super.init()
        //init bluetooth
        
        //CBCentralManagerOptionShowPowerAlertKey : 蓝牙权限变更，会有弹窗提示用户 默认是 true
        //CBCentralManagerOptionRestoreIdentifierKey : 用来恢复(restore)蓝牙中心管理器(CBCentralManager)状态的键。这个键对应的值是一个字符串，用来标识应用程序的恢复ID
        centeralManager = CBCentralManager(delegate: nil, queue: nil , options: nil)
    }
    
    
    
    func startScan() {
        
        let services = [CBUUID(string: "1800")]
//        let id = "E872AB68-CEB4-0AF4-0F4B-3FE82797E233"
//        
//        if let uuid  = UUID(uuidString: id) {
//            var array = centeralManager.retrievePeripherals(withIdentifiers: [uuid])
//            print("array ==\(array)")
//        }

        if centeralManager.isScanning {
            centeralManager.stopScan()
        }
        centeralManager.scanForPeripherals(withServices: [], options: [CBCentralManagerScanOptionAllowDuplicatesKey : false])
    }
    
    func stopScan() {
        centeralManager.stopScan()
    }
    

    
    func connectPeriphral(_ periphral:CBPeripheral) {
        stopScan()
        peri = periphral
        centeralManager.connect(periphral)
    }
}

/*
extension BluetoothManager : CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("centralManagerDidUpdateState==\(central.state)")
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
//        guard let localName = peripheral.name else{
//            return
//        }
//        peripheralDic.updateValue(peripheral, forKey: localName)
//        
//        
//        if (localName == connectName) {
//            stopScan()
//            connectPeri(name: localName)
//        }
//        let distance = BluetoothTool.calculateDistance(RSSI.intValue)
        print("discover===\(peripheral),RSSI==\(RSSI)))") //kCBAdvDataLocalName
    }
    
    
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("连接成功")
        
        peri = peripheral
        
        peripheral.delegate = self
        
        peripheral.discoverServices(nil)
    }
     
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: (any Error)?) {
        print("断开连接 === \(peripheral) , error==\(String(describing: error?.localizedDescription))")
    }
    
    
}


extension BluetoothManager : CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: (any Error)?) {
        print("didDiscoverServices==")
        
        guard let services = peripheral.services else {return}
        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: (any Error)?) {
        print("didDiscoverCharacteristicsFor==")
        
        guard let chs = service.characteristics else {return}
        for ch in chs {
            if ch.properties == .read {
                peripheral.readValue(for: ch)
            } else if ch.uuid.uuidString.uppercased() == kOTACharacteristics {
                write = ch
            }
        }
        
    }
    
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: (any Error)?) {
        print("接收到蓝牙数据===\(characteristic)")
        let value = characteristic.value
        
             //data - int
//        let uint16: UInt16 = data.withUnsafeBytes { $0.load(as: UInt16.self)
    }
}

*/

extension BluetoothManager {
    func sendData(_ data:Data , _ writeCh:CBCharacteristic? , _ device:CBPeripheral?) {
        guard let write = writeCh ,
        let periphral = device else {return}
        print("sendStartData==\(data.hexString())")
        periphral.writeValue(data, for: write, type: .withoutResponse)
        
        
//        peripheral.writeValue(data, for: write, type: .withoutResponse)
        
    }
}
