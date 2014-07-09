//
//  LCWTools.m
//  FBAuto
//
//  Created by lichaowei on 14-7-9.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "LCWTools.h"

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

- (id)initWithUrl:(NSString *)url 
{
    self = [super init];
    if (self) {
        requestUrl = url;
    }
    return self;
}

- (void)requestWithUrl:(NSString *)url completion:(void(^)(NSDictionary *result,NSError *erro))completionBlock
{
    urlBlock = completionBlock;
    
    NSURL *urlS = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:urlS cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:2];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        NSLog(@"response :%@",response);
        urlBlock(dic,connectionError);
    }];
}

- (void)requestCompletion:(void(^)(NSDictionary *result,NSError *erro))completionBlock
{
    urlBlock = completionBlock;
    
    NSURL *urlS = [NSURL URLWithString:requestUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:urlS cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:2];
    
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

@end
