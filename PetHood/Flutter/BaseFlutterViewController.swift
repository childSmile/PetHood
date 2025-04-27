//
//  BaseFlutterViewController.swift
//  PetHood
//
//  Created by MacPro on 2024/7/29.
//

/*
import UIKit
import Flutter
import FlutterPluginRegistrant


class BaseFlutterViewController: FlutterViewController {
    
    private var flutterMDic : [String : FlutterMethodChannel] = [:]
    
    class func flutterPageWithName(_ name:String) {
        let appdeleaget = UIApplication.shared.delegate as! AppDelegate
        let flutterEngineGroup = appdeleaget.flutterEngineGroup
        guard let engine = flutterEngineGroup?.makeEngine(withEntrypoint: name, libraryURI: nil) else { return  }
        GeneratedPluginRegistrant.register(with: engine)
        
        let vc = BaseFlutterViewController()
        if(name == "page_one") {
            vc.addActionName("page_one_channal")
        }

        
    }
    
    func addActionName(_ name:String) {
       
        
    }
    
    func flutterMethoChannelWithName(_ name:String) -> FlutterMethodChannel {
        if flutterMDic.keys.contains(name) {
            return flutterMDic[name]!
        }
        
        let channel = flutterMethoChannelWithName(name)
        flutterMDic.updateValue(channel, forKey: name)
        return channel
        
    }

}
*/
