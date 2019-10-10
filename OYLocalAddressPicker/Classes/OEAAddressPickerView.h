//
//  OEAAddressPickerView.h
//  IOTOne
//
//  Created by 欧阳昌帅 on 2018/7/5.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OEAAddressPickerViewDelegate <NSObject>

- (void)addressPickerViewCompleteBtnClick:(NSString *)provinceName provinceCode:(NSString *)provinceCode cityName:(NSString *)cityName cityCode:(NSString *)cityCode areaName:(NSString *)areaName areaCode:(NSString *)areaCode;

@end

@interface OEAAddressPickerView : UIView

@property (nonatomic,weak) id<OEAAddressPickerViewDelegate> delegate;

@end

