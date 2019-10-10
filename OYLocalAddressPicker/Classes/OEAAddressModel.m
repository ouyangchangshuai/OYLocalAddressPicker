//
//  OEAAddressModel.m
//  Touch-practice
//
//  Created by 欧阳昌帅 on 2018/8/17.
//  Copyright © 2018年 0easy. All rights reserved.
//

#import "OEAAddressModel.h"
#import <objc/runtime.h>

@implementation OEAAddressModel

//本质:创建谁的对象
+ (instancetype)modelWithDic:(NSDictionary *)dic{
    
    id objc = [[self alloc] init];
    
    //Ivar:成员变量  以下划线开头
    //property:属性
    
    //runtime : 根据模型属性,去字典中取出对应的value给模型属性赋值
    //1.获取模型中所有成员变量 key
    // 获取哪个类的成员变量
    //count : 成员变量个数
    
    unsigned int count;;
    //获取成员变量数组
    Ivar *ivarList = class_copyIvarList(self, &count);
    
    //遍历所有成员变量名字
    for (int i = 0; i < count; i++) {
        //获取成员变量
        Ivar ivar = ivarList[i];
        //获取成员变量名字
        NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(ivar)];
        NSString *ivarType = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
        //            @\"user\" -> user
        
        ivarType = [ivarType stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        ivarType = [ivarType stringByReplacingOccurrencesOfString:@"@" withString:@""];
        
        //获取key
        NSString *key = [ivarName substringFromIndex:1];
        
        //去字典中查找对应的value
        id value = dic[key];
        //二级转换 : 判断下value 是否是字典,如果是,字典转换成对应的模型,并且是自定义对象才转换
        if ([value isKindOfClass:[NSDictionary class]] && ![ivarType hasPrefix:@"NS"]) {
            
            //获取类
            Class modelClass = NSClassFromString(ivarType);
            value = [modelClass modelWithDic:value];
            
        }
        
//        if ([key isEqualToString:@"propertyList"]) {
//
//            NSMutableArray *tempArr = [NSMutableArray array];
//
//            for (int i = 0; i < [value count]; i++) {
//
//                [tempArr addObject:[OEAShopCarSkuModel modelWithDic:value[i]]];
//
//            }
//
//            value = [tempArr mutableCopy];
//            
//        }
        
        if ([key isEqualToString:@"cityList"]) {
            
            NSMutableArray *tempArr = [NSMutableArray array];
            
            for (int i = 0; i < [value count]; i++) {
                
                [tempArr addObject:[OEAAddressCityModel modelWithDic:value[i]]];
                
            }
            
            value = [tempArr mutableCopy];
            
        }
        
        if ([key isEqualToString:@"areaList"]) {
            
            NSMutableArray *tempArr = [NSMutableArray array];
            
            for (int i = 0; i < [value count]; i++) {
                
                [tempArr addObject:[OEAAddressAreaModel modelWithDic:value[i]]];
                
            }
            
            value = [tempArr mutableCopy];
            
        }
        
        //给模型中属性赋值
        if (value) {
            [objc setValue:value forKey:key];
            
        }
        
    }
    
    //2.根据属性名去字典中查找value
    //3.给模型中属性赋值 KVC
    return objc;
    
}

#pragma mark -------------------- NScoding --------------
/**
 *  @brief  将类中的各个属性进行编码， 在编码这个类的对象时自动调用
 *
 *  @param   encoder   编码器对象
 */
- (void)encodeWithCoder:(NSCoder *)aCoder{
    unsigned int count;
    objc_property_t * properties = class_copyPropertyList([self class], &count);
    for (int i = 0; i<count; i++) {
        const char * propertyCString = property_getName(properties[i]);
        NSString *propertyNString = [NSString stringWithCString:propertyCString encoding:NSUTF8StringEncoding];
        id value = [self valueForKey:propertyNString];
        [aCoder encodeObject:value forKey:propertyNString];
    }
    free(properties);
}

/**
 *  @brief  将类中的各个属性进行解码， 解码后返回一个类的实例， 在解码类对象时自动调用
 *
 *  @param   decoder   解码器对象
 *
 *  @return  返回通过解码得到的Message对象
 */
- (id)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super init]) {
        unsigned int count;
        objc_property_t * properties = class_copyPropertyList([self class], &count);
        for (int i = 0; i<count; i++) {
            const char * propertyCString = property_getName(properties[i]);
            NSString *propertyNString = [NSString stringWithCString:propertyCString encoding:NSUTF8StringEncoding];
            id value = [aDecoder decodeObjectForKey:propertyNString];
            [self setValue:value forKey:propertyNString];
        }
        free(properties);
    }
    return self;
}

#pragma mark--------------------NScopying--------------
/**
 *  @brief  实现NSObject的copyWithZone:方法，使Message对象能够使用copy方法
 *
 *  @param   zone   对象域
 *
 *  @return  返回通过copy解码后得到的Message对象
 */
- (id)copyWithZone:(NSZone *)zone{
    
    OEAAddressModel *model = [[[self class] allocWithZone:zone] init];
    
    unsigned int count;
    objc_property_t * properties = class_copyPropertyList([self class], &count);
    for (int i = 0; i<count; i++) {
        const char * propertyCString = property_getName(properties[i]);
        NSString *propertyNString = [NSString stringWithCString:propertyCString encoding:NSUTF8StringEncoding];
        id value = [self valueForKey:propertyNString];
        [model setValue:value forKey:propertyNString];
    }
    free(properties);
    return model;
    
}

@end

#pragma mark 省
@implementation OEAAddressProvinceModel

@end

#pragma mark 市
@implementation OEAAddressCityModel

@end

#pragma mark 区
@implementation OEAAddressAreaModel

@end

