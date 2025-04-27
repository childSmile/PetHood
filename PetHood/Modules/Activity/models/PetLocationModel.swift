//
//  PetLocationModel.swift
//  PetHood
//
//  Created by MacPro on 2024/7/11.
//

import UIKit

struct PetLocationModel {
    
    var regeocode:AMapReGeocode
    var coor:CLLocationCoordinate2D
    var location:AMapGeoPoint
    var showLocation: String {
        let att = regeocode.addressComponent.province.appending(regeocode.addressComponent.city).appending(regeocode.addressComponent.district).appending(regeocode.addressComponent.township)
        
        return regeocode.addressComponent.building.isEmpty ?  regeocode.formattedAddress.replacingOccurrences(of: att, with: "") : regeocode.addressComponent.building
    }
    var online:Bool  = false
    var mapDeviceModel : MapDeviceModel?
  
    /**
     
     
     ///国家（since 5.7.0）
     @property (nonatomic, copy)   NSString         *country;
     ///国家简码（since 7.4.0）仅海外生效
     @property (nonatomic, copy)   NSString         *countryCode;
     ///省/直辖市
     @property (nonatomic, copy)   NSString         *province;
     ///市
     @property (nonatomic, copy)   NSString         *city;
     ///城市编码
     @property (nonatomic, copy)   NSString         *citycode;
     ///区
     @property (nonatomic, copy)   NSString         *district;
     ///区域编码
     @property (nonatomic, copy)   NSString         *adcode;
     ///乡镇街道
     @property (nonatomic, copy)   NSString         *township;
     ///乡镇街道编码
     @property (nonatomic, copy)   NSString         *towncode;
     ///社区
     @property (nonatomic, copy)   NSString         *neighborhood;
     ///建筑
     @property (nonatomic, copy)   NSString         *building;
     ///门牌信息
     @property (nonatomic, strong) AMapStreetNumber *streetNumber;
     ///商圈列表 AMapBusinessArea 数组
     @property (nonatomic, strong) NSArray<AMapBusinessArea *> *businessAreas;
     */

}
