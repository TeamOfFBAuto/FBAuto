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

#pragma - mark insert

//品牌
+ (void)insertCarBrandId:(NSString *)brandId brandName:(NSString *)name firstLetter:(NSString *)firstLetter;
//车型
+ (void)insertCarTypeId:(NSString *)typeId parentId:(NSString *)parentId typeName:(NSString *)name firstLetter:(NSString *)firstLetter;
//车款
+ (void)insertCarStyleId:(NSString *)StyleId parentId:(NSString *)parentId StyleName:(NSString *)name;

#pragma - mark querty

+ (NSArray *)queryAllCarBrand;
+ (NSArray *)queryCarTypeWithParentId:(NSString *)parendId;
+ (NSArray *)queryCarStyleWithParentId:(NSString *)parendId;

@end
