//
//  LCWTools.m
//  FBAuto
//
//  Created by lichaowei on 14-7-9.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "LCWTools.h"
#import "AppDelegate.h"

#import "CarBrand.h"
#import "CarType.h"
#import "CarStyle.h"

@implementation LCWTools

+ (id)shareInstance
{
    static dispatch_once_t once_t;
    static LCWTools *dataBlock;
    
    dispatch_once(&once_t, ^{
        dataBlock = [[LCWTools alloc]init];
    });
    
    return dataBlock;
}

- (id)initWithUrl:(NSString *)url isPost:(BOOL)isPost postData:(NSData *)postData//post
{
    self = [super init];
    if (self) {
        requestUrl = url;
        
        if (isPost) {
            requestData = postData;
            isPostRequest = isPost;
        }
    }
    return self;
}

- (void)requestCompletion:(void(^)(NSDictionary *result,NSError *erro))completionBlock
{
    urlBlock = completionBlock;
    
    NSString *newStr = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"requestUrl %@",requestUrl);
    NSURL *urlS = [NSURL URLWithString:newStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:urlS cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:2];
    
    if (isPostRequest) {
        
        [request setHTTPMethod:@"POST"];
        
        [request setHTTPBody:requestData];
    }
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (data.length > 0) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            NSLog(@"response :%@",response);
            urlBlock(dic,connectionError);
        }else
        {
            NSLog(@"data 为空");
        }
       
    }];
}


#pragma - mark 验证邮箱、电话等有效性

/*邮箱*/
+ (BOOL)isValidateEmail:(NSString *)email
{
    NSString * emailRegex = @"\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*";
    NSPredicate * emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (BOOL)isValidateName:(NSString *)userName
{
    NSString * emailRegex = @"^[\u4E00-\u9FA5a-zA-Z0-9_]{1,20}$";
    NSPredicate * emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailRegex];
    return [emailTest evaluateWithObject:userName];
}

+ (BOOL)isValidatePwd:(NSString *)pwdString
{
    NSString * emailRegex = @"^[a-zA-Z0-9_]{6,20}$";
    NSPredicate * emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailRegex];
    return [emailTest evaluateWithObject:pwdString];
}

/*手机及固话*/
+ (BOOL)isValidateMobile:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma - mark CoreData数据管理

- (NSManagedObjectContext *)context
{
    return ((AppDelegate *)[[UIApplication sharedApplication]delegate]).managedObjectContext;
}

#pragma - mark 插入数据

//插入数据
- (void)insertDataClassType:(NSString *)classType dataArray:(NSMutableArray*)dataArray unique:(NSString *)unique
{
    NSLog(@"insertDataClassType----> %@",classType);
    
    if([classType isEqualToString:CARSOURCE_BRAND_INSERT])
    {
        [self insertCarBrand:dataArray unique:unique];
        
    }else if ([classType isEqualToString:CARSOURCE_STYLE_INSETT])
    {
        
        
    }else if([classType isEqualToString:CARSOURCE_TYPE_INSETT])
    {
        
    }
}

- (void)insertCarBrand:(NSArray *)dataArray unique:(NSString *)unique
{
    NSManagedObjectContext *context = [self context];
    
    for (CarBrand *aBrand in dataArray) {
        CarBrand *aEntityMenu = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([CarBrand class]) inManagedObjectContext:context];
        
        aEntityMenu = aBrand;
        
        
        NSError *erro;
        if (![context save:&erro]) {
            NSLog(@"FirstMenu 保存失败：%@",erro);
        }else
        {
            NSLog(@"FirstMenu 保存成功");
        }
    }
}

#pragma - mark 查询数据

//查询
- (NSArray*)queryDataClassType:(NSString *)classType pageSize:(int)pageSize andOffset:(int)currentPage unique:(NSString *)unique
{
    if([classType isEqualToString:CARSOURCE_BRAND_QUERY])
    {
        return [self queryCarBrand];
        
    }else if ([classType isEqualToString:CARSOURCE_TYPE_QUERY])
    {
        return [self queryCarTypeUnique:unique];
        
    }else if ([classType isEqualToString:CARSOURCE_STYLE_QUERY])
    {
        return [self queryCarStyleUnique:unique];
        
    }
    return nil;
}

//车品牌
- (NSArray*)queryCarBrand
{
    NSManagedObjectContext *context = [self context];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([CarBrand class]) inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    return fetchedObjects;
}

//车型
- (NSArray*)queryCarTypeUnique:(NSString *)unique
{
    NSManagedObjectContext *context = [self context];
    
    NSPredicate *predicate = [NSPredicate
                              predicateWithFormat:@"parentId like[cd] %@",unique];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    [fetchRequest setPredicate:predicate];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([CarType class]) inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    return fetchedObjects;
}

//车款
- (NSArray*)queryCarStyleUnique:(NSString *)unique
{
    NSManagedObjectContext *context = [self context];
    
    NSPredicate *predicate = [NSPredicate
                              predicateWithFormat:@"parentId like[cd] %@",unique];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    [fetchRequest setPredicate:predicate];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([CarStyle class]) inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    return fetchedObjects;
}

@end
