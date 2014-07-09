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

@end
