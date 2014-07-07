//
//  Statics.h
//  XmppDemo
//
//  Created by 夏 华 on 12-7-13.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

//static NSString *USERID = @"userId";
static NSString *JID = @"jid";
static NSString *PASS= @"pass";
static NSString *SERVER = @"server";

@interface Statics : NSObject

+(NSString *)getCurrentTime;
+ (CGFloat)imageValue:(NSString *)html for:(NSString*)string;
+ (NSString *)imageUrl:(NSString *)html;

+ (void)updateFrameForImageView:(UIImageView *)imageView  originalWidth:(CGFloat)width originalHeight:(CGFloat)height;//调整imageView大小

@end
