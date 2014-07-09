//
//  FBCityData.m
//  FBAuto
//
//  Created by lichaowei on 14-7-9.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "FBCityData.h"
#import "DataBase.h"
#import "FBCity.h"

@implementation FBCityData

+ (NSArray *)getSubCityWithProvinceId:(int)privinceId
{
    //打开数据库
    sqlite3 *db = [DataBase openDB];
    //创建操作指针
    sqlite3_stmt *stmt = nil;
    //执行SQL语句
    int result = sqlite3_prepare_v2(db, "select * from area where provinceId = ? and isProvince = 0", -1, &stmt, nil);
    NSLog(@"All subcities result = %d",result);
    NSMutableArray *subCityArray = [NSMutableArray arrayWithCapacity:1];
    if (result == SQLITE_OK) {
        
        sqlite3_bind_int(stmt, 1, privinceId);
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            const unsigned char *cityName = sqlite3_column_text(stmt, 0);
            int cityId = sqlite3_column_int(stmt, 1);
            int provinceId = sqlite3_column_int(stmt, 3);
            
            FBCity *province = [[FBCity alloc]initSubcityWithName:[NSString stringWithUTF8String:(const char *)cityName] cityId:cityId provinceId:provinceId];
            [subCityArray addObject:province];
        }
    }
    sqlite3_finalize(stmt);
    return subCityArray;
    
}


+ (NSArray *)getAllProvince
{
    //打开数据库
    sqlite3 *db = [DataBase openDB];
    //创建操作指针
    sqlite3_stmt *stmt = nil;
    //执行SQL语句
    int result = sqlite3_prepare_v2(db, "select * from area where isProvince = 1", -1, &stmt, nil);
    NSLog(@"All subcities result = %d",result);
    NSMutableArray *subCityArray = [NSMutableArray arrayWithCapacity:1];
    if (result == SQLITE_OK) {
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            const unsigned char *cityName = sqlite3_column_text(stmt, 0);
            int cityId = sqlite3_column_int(stmt, 1);
//            int provinceId = sqlite3_column_int(stmt, 3);
            
            FBCity *province = [[FBCity alloc]initProvinceWithName:[NSString stringWithUTF8String:(const char *)cityName] provinceId:cityId];
            [subCityArray addObject:province];
        }
    }
    sqlite3_finalize(stmt);
    return subCityArray;
    
}

@end
