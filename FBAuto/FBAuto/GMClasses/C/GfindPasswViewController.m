//
//  GfindPasswViewController.m
//  FBAuto
//
//  Created by gaomeng on 14-7-2.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "GfindPasswViewController.h"

#import "SzkLoadData.h"

@interface GfindPasswViewController ()

@end

@implementation GfindPasswViewController



- (void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    
    NSArray *titleArray = @[@"手机号",@"验证码",@"新密码"];
    
    //加载视图
    for (int i = 0; i<3; i++) {
        //框
        UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(10, 25 +i*53, 300, 44)];
        //view.layer.cornerRadius = 4;//设置那个圆角的有多圆
        view1.layer.borderWidth = 0.5;//设置边框的宽度，当然可以不要
        view1.layer.borderColor = [RGBCOLOR(180, 180, 180) CGColor];//设置边框的颜色
        //view.backgroundColor = [UIColor purpleColor];
        view1.userInteractionEnabled = NO;//关掉用户触摸
        [self.view addSubview:view1];
        
        //title
        UILabel *titileLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 42+i*50, 200, 15)];
        titileLabel.font = [UIFont systemFontOfSize:15];
        titileLabel.text = titleArray[i];
        [self.view addSubview:titileLabel];
        
        //content
        UITextField *contentf = [[UITextField alloc]initWithFrame:CGRectMake(70, 42+i*50, 200, 15)];
        [self.view addSubview:contentf];
        if (i == 0) {
            self.phonetf = contentf;
        }else if (i == 1){
            self.yanzhengtf = contentf;
        }else if (i == 2){
            self.passWordtf = contentf;
        }
        
        
    }
    
    //获取验证码
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(10, 180, 300, 50);
    [btn1 setTitle:@"获取验证码" forState:UIControlStateNormal];
    btn1.backgroundColor = RGBCOLOR(149, 149, 149);
    btn1.layer.cornerRadius = 4;
    [btn1 addTarget:self action:@selector(yanzhengma) forControlEvents:UIControlEventTouchUpInside];
    _yanzhengBtn = btn1;
    [self.view addSubview:btn1];
    
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(10, CGRectGetMaxY(btn1.frame)+5, 300, 50);
    [btn2 setTitle:@"重置密码" forState:UIControlStateNormal];
    btn2.backgroundColor = [UIColor orangeColor];
    btn2.layer.cornerRadius = 4;
    [btn2 addTarget:self action:@selector(zhaohui) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
    
    
}

//获取验证码
-(void)yanzhengma{
    _yanzhengBtn.userInteractionEnabled = NO;
    SzkLoadData *szk = [[SzkLoadData alloc]init];
    
    NSString *str = [NSString stringWithFormat:FBAUTO_GET_VERIFICATION_CODE,self.phonetf.text,2];
    [szk SeturlStr:str block:^(NSArray *arrayinfo, NSString *errorindo, NSInteger errcode) {
        
    }];
    
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changexianshi) userInfo:nil repeats:YES];
    [_timer fire];
    
    _timeNum = 60;
    
    [_yanzhengBtn setTitle:[NSString stringWithFormat:@"%d秒后重新发送",_timeNum] forState:UIControlStateNormal];
    
    
    
}



-(void)changexianshi{
    
    
    _timeNum--;
    [_yanzhengBtn setTitle:[NSString stringWithFormat:@"%d秒后重新发送",_timeNum] forState:UIControlStateNormal];
    
    if (_timeNum == 0) {
        [_yanzhengBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_timer invalidate];
        _yanzhengBtn.userInteractionEnabled = YES;
    }
}




//重置密码
-(void)zhaohui{
    
    SzkLoadData *szk = [[SzkLoadData alloc]init];
    NSString *str = [NSString stringWithFormat:FBAUTO_MODIFY_FIND_PASSWORD,self.phonetf.text,self.yanzhengtf.text,self.passWordtf.text];
    [szk SeturlStr:str block:^(NSArray *arrayinfo, NSString *errorindo, NSInteger errcode) {
        
        if (errcode==0) {
            UIAlertView *aler = [[UIAlertView alloc]initWithTitle:@"重置成功" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [aler show];
        }else{
            
            UIAlertView *alertV=[[UIAlertView alloc]initWithTitle:errorindo message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertV show];
            
            
        }
    }];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
