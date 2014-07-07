//
//  GMAPI.m
//  FBAuto
//
//  Created by gaomeng on 14-7-3.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "GMAPI.h"

@implementation GMAPI

//用户名


//获取用户的devicetoken

+(NSString *)getDeviceToken{
    
    NSString *str_devicetoken=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:DEVICETOKEN]];
    return str_devicetoken;
    
    
}

//获取用户名
+(NSString *)getUsername{
    
    NSString *str_devicetoken=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:USERNAME]];
    if ([str_devicetoken isEqualToString:@"(null)"]) {
        str_devicetoken=@"";
    }
    return str_devicetoken;
    
    
}

//获取authkey
+(NSString *)getAuthkey{
    
    NSString *str_authkey=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:USERAUTHKEY]];
    return str_authkey;
    
}


//获取用户id
+(NSString *)getUid{
    
    NSString *str_uid=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:USERID]];
    return str_uid;
    
}





@end
