//
//  ModelTool.swift
//  PetHood
//
//  Created by MacPro on 2024/7/26.
//

import UIKit
import HandyJSON

class ModelTool: NSObject {
    
    /**
     *  Json转对象
     */
    static func jsonToModel(_ jsonStr:String,_ modelType:HandyJSON.Type) ->BaseModel {
        if jsonStr == "" || jsonStr.count == 0 {
            #if DEBUG
                print("jsonoModel:字符串为空")
            #endif
            return BaseModel()
        }
        return modelType.deserialize(from: jsonStr)  as! BaseModel

    }

    /**
     *  Json转数字符串组对象
     */
    static func jsonStringArrayToModel(_ jsonArrayStr:String, _ modelType:HandyJSON.Type) ->[BaseModel] {
        if jsonArrayStr == "" || jsonArrayStr.count == 0 {
            #if DEBUG
                print("jsonToModelArray:字符串为空")
            #endif
            return []
        }
        var modelArray:[BaseModel] = []
        let data = jsonArrayStr.data(using: String.Encoding.utf8)
        let peoplesArray = try! JSONSerialization.jsonObject(with:data!, options: JSONSerialization.ReadingOptions()) as? [AnyObject]
        for people in peoplesArray! {
            modelArray.append(dictionaryToModel(people as! [String : Any], modelType))
        }
        return modelArray

    }
    
    /**
     *  Json转数组对象
     */
    static func jsonArrayToModel(_ jsonArray:[[String : Any]], _ modelType:HandyJSON.Type) ->[BaseModel] {
//        if jsonArrayStr == "" || jsonArrayStr.count == 0 {
//            #if DEBUG
//                print("jsonToModelArray:字符串为空")
//            #endif
//            return []
//        }
        var modelArray:[BaseModel] = []
//        let data = jsonArrayStr.data(using: String.Encoding.utf8)
//        let peoplesArray = try! JSONSerialization.jsonObject(with:data!, options: JSONSerialization.ReadingOptions()) as? [AnyObject]
        for people in jsonArray {
            modelArray.append(dictionaryToModel(people , modelType))
        }
        return modelArray

    }

    /**
     *  字典转对象
     */
    static func dictionaryToModel(_ dictionStr:[String:Any],_ modelType:HandyJSON.Type) -> BaseModel {
        if dictionStr.count == 0 {
            #if DEBUG
                print("dictionaryToModel:字符串为空")
            #endif
            return BaseModel()
        }
        return modelType.deserialize(from: dictionStr) as! BaseModel
    }

    /**
     *  对象转JSON
     */
    static func modelToJson(_ model:BaseModel?) -> String {
        if model == nil {
            #if DEBUG
                print("modelToJson:model为空")
            #endif
             return ""
        }
        return (model?.toJSONString())!
    }

    /**
     *  对象转字典
     */
    static func modelToDictionary(_ model:BaseModel?) -> [String:Any] {
        if model == nil {
            #if DEBUG
                print("modelToJson:model为空")
            #endif
            return [:]
        }
        return (model?.toJSON())!
    }

}
