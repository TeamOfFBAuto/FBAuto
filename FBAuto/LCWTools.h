//
//  LCWTools.h
//  FBAuto
//
//  Created by lichaowei on 14-7-9.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FBAUTO_CARSOURCE_TIME @"FBAUTO_CARSOURE_TIME"//车型数据请求时间

typedef void(^ urlRequestBlock)(NSDictionary *result,NSError *erro);

@interface LCWTools : NSObject<NSURLConnectionDelegate,NSURLConnectionDataDelegate>
{
    urlRequestBlock urlBlock;
    NSString *requestUrl;
    NSData *requestData;
    BOOL isPostRequest;//是否是post请求
}
+ (id)shareInstance;


/**
 *  网络请求
 */
- (id)initWithUrl:(NSString *)url isPost:(BOOL)isPost postData:(NSData *)postData;//初始化请求

- (void)requestCompletion:(void(^)(NSDictionary *result,NSError *erro))completionBlock;//处理请求结果

/**
 *  验证 邮箱、电话等
 */

+ (BOOL)isValidateEmail:(NSString *)email;
+ (BOOL)isValidateName:(NSString *)userName;
+ (BOOL)isValidatePwd:(NSString *)pwdString;
+ (BOOL)isValidateMobile:(NSString *)mobileNum;

/**
 *  CoreData数据管理
 */

//品牌增、删、查
#define CARSOURCE_BRAND_INSERT @"CAR_BRAND_INSERT"
#define CARSOURCE_BRAND_QUERY @"CAR_BRAND_QUERY"
#define CARSOURCE_BRAND_DELETE @"CAR_BRAND_DELETE"

//车型赠、删、查
#define CARSOURCE_TYPE_INSETT @"CARSOURCE_TYPE_INSETT"
#define CARSOURCE_TYPE_QUERY @"CARSOURCE_TYPE_QUERY"
#define CARSOURCE_TYPE_DELETE @"CARSOURCE_TYPE_DELETE"

//车款赠、删、查
#define CARSOURCE_STYLE_INSETT @"CARSOURCE_STYLE_INSETT"
#define CARSOURCE_STYLE_QUERY @"CARSOURCE_STYLE_QUERY"
#define CARSOURCE_STYLE_DELETE @"CARSOURCE_STYLE_DELETE"

- (void)insertDataClassType:(NSString *)classType dataArray:(NSMutableArray*)dataArray unique:(NSString *)unique;
//查询
- (NSArray*)queryDataClassType:(NSString *)classType pageSize:(int)pageSize andOffset:(int)currentPage unique:(NSString *)unique;

@end
