//
//  GuserModel.m
//  FBAuto
//
//  Created by gaomeng on 14-7-25.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "GuserModel.h"

@implementation GuserModel

-(id)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}


@end
