//
//  GloginView.h
//  FBAuto
//
//  Created by gaomeng on 14-7-1.
//  Copyright (c) 2014年 szk. All rights reserved.
//

//登录界面view
#import <UIKit/UIKit.h>
@class GloginViewController;

typedef void (^zhuceBlock)();//注册
typedef void (^findPasswBlock)();//找回密码
typedef void (^dengluBlock)(NSString *usern,NSString *passw);//登录

@interface GloginView : UIView<UITextFieldDelegate>

{
    UIImageView *_zhanghaoBackView;//账号下的图
    UIImageView *_passWordBackView;//密码下的图
    
    UILabel *_placeHolder1;//账号
    UILabel *_placeHolder2;//密码
}


@property(strong,nonatomic)UIImageView *imgLogo;//中间的大logo

@property(strong,nonatomic)UITextField *userTf;//用户名

@property(strong,nonatomic)UITextField  *passWordTf;//密码

@property(strong,nonatomic)UIButton * forgetPassWordButton;//忘记密码的按钮,一期先不做

@property(strong,nonatomic)UIButton * regeistbutton;//新用户注册的按钮

@property(nonatomic,strong)UIView *zhuanquanview;//转圈的菊花加在这个上面


@property(nonatomic)float keyboardeHight;//键盘的高度

@property(nonatomic,strong)UIView *Row3backView;//用户名 密码 登录 的下层view

@property(nonatomic,strong)NSString *userName;//用户输入的用户名
@property(nonatomic,strong)NSString *userPassWord;//用户输入的密码

@property(nonatomic,assign)GloginViewController *delegate;

//block属性
@property(nonatomic,copy)zhuceBlock zhuceBlock;//注册
@property(nonatomic,copy)findPasswBlock findPassBlock;//找回密码
@property(nonatomic,copy)dengluBlock dengluBlock;//登录


//block set方法

//跳转注册界面
-(void)setZhuceBlock:(zhuceBlock)zhuceBlock;
//找回密码
-(void)setFindPassBlock:(findPasswBlock)findPassBlock;
//登录
-(void)setDengluBlock:(dengluBlock)dengluBlock;


//收键盘
-(void)Gshou;

@end

