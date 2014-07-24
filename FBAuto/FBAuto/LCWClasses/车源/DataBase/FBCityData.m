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

#import "CarClass.h"

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
            FBCity *province = [[FBCity alloc]initProvinceWithName:[NSString stringWithUTF8String:(const char *)cityName] provinceId:cityId];
            [subCityArray addObject:province];
        }
    }
    sqlite3_finalize(stmt);
    return subCityArray;
    
}

+ (NSString *)cityNameForId:(int)cityId
{
    //打开数据库
    sqlite3 *db = [DataBase openDB];
    //创建操作指针
    sqlite3_stmt *stmt = nil;
    //执行SQL语句
    int result = sqlite3_prepare_v2(db, "select * from area where id = ?", -1, &stmt, nil);
    
    NSLog(@"All subcities result = %d %d",result,cityId);

    if (result == SQLITE_OK) {
        
        sqlite3_bind_int(stmt, 1, cityId);
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            
            
            const unsigned char *cityName = sqlite3_column_text(stmt, 0);
            
            return [NSString stringWithUTF8String:(const char *)cityName];
        }
    }
    sqlite3_finalize(stmt);
    return @"未知地区";
}

+ (int)cityIdForName:(NSString *)cityName//根据城市名获取id
{
    //打开数据库
    sqlite3 *db = [DataBase openDB];
    //创建操作指针
    sqlite3_stmt *stmt = nil;
    //执行SQL语句
    int result = sqlite3_prepare_v2(db, "select * from area where name = ?", -1, &stmt, nil);
    
    NSLog(@"All subcities result = %d %@",result,cityName);
    
    if (result == SQLITE_OK) {
        
        sqlite3_bind_text(stmt, 1, [cityName UTF8String], -1, nil);
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            
            
            int cityId = sqlite3_column_int(stmt, 1);
            
            return cityId;
        }
    }
    sqlite3_finalize(stmt);
    return 0;
}


#pragma - mark 车型数据保存

//品牌
+ (void)insertCarBrandId:(NSString *)brandId brandName:(NSString *)name firstLetter:(NSString *)firstLetter
{
    sqlite3 *db = [DataBase openDB];
    sqlite3_stmt *stmt = nil;
    
    int result = sqlite3_prepare(db, "insert into carBrand(id,name,firstLetter) values(?,?,?)", -1, &stmt, nil);//?相当于%@格式
    
    sqlite3_bind_text(stmt, 1, [brandId UTF8String], -1, NULL);
    sqlite3_bind_text(stmt, 2, [name UTF8String], -1, NULL);
    sqlite3_bind_text(stmt, 3, [firstLetter UTF8String], -1, NULL);
    
    result = sqlite3_step(stmt);
    
    NSLog(@"save brand %@ brandResult:%d",name,result);
    
    sqlite3_finalize(stmt);
}
//车型
+ (void)insertCarTypeId:(NSString *)typeId parentId:(NSString *)parentId typeName:(NSString *)name firstLetter:(NSString *)firstLetter
{
    sqlite3 *db = [DataBase openDB];
    sqlite3_stmt *stmt = nil;
    
    NSString *codeId = [NSString stringWithFormat:@"%@%@",parentId,typeId];
    int result = sqlite3_prepare(db, "insert into carType(id,parentId,name,firstLetter,codeId) values(?,?,?,?,?)", -1, &stmt, nil);//?相当于%@格式
    
    sqlite3_bind_text(stmt, 1, [typeId UTF8String], -1, NULL);
    sqlite3_bind_text(stmt, 2, [parentId UTF8String], -1, NULL);
    sqlite3_bind_text(stmt, 3, [name UTF8String], -1, NULL);
    sqlite3_bind_text(stmt, 4, [firstLetter UTF8String], -1, NULL);
    sqlite3_bind_text(stmt, 5, [codeId UTF8String], -1, NULL);
    
    result = sqlite3_step(stmt);
    NSLog(@"save type %@ typeResult:%d",name,result);
    
    sqlite3_finalize(stmt);
}
//车款
+ (void)insertCarStyleId:(NSString *)StyleId parentId:(NSString *)parentId StyleName:(NSString *)name
{
    sqlite3 *db = [DataBase openDB];
    sqlite3_stmt *stmt = nil;
    
    NSString *codeId = [NSString stringWithFormat:@"%@%@",parentId,StyleId];
    
    NSLog(@"codeId---------> %@",codeId);
    
    int result = sqlite3_prepare(db, "insert into carStyle(id,parentId,name,codeId) values(?,?,?,?)", -1, &stmt, nil);//?相当于%@格式
    
    sqlite3_bind_text(stmt, 1, [StyleId UTF8String], -1, NULL);
    sqlite3_bind_text(stmt, 2, [parentId UTF8String], -1, NULL);
    sqlite3_bind_text(stmt, 3, [name UTF8String], -1, NULL);
    sqlite3_bind_text(stmt, 4, [codeId UTF8String], -1, NULL);
    result = sqlite3_step(stmt);
    
    NSLog(@"save style %@ result:%d",name,result);
    
    
    
    sqlite3_finalize(stmt);
}

#pragma - mark 车型数据查询

+ (NSArray *)queryAllCarBrand
{
    sqlite3 *db = [DataBase openDB];
    sqlite3_stmt *stmt = nil;
    //执行SQL语句
    int result = sqlite3_prepare_v2(db, "select * from carBrand", -1, &stmt, nil);
    NSLog(@"All carBrand result = %d",result);
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:1];
    if (result == SQLITE_OK) {
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            const unsigned char *brandId = sqlite3_column_text(stmt, 0);
            const unsigned char *name = sqlite3_column_text(stmt, 1);
            const unsigned char *firstLetter = sqlite3_column_text(stmt, 2);
            
            CarClass *aObjcet = [[CarClass alloc]initWithBrandId:[NSString stringWithUTF8String:(const char *)brandId] brandName:[NSString stringWithUTF8String:(const char *)name] brandFirstName:[NSString stringWithUTF8String:(const char *)firstLetter]];
            
            [resultArray addObject:aObjcet];
        }
    }
    sqlite3_finalize(stmt);
    return resultArray;
}
+ (NSArray *)queryCarTypeWithParentId:(NSString *)superId
{
    sqlite3 *db = [DataBase openDB];
    sqlite3_stmt *stmt = nil;
    //执行SQL语句
    int result = sqlite3_prepare_v2(db, "select * from carType where parentId = ?", -1, &stmt, nil);
    NSLog(@"All carType result = %d",result);
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:1];
    
    if (result == SQLITE_OK) {
        
        sqlite3_bind_text(stmt, 1, [superId UTF8String], -1, Nil);
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            const unsigned char *id = sqlite3_column_text(stmt, 0);
            const unsigned char *parentId = sqlite3_column_text(stmt, 1);
            const unsigned char *name = sqlite3_column_text(stmt, 2);
            const unsigned char *firstLetter = sqlite3_column_text(stmt, 3);
            
            CarClass *aObjcet = [[CarClass alloc]initWithParentId:
                                 [NSString stringWithUTF8String:(const char *)parentId] typeId:[NSString stringWithUTF8String:(const char *)id] typeName:[NSString stringWithUTF8String:(const char *)name] firstLetter:[NSString stringWithUTF8String:(const char *)firstLetter]];
            
            [resultArray addObject:aObjcet];
        }
    }
    sqlite3_finalize(stmt);
    return resultArray;
}
+ (NSArray *)queryCarStyleWithParentId:(NSString *)superId
{
    sqlite3 *db = [DataBase openDB];
    sqlite3_stmt *stmt = nil;
    //执行SQL语句
    int result = sqlite3_prepare_v2(db, "select * from carStyle where parentId = ?", -1, &stmt, nil);
    NSLog(@"All carType result = %d",result);
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:1];
    
    if (result == SQLITE_OK) {
        
        sqlite3_bind_text(stmt, 1, [superId UTF8String], -1, Nil);
        
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            const unsigned char *id = sqlite3_column_text(stmt, 0);
            const unsigned char *parentId = sqlite3_column_text(stmt, 1);
            const unsigned char *name = sqlite3_column_text(stmt, 2);
            
            CarClass *aObjcet = [[CarClass alloc]initWithParentId:[NSString stringWithUTF8String:(const char *)parentId] styleId:[NSString stringWithUTF8String:(const char *)id] styleName:[NSString stringWithUTF8String:(const char *)name]];
            
            [resultArray addObject:aObjcet];
        }
    }
    sqlite3_finalize(stmt);
    return resultArray;
}


@end
