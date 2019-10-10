//
//  OEAShopCarCommonModel.h
//  IOTOne
//
//  Created by 欧阳昌帅 on 2018/6/26.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OEAAddressModel : NSObject

+ (instancetype)modelWithDic:(NSDictionary *)dic;

@end

@interface OEAAddressProvinceModel : OEAAddressModel

//local(使用本地省市区数据时需要用到的模型)
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSArray *cityList;

//network(通过网络请求获取省市区数据时需要用到的模型)
@property (nonatomic, copy) NSString *provinceCode;
@property (nonatomic, copy) NSString *provinceName;

@end

@interface OEAAddressCityModel : OEAAddressModel

//local(使用本地省市区数据时需要用到的模型)
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSArray *areaList;

//network(通过网络请求获取省市区数据时需要用到的模型)
@property (nonatomic, copy) NSString *provinceCode;
@property (nonatomic, copy) NSString *provinceName;
@property (nonatomic, copy) NSString *cityCode;
@property (nonatomic, copy) NSString *cityName;

@end

@interface OEAAddressAreaModel : OEAAddressModel

//local(使用本地省市区数据时需要用到的模型)
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSString *postCode;

//network(通过网络请求获取省市区数据时需要用到的模型)
@property (nonatomic, copy) NSString *cityCode;
@property (nonatomic, copy) NSString *cityName;
@property (nonatomic, copy) NSString *townCode;
@property (nonatomic, copy) NSString *townName;

@end

