//
//  OEAAddressPickerView.m
//  IOTOne
//
//  Created by 欧阳昌帅 on 2018/7/5.
//  Copyright © 2018年 Facebook. All rights reserved.
//

#import "OEAAddressPickerView.h"
#import "OEAAddressModel.h"
#import "Masonry.h"

@interface OEAAddressPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *completeBtn;
@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) NSMutableArray *provinceArray;
@property (nonatomic,assign) NSInteger selectRowWithProvince; //选中的省份对应的下标
@property (nonatomic,assign) NSInteger selectRowWithCity; //选中的市级对应的下标
@property (nonatomic,assign) NSInteger selectRowWithArea; //选中的县级对应的下标

@end

@implementation OEAAddressPickerView

#pragma mark 初始化
- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        _provinceArray = [self prepareData];
        
        self.selectRowWithProvince = 0;
        self.selectRowWithCity = 0;
        self.selectRowWithArea = 0;
        
        _maskView = [[UIView alloc] init];
        _maskView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
        [self addSubview:_maskView];
        
        _headerView = [[UIView alloc] init];
        _headerView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_headerView];
        
        _cancelBtn = [[UIButton alloc] init];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_cancelBtn setTitleColor:[UIColor colorWithRed:169/255.0 green:160/255.0 blue:160/255.0 alpha:1] forState:UIControlStateNormal];
        _cancelBtn.tag = 0;
        [_cancelBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_headerView addSubview:_cancelBtn];
        
        _completeBtn = [[UIButton alloc] init];
        [_completeBtn setTitle:@"完成" forState:UIControlStateNormal];
        _completeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_completeBtn setTitleColor:[UIColor colorWithRed:48/255.0 green:112/255.0 blue:191/255.0 alpha:1] forState:UIControlStateNormal];
        _completeBtn.tag = 1;
        [_completeBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_headerView addSubview:_completeBtn];
        
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.layer.borderColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0].CGColor;
        _pickerView.layer.borderWidth = 0.5;
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        [_pickerView selectRow:0 inComponent:0 animated:YES];
        [self addSubview:_pickerView];
        
        [_maskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self);
            make.left.equalTo(self);
            make.right.equalTo(self);
//            make.top.equalTo(self).offset(KIsiPhoneX ? 88 : 64);
            make.top.equalTo(self).offset(64);
        }];
        
        [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_pickerView.mas_top);
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.height.equalTo(@40);
        }];
        
        [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_headerView).offset(15);
            make.centerY.equalTo(_headerView);
        }];
        
        [_completeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_headerView).offset(-15);
            make.centerY.equalTo(_headerView);
        }];
        
        [_pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.bottom.equalTo(self);
        }];
        
    }
    return self;
    
}

//- (void)loading{
//
//  dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//  dispatch_async(globalQueue, ^{
//    [self prepareData];
//    dispatch_queue_t mainQueue = dispatch_get_main_queue();
//    dispatch_async(mainQueue, ^{
//      [self uiConfig];
//    });
//
//  });
//
//}

#pragma mark 点击取消或完成按钮
- (void)btnClick:(UIButton *)btn{
    
    if (btn.tag == 0){//取消
        
        
    }else{//完成
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(addressPickerViewCompleteBtnClick:provinceCode:cityName:cityCode:areaName:areaCode:)]) {
            
            NSString *pName = @"000000";
            NSString *cName = @"000000";
            NSString *aName = @"000000";
            NSString *pCode = @"000000";
            NSString *cCode = @"000000";
            NSString *aCode = @"000000";
            
            OEAAddressProvinceModel *provinceModel = _provinceArray[self.selectRowWithProvince];
            pName = provinceModel.name;
            pCode = provinceModel.code;
            if (provinceModel.cityList.count > self.selectRowWithCity) {
                OEAAddressCityModel *cityModel = provinceModel.cityList[self.selectRowWithCity];
                cName = cityModel.name;
                cCode = cityModel.code;
                if (cityModel.areaList.count > self.selectRowWithArea) {
                    OEAAddressAreaModel *areaModel = cityModel.areaList[self.selectRowWithArea];
                    aName = areaModel.name;
                    aCode = areaModel.code;
                }
            }
            
            [self.delegate addressPickerViewCompleteBtnClick:pName provinceCode:pCode cityName:cName cityCode:cCode areaName:aName areaCode:aCode];
        }
        
    }
    
    [self removeFromSuperview];
    
}

#pragma mark UIPickerViewDataSource
//返回选择器有几列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}
//返回每组有几行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    NSInteger integer = 0;
    if (component == 0) {
        integer = self.provinceArray.count;
    }else if (component == 1){
        OEAAddressProvinceModel *model = self.provinceArray[self.selectRowWithProvince];
        integer = model.cityList.count;
    }else if (component == 2){
        OEAAddressProvinceModel *model = self.provinceArray[self.selectRowWithProvince];
        OEAAddressCityModel *cityModel = model.cityList[self.selectRowWithCity];
        integer = cityModel.areaList.count;
    }
    return integer;
    
}
//返回第component列第row行的内容(标题)
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    switch (component) {
        case 0:{
            OEAAddressProvinceModel *model = self.provinceArray[row];
            return model.name;
        }
            break;
        case 1:{
            OEAAddressProvinceModel *model = self.provinceArray[self.selectRowWithProvince];
            
            if (model.cityList.count > row) {
                OEAAddressCityModel *cityModel = model.cityList[row];
                return cityModel.name;
            }
            
        }
            break;
        case 2:{
            OEAAddressProvinceModel *model = self.provinceArray[self.selectRowWithProvince];
            //      OEAAddressCityModel *cityModel = model.cityList[self.selectRowWithCity];
            //      OEAAddressAreaModel *areaModel = cityModel.areaList[row];
            //      return areaModel.name;
            
            if (model.cityList.count > self.selectRowWithCity) {
                OEAAddressCityModel *cityModel = model.cityList[self.selectRowWithCity];
                if (cityModel.areaList.count > row) {
                    OEAAddressAreaModel *areaModel = cityModel.areaList[row];
                    return areaModel.name;
                }
                
            }
            
        }
            break;
    }
    return nil;
}

//设置row字体，颜色
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel *pickerLabel = (UILabel *)view;
    if (!pickerLabel) {
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        pickerLabel.backgroundColor = [UIColor clearColor];
        pickerLabel.font = [UIFont systemFontOfSize:16.0];
    }
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
    
}

#pragma mark UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (component == 0) {
        self.selectRowWithProvince = row;
        self.selectRowWithCity = 0;
        self.selectRowWithArea = 0;
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];
    }else if (component == 1){
        self.selectRowWithCity = row;
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];
    }else{
        self.selectRowWithArea = row;
    }
    
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    
    return 44;
    
}

#pragma mark 读取json数据
- (NSMutableArray *)prepareData{
    
    NSMutableArray *provinceArray = [NSMutableArray array];
    NSArray *dataArray = [NSArray array];
    
//    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"address" ofType:@"json"];
    
    // 注意文件名称的格式，图片必须写上@2x或者@3x的后缀
    NSString *fileName = @"address.json";
    // 获取当前的bundle,self只是在当前pod库中的一个类，也可以随意写一个其他的类
    NSBundle *currentBundle = [NSBundle bundleForClass:[self class]];
    // 获取当前bundle的名称
    NSString *currentBundleName = currentBundle.infoDictionary[@"CFBundleName"];
    // 获取文件的路径
    NSString *plistPath = [currentBundle pathForResource:fileName ofType:nil inDirectory:[NSString stringWithFormat:@"%@.bundle",currentBundleName]];
    
    NSData *data = [[NSData alloc] initWithContentsOfFile:plistPath];
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    if (jsonObject != nil && error == nil){
        dataArray = [jsonObject copy];
    }else{
        return nil;
    }
    
    for (int i = 0; i < dataArray.count; i++) {
        NSDictionary *dict = (NSDictionary *)dataArray[i];
        OEAAddressProvinceModel *model = [OEAAddressProvinceModel modelWithDic:dict];
        [provinceArray addObject:model];
    }
    
    return provinceArray;
    
}

@end
