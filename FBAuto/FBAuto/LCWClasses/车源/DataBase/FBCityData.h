//
//  FBCityData.h
//  FBAuto
//
//  Created by lichaowei on 14-7-9.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FBCityData : NSObject

+ (NSArray *)getAllProvince;
+ (NSArray *)getSubCityWithProvinceId:(int)privinceId;//根据省份获取城市

+ (NSString *)cityNameForId:(int)cityId;//根据id获取城市名
+ (int)cityIdForName:(NSString *)cityName;//根据城市名获取id

@end
