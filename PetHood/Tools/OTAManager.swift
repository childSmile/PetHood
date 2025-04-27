//
//  OTAManager.swift
//  PetHood
//
//  Created by MacPro on 2024/9/6.
//

import UIKit



class OTAManager: NSObject {
    
    static let shared = OTAManager()
    
    var progressBlock : ((Double)->Void)?
    
    fileprivate var filePath : String?
    fileprivate var otaData : Data?
    fileprivate var packageSize = 20
    fileprivate var packageDataSize = 16
    fileprivate var isCancel  = false
    
    private override init() {
        
        if let path = Bundle.main.path(forResource: "MRK-S10_2.0.4", ofType: "bin") {
            do {
                otaData  = try Data(contentsOf: URL(fileURLWithPath: path) , options: .mappedIfSafe)
                
            } catch {
                print("error loading file\(error)")
            }
        }
         
        
    }
    
    /**
      1. start  0x01ff
      2. 循环数据包
      3. end 0x02ff
     
     */
    
    func cancelOTA() {
        isCancel = true
    }
    
    
    func startOTA(_ localName:String) {
        
        guard let fileData = otaData ,
        let model = BlueOperationManager.shared.peripheralDic[localName] ,
        let write = model.writeCharacteristics  else {return}
        
        //start
        let start = Data([0x01 , 0xff])
//        BluetoothManager.shared.sendData(start)
        BluetoothManager.shared.sendData(start, write, model.peripheral)
        
        //data
        let count = Int(ceil(Double(fileData.count) / 16))
        let bytes = [UInt8](fileData)
        
        
        var values : [UInt8] = []
        for i in 0..<count {
            
            if isCancel {
                return
            }
            
            values.removeAll()
            values.append(contentsOf: PHData.numberTobytes(i , length: 2))
            
            if i == count - 1 {
                let size = fileData.count - i * packageDataSize
                values.append(contentsOf: bytes[i * packageDataSize..<fileData.count])
                //补齐数据
                
                for _ in 0..<(packageDataSize - size) {
                    values.append(0x00)
                }
                
            } else {
                values.append(contentsOf: bytes[i * packageDataSize..<packageDataSize * (i + 1)])
            }
            let crc = crc16(arr: values)
            values.append(contentsOf: PHData.numberTobytes(Int(crc) , length: 2))
            
//            BluetoothManager.shared.sendData(Data(values))
            BluetoothManager.shared.sendData(Data(values), write, model.peripheral)
            
            Thread.sleep(forTimeInterval: 0.01)
            
            if let block = progressBlock {
                block(Double(i) / Double(count))
            }
            
            print("index==\(i)")
        }
        
        //end
        let maxIndex = count - 1
        values.removeAll()
        values.append(contentsOf: [0x02 , 0xff])
        
        values.append(contentsOf: PHData.numberTobytes(maxIndex , length: 2))
        
        let xor = PHData.numberTobytes(Int(PHData.xorCalc(PHData.numberTobytes(maxIndex, length: 2))))
        values.append(contentsOf: xor)
       
//        BluetoothManager.shared.sendData(Data(values))
        BluetoothManager.shared.sendData(Data(values), write, model.peripheral)
        
        
        if let block = progressBlock {
            block(1.0)
        }
        
    }
    
    func crc16(arr:[UInt8]) -> Int{
        var CRC:Int = 0x0000ffff
        let POLYNOMIAL:Int = 0x0000a001
        let length = arr.count
        for i in 0..<length{
            CRC ^= (Int(arr[i] & 0x000000ff))
            for _ in 0..<8{
                if((CRC & 0x00000001) != 0 ){
                    CRC >>= 1
                    CRC ^= POLYNOMIAL
                }else{
                    CRC >>= 1
                }
            }
        }
        return CRC
    }
    
  
    
   
}
