//
//  GjjxxViewController.h
//  FBAuto
//
//  Created by gaomeng on 14-7-10.
//  Copyright (c) 2014年 szk. All rights reserved.
//


//个人中心 个人资料 简介和详细的页面
#import <UIKit/UIKit.h>


//网络相关
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

@interface GjjxxViewController : UIViewController<ASIHTTPRequestDelegate>

{
    UITextView *_textView;//输入tv
}

@property(nonatomic,assign)int gtype;// 3详细地址  4简介

@end
