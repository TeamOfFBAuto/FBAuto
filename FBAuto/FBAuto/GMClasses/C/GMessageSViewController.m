//
//  GMessageSViewController.m
//  FBAuto
//
//  Created by gaomeng on 14-7-9.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "GMessageSViewController.h"

@interface GMessageSViewController ()

@end

@implementation GMessageSViewController

- (void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //框
    UIView *kuang = [[UIView alloc]initWithFrame:CGRectMake(10, 15, 300, 45)];
    kuang.layer.borderWidth = 0.5;
    kuang.layer.borderColor = [RGBCOLOR(180, 180, 180)CGColor];
    [self.view addSubview:kuang];
    
    //文字titile
    UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(22, 30, 60, 17)];
    titleLable.text = @"接收消息";
    titleLable.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:titleLable];
    
    
    //开关
    UISwitch *swi = [[UISwitch alloc]initWithFrame:CGRectMake(245, 20, 0, 0)];
    swi.onTintColor = [UIColor orangeColor];
    swi.on = YES;
    [swi addTarget:self action:@selector(onOrOff:) forControlEvents:UIControlEventValueChanged];
    
    
    
    
    
    
    [self.view addSubview:swi];
    
    
    
    
}



-(void)onOrOff:(UISwitch*)sender{
    BOOL isButtonOn = [sender isOn];
    if (isButtonOn) {//开
        
    }else {//关
        
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
