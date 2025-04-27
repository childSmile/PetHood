//
//  ActivityViewModel.swift
//  PetHood
//
//  Created by MacPro on 2024/8/5.
//

import Foundation

class ActivityViewModel {
    
    static let manager = ActivityViewModel()
    
//    func getChannel(username: String?, complete:@escaping((Any)-> Void))
    
    //获取列表信息
    func getHomeDeviceList(_ complete:@escaping((Any)-> Void)) {
        
        NetWork.request(target: .mapDeviceList) { response in
            //处理业务
            guard let data = response?.data as? [String : Any] ,
                  let list =  data["list"] as? [[String : Any]] else {return}
            
            let array = ModelTool.jsonArrayToModel(list, MapDeviceModel.self)
            
            let model : MapDeviceModel = array.first as! MapDeviceModel
            model.gps_latitude = (30.254635000000007)
            model.gps_longitude = NSNumber(value: 120.16404699999998)

            complete(array)
            
        } error: { code in
            
        } failure: { error in
            
        }

    }
    
    
}
