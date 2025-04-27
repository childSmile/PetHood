//
//  APIManager.swift
//  PetHood
//
//  Created by MacPro on 2024/7/25.
//

import UIKit
import Moya

enum APIManager {
    
    case loginByVerifyCode(parameters: [String:Any ])
    case sendVerifyCode(parameters: [String:Any ])
    case userProfile//parameters:[String:Any]
    case updateUserProfile(parameters:[String:Any])
    case bindDevice(parameters:[String:Any])
    case unbindDevice(parameters:[String:Any])
    case bindPet(parameters:[String:Any])
    case mapDeviceList
    case devicePetList(parameters:[String:Any])
    case updatePetInfo(parameters:[String:Any])
}

extension APIManager : TargetType {
    
    var baseURL: URL { return URL(string: "https://api-test.pethood.pet")! }
    
    
    var path: String {
        switch self {
        case .loginByVerifyCode:
            return "/user/auth/loginByVerifyCode"
        case .sendVerifyCode:
            return "/user/auth/sendVerifyCode"
        case .userProfile:
            return "/user/auth/userProfile"
        case .updateUserProfile:
            return "/user/auth/userProfile/update"
        case .bindDevice:
            return "/user/device/bind"
        case .unbindDevice:
            return "/user/device/unbind"
        case .bindPet:
            return "/user/device/pet/bind"
        case .mapDeviceList:
            return "/user/device/pet/list"
        case .devicePetList:
            return "/user/device/pet_info"
        case .updatePetInfo:
            return "/user/device/pet_info/update"
            
        }
        
    }
    
    var method: Moya.Method {
        switch self {
        case .loginByVerifyCode,
                .sendVerifyCode,
                .bindDevice,
                .unbindDevice ,
                .bindPet,
                .updateUserProfile ,
                .updatePetInfo:
            return .post
            
        case .userProfile ,
             .mapDeviceList ,
             .devicePetList :
            return .get
            
        }
    }
    
    var task: Moya.Task {
        switch self {
        case    .loginByVerifyCode(parameters: let parameters),
                .sendVerifyCode(parameters: let parameters) ,
                .updateUserProfile(parameters: let parameters),
                .bindDevice(parameters: let parameters) ,
                .unbindDevice(parameters: let parameters) ,
                .bindPet(parameters: let parameters) ,
                .updatePetInfo(parameters: let parameters),
                .devicePetList(parameters: let parameters):
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            
            
//         case
//                .devicePetList(parameters: let parameters):
//            var queryItems = ["device_id" : "did_2"]
//            // 返回.requestCompositeTask来同时发送body和query
//
//            return .requestCompositeParameters(bodyParameters: [:], bodyEncoding: JSONEncoding.default, urlParameters: queryItems)
//
            
            
        case .mapDeviceList,
                .userProfile:
                
            return .requestPlain
        }
        
    }
    
    var headers: [String : String]? {
        
        var header = ["Content-type": "application/json"]
        //增加请求头数据
        if let token = UserDefaults.standard.value(forKey: "token")  {
            //拼接 Bearer+空格
            header.updateValue("Bearer \(token)", forKey: "Authorization")
        }
        print("header==\(header)")
        return header
    }
    
}
