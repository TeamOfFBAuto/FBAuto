//
//  FBAutoAPIHeader.h
//  FBAuto
//
//  Created by 史忠坤 on 14-6-25.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#ifndef FBAuto_FBAutoAPIHeader_h
#define FBAuto_FBAutoAPIHeader_h

#import "UIView+Frame.h" //布局使用
#import "NSString+PinYin.h"//获取首字母
#import "UIColor+ConvertColor.h"//16进制颜色转换
#import "UIImageView+WebCache.h"
#import "EGORefreshTableHeaderView.h"//下拉刷新

#import "UILabel+GautoMatchedText.h"//文字自适应高度

#import "GMAPI.h"//GODLIKE
#import "SzkAPI.h"


//保存用户信息

#define USERPHONENUMBER @"iphonenumber"

#define USERID @"userid"

#define USERNAME @"username"

#define USERAUTHKEY @"userauthkey"

#define DEVICETOKEN @"devicetoken"




//颜色

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f \
alpha:(a)]

//判断系统版本
#define IOS7_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )
//判断iPhone5
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define FBAUTO_NAVIGATION_IMAGE [UIImage imageNamed:@"daohanglan_bg_640_88"] //导航栏背景

#define FBAUTO_BACK_IMAGE [UIImage imageNamed:@"fanhui_24_42"] //返回按钮


//用户相关API=================

//获取手机验证码
#define FBAUTO_GET_VERIFICATION_CODE @"http://fbautoapp.fblife.com/index.php?c=interface&a=phonecode&phone=%@&optype=%d"

//验证手机验证码
#define FBAUTO_YANZHENG_VERIFICATION_CODE @"http://fbautoapp.fblife.com/index.php?c=interface&a=checkphonecode&phone=%@&code=%@"

//用户注册
#define FBAUTO_REGISTERED @"http://fbautoapp.fblife.com/index.php?c=interface&a=register&phone=%@&password=%@&name=%@&province=%ld&city=%ld&usertype=%d&code=%@&token=%@"

//用户登录
#define FBAUTO_LOG_IN @"http://fbautoapp.fblife.com/index.php?c=interface&a=dologin&phone=%@&upass=%@&token=%@"

//用户退出登录
#define  FBAUTO_LOG_OUT @"http://fbautoapp.fblife.com/index.php?c=interface&a=dologout&uid=%@"

//获取个人信息
#define FBAUTO_GET_USER_INFORMATION @"http://fbautoapp.fblife.com/index.php?c=interface&a=getuser&uid=%@"

//修改用户密码
#define  FBAUTO_MODIFY_PASSWORD @"http://fbautoapp.fblife.com/index.php?c=interface&a=edituser&authkey=%@&password=%@&op=pass"

//修改个人信息-消息模式
#define  FBAUTO_MESSAGE_TYPE @"http://fbautoapp.fblife.com/index.php?c=interface&a=edituser&authkey=%@&msg_visible=%d&op=msg_visib"

//修改个人信息-个人简介
#define FBAUTO_MODIFY_JIANJIE @"http://fbautoapp.fblife.com/index.php?c=interface&a=edituser&authkey=%@&intro=%@&op=intro"

//修改个人信息-详细地址
#define FBAUTO_MODIFY_ADDRESS @"http://fbautoapp.fblife.com/index.php?c=interface&a=edituser&authkey=%@&address=%@&op=address"

//修改个人信息-用户头像
#define FBAUTO_MODIFY_HEADER_IMAGE @"http://fbautoapp.fblife.com/index.php?c=interface&a=edituser&op=headimg&authkey=%@&headimg=%@"

//找回密码
#define FBAUTO_MODIFY_FIND_PASSWORD @"http://fbautoapp.fblife.com/index.php?c=interface&a=resetpass&phone=%@&code=%@&password=%@"

//好友API=================

//好友列表
#define FBAUTO_FRIEND_LIST @"http://fbautoapp.fblife.com/index.php?c=interface&a=getbuddy&uid=%@" //用户id

//添加好友
#define FBAUTO_FRIEND_ADD @"http://fbautoapp.fblife.com/index.php?c=interface&a=addbuddy&authkey=%@&buddyid=%@" //好友uid

//搜索好友
#define FBAUTO_FRIEND_SEARCH @"http://fbautoapp.fblife.com/index.php?c=interface&a=searchbuddy&authkey=%@&keyword=%@" //关键字

//获取通讯录好友
#define FBAUTO_FRIEND_ADDRESSBOOK @"http://fbautoapp.fblife.com/index.php?c=interface&a=getphonemember&authkey=%@&phone=%@&rname=%@"  //authkey : 加密的用户信息 phone : 通讯录电话，用逗号隔开 rname : 通讯录人名，用逗号隔开

//按地区获取好友
#define FBAUTO_FRIEND_AREA @"http://fbautoapp.fblife.com/index.php?c=interface&a=getareabuddy&authkey=%@&province=%@&city=%@"  //province : 省份id，不能为空  city : 城市id，可以为空

//删除好友
#define FBAUTO_FRIEND_DELETE @"http://fbautoapp.fblife.com/index.php?c=interface&a=delbuddy&authkey=%@&buddyid=%@"//好友uid

#define FBAUTO_CARSOURCE_CARTYPE @"http://fbautoapp.fblife.com/index.php?c=interface&a=getcardata"//车型数据


#endif
