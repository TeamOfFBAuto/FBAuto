//
//  XMPPMessageModel.h
//  FBAuto
//
//  Created by lichaowei on 14-7-28.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMPPMessageModel : NSObject

@property(nonatomic,retain)NSString *userPhone;//车型
@property(nonatomic,retain)NSString *status;
@property(nonatomic,assign)BOOL isread;
@property(nonatomic,retain)NSString *message;
@property(nonatomic,retain)NSString *time;
@property(nonatomic,retain)NSString *name;

@end
