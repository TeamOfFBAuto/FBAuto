//
//  XMPPMessageModel.h
//  FBAuto
//
//  Created by lichaowei on 14-7-28.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMPPMessageModel : NSObject

@property(nonatomic,retain)NSString *fromPhone;//车型
@property(nonatomic,retain)NSString *fromName;
@property(nonatomic,retain)NSString *newestMessage;
@property(nonatomic,retain)NSString *time;

- (id)initWithFromPhone:(NSString *)phoneName
                 fromName:(NSString *)fromName
            newestMessage:(NSString *)newestMessage
                     time:(NSString *)time;

@end
