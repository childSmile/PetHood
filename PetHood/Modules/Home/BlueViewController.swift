//
//  BlueViewController.swift
//  PetHood
//
//  Created by MacPro on 2024/9/9.
//

import UIKit

class BlueViewController: ZBaseViewController {

    let operation = BlueOperationManager.shared
    var localName = ""
    var totalPackage = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       let _ =  BluetoothManager.shared
       let _ = OTAManager.shared
        
        
        setupUI()

        syncDeviceData()
        
        startSyncData()
        
    }
    
    func setupUI() {
        
        let titles = ["搜索" , "连接" , "ota" , "停止搜索" , "测试数据解析"]
        
        let sc = UIScrollView(frame: view.bounds)
        sc.add2(view).lyt { make in
            make.top.equalTo(DHPXSW(s: 100))
            make.left.right.bottom.equalTo(0)
        }
        
        for (i,v) in titles.enumerated() {
            let btn = UIButton(type: .custom)
                .title("\(v)", for: .normal)
                .titleColor(UIColor(rgb: 0x000000), for: .normal)
                .bgColor(UIColor(rgb: 0xffffff))
                .titleFont(UIFont.systemFont(ofSize: 14, weight: .light))
            
            btn.add2(sc).lyt { make in
                make.top.equalTo(DHPXSW(s:(CGFloat(i) * 60)))
                make.left.equalTo(DHPXSW(s: 20))
//                make.right.equalTo(DHPXSW(s: -20))
                make.width.equalTo(DHPXSW(s: 200))
                make.height.equalTo(48)
            }
            btn.tag = i
            btn.addTarget(self, action: #selector(btnAction(_:)), for: .touchUpInside)
            
        }
    }
    
    @objc func btnAction(_ sender : UIButton) {
        print("click ==\(sender.titleLabel?.text ?? "nil")")
        if sender.tag == 0 {
//            BluetoothManager.shared.startScan()
            operation.startScan()
        } else if sender.tag == 1 {
//            BluetoothManager.shared.connectPeri(name: "MRK-S16-81DC")
            operation.connectDevice(name: "MRK-S16-81DC")
        } else if sender.tag == 2 {
            
            DispatchQueue.global(qos: .userInitiated).async {
                // 在这里执行异步操作
                OTAManager.shared.progressBlock = {  progress in
                    
                    if progress >= 1.0 {
                        
                        // 如果需要在主线程更新UI等操作，可以使用以下代码
                        DispatchQueue.main.async {
                            // 在这里执行主线程需要的操作
                            print("已经完成，回到主线程==\(progress)")
                        }
                    }
                }
                
                
                OTAManager.shared.startOTA("MRK-S16-81DC")
            }
        } else if sender.tag == 3 {
            BluetoothManager.shared.stopScan()
        } else if sender.tag == 4 {
            testData()
        }
        
    }
   
    func testData() {
        
//        let bytes : [UInt8] = [0x01 , 0x02 , 0x03 , 0x04]
//        let data = Data(bytes)
//        let sub1 = data.subdata(in: 1..<2)
//        let sub2 = data[2..<4]
//
//        let length: UInt16 = sub2.withUnsafeBytes { $0.load(as: UInt16.self)}
//
//        let crc = PHData.xorDataCalc(data)
//        let crc2 = PHData.xorCalc(bytes)
        
        let data3 = Data([
            0xAA ,
            0x10 ,
            0x09 , 0x00 ,
            0x00 , 0x73 , 0xBF , 0xd9 , 0x66 , 0x39 , 0x30 , 0x00 , 0x00 ,
            0xc9 ,
            0x55])
        
        let crc = PHData.xorCalc([0xAA ,
                                  0x10 ,
                                  0x06 , 0x00 ,
                                  0x01 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00])
        let data2 = Data([
            0xAA ,
            0x10 ,
            0x06 , 0x00 ,
            0x01 , 0x00 , 0x00 , 0x00 , 0x00 , 0x00 ,
            crc ,
            0x55])
        
        let data1 = Data([
            0xAA ,
            0x10 ,
            0x02 , 0x00 ,
            0x02 , 0x01 ,
            0xBB ,
            0x55])
        
        
        let shared = BlueOperationManager.shared
        shared.dealData(data1, nil, nil)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        BluetoothManager.shared.stopScan()
        OTAManager.shared.cancelOTA()
    }

}

// MARK: 同步数据
extension BlueViewController {
    
    func syncDeviceData() {
        operation.syncPower = { power in
            print("电量==\(power)")
        }
        
        operation.syncDeviceInfo = { ch , value in
            print("deviceInfo: ch=\(ch) , value=\(value)")
        }
    }
    
    func startSyncData() {
        
        addSyncDataNotification {
            print("提示同步完成")
        }
        syncDataRequest()
    }
    
    func addSyncDataNotification(_ success:(() ->Void)?) {
        
        operation.syncDataPackage = { [weak self] time , total  in
            print("sync ： 时间 === \(time) ,total==\(total)")
            self?.totalPackage = total
            self?.syncData(0)
        }
            
        operation.syncData = { [weak self] index , data in
            print("sync : index=== \(index) , data ==\(data)")
            self?.syncData(index+1)
        }
        
        operation.syncClear = { status in
            print("sync : clear ==\(status)")
            success?()
            
        }
    }
    func syncDataRequest() {
        
        let data = PHData.syncDataRequest()
        operation.sendData(localName , data)
        
    }
    
    func syncData(_ index:Int) {
        
        if index > totalPackage {
            //同步完成 开始擦除
            let data = PHData.syncDataClear()
            operation.sendData(localName , data)
            return
        }
        
        let data = PHData.syncDataPackage(index)
        operation.sendData(localName , data)
        
    }
    
}
