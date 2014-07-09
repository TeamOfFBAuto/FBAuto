//
//  LCWTools.h
//  FBAuto
//
//  Created by lichaowei on 14-7-9.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ urlRequestBlock)(NSDictionary *result,NSError *erro);

@interface LCWTools : NSObject<NSURLConnectionDelegate,NSURLConnectionDataDelegate>
{
    urlRequestBlock urlBlock;
    NSString *requestUrl;
}
+ (id)shareInstance;

- (id)initWithUrl:(NSString *)url;

- (void)requestWithUrl:(NSString *)url completion:(void(^)(NSDictionary *result,NSError *erro))completionBlock;
- (void)requestCompletion:(void(^)(NSDictionary *result,NSError *erro))completionBlock;


@end
