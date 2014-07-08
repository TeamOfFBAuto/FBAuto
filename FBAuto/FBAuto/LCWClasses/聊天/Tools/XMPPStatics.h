//
//  Statics.h
//  XmppDemo
//
//  Created by 夏 华 on 12-7-13.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *XMPP_USERID = @"userId";
static NSString *XMPP_JID = @"jid";
static NSString *XMPP_PASS= @"pass";
static NSString *XMPP_SERVER = @"server";

@interface XMPPStatics : NSObject

+(NSString *)getCurrentTime;
+ (CGFloat)imageValue:(NSString *)html for:(NSString*)string;
+ (NSString *)imageUrl:(NSString *)html;

+ (void)updateFrameForImageView:(UIImageView *)imageView  originalWidth:(CGFloat)width originalHeight:(CGFloat)height;//调整imageView大小

@end
