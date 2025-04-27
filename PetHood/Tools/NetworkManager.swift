//
//  NetworkManager.swift
//  PetHood
//
//  Created by MacPro on 2024/7/25.
//

import UIKit
import Moya
import Foundation
import ObjectMapper


struct NetWork {
    public static func request(provider:MoyaProvider<APIManager>? = ApiProvider() ,
                               target:APIManager ,
                               success successCallback: @escaping (ResponseModel?) -> Void,
                               error errorCallback: @escaping (Int) -> Void,
                               failure failureCallback: @escaping (MoyaError) -> Void) {
        
        provider!.request(target) { result in
            switch result {
            case let .success(response):
                do {
                    //filterSuccessfulStatusCodes 200...299
                    //filterSuccessfulStatusAndRedirectCodes() 200...399
                    let json = try response.filterSuccessfulStatusCodes().mapJSON()
                    let model = Mapper<ResponseModel>().map(JSONObject: json)
                    
                    print("\(target.path)==success:\(json)")
                    
                    guard let code = model?.code,
                          let error = model?.error else {return}
                    
                    if(code != 200) {
                        print("error==\(error)")
                        return
                    }
                    successCallback(model)
                    
                } catch let error {
                    
                    if response.statusCode == 401 {
                        keyWindow()?.makeToast("token失效", duration: 2, position: .center)
                        return
                    }
                    print("\(target.path)==error:\(error)")
                    errorCallback((error as! MoyaError).response!.statusCode)
                }
            case let .failure(error):
                print("\(target.path)==moyaError:\(error.errorUserInfo)")
                failureCallback(error)
            }
        }
        
    }
    
    
    public static func ApiProvider(timeInterval:TimeInterval = 15) -> MoyaProvider<APIManager> {
        return MoyaProvider<APIManager> (
            requestClosure: { (endPoint, closure) in
                do {
                    var urlRequest = try endPoint.urlRequest()
                    //设置超时时间
                    urlRequest.timeoutInterval = timeInterval;
                    
                    closure(.success(urlRequest))
                } catch MoyaError.requestMapping(let url) {
                    closure(.failure(MoyaError.requestMapping(url)))
                } catch MoyaError.parameterEncoding(let error) {
                    closure(.failure(MoyaError.parameterEncoding(error)))
                } catch {
                    closure(.failure(MoyaError.underlying(error, nil)))
                }
            }
            
        )
    }
}



class ResponseModel : Mappable {
    func mapping(map: ObjectMapper.Map) {
        code <- map["code"]
        data <- map["data"]
        error <- map["error"]
        status <- map["status"]
    }
    
    var code:Int?
    var data:Any?
    var error:String?
    var status:String?
    
    required init?(map:Map) {
        
    }
    
   
}


