//
//  MapDeviceModel.swift
//  PetHood
//
//  Created by MacPro on 2024/8/5.
//

import UIKit


class MapDeviceModel : BaseModel {
    var device_id:String?            //设备id
    var name:String?                 //设备名称
    var device_type:String?          //设备类型
    var manufacturer:String?         //制造商
    var device_model:String?         //设备型号
    var serial_number:String?        //设备序列号
    var firmware_version:String?     //固件版本号
    var track_mode:String?           //遛宠模式（walking） 寻宠模式（searching） 托运模式（transport）
    var humidity:String?             //环境湿度
    var temperature:String?          //环境温度
    var is_light_on:NSNumber?        //灯光状态（0: 关闭, 1: 开启）
    var is_speaker_on:NSNumber?      //扬声器状态（0: 关闭, 1: 开启）
    var battery_percentage:String?   //电量百分比
    var is_online:NSNumber?          //在线状态（0: 离线, 1: 在线）
    var signal_strength:String?      //信号强度
    var activated_at:String?         //激活时间（毫秒级时间戳
    
    var pet_id:String?               //宠物id
    var pet_name:String?             //宠物名
    var avatar_url:String?           //宠物头像图片地址
    var gps_latitude:NSNumber?       //纬度
    var gps_longitude:NSNumber?      //经度
    
}
