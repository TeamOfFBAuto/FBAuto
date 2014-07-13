//
//  GChangePwViewController.m
//  FBAuto
//
//  Created by gaomeng on 14-7-8.
//  Copyright (c) 2014年 szk. All rights reserved.
//

//个人中心点击修改密码跳转的页面
#import "GChangePwViewController.h"

@interface GChangePwViewController ()

@end

@implementation GChangePwViewController


-(void)dealloc{
    NSLog(@"%s",__FUNCTION__);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tfArray = [NSMutableArray arrayWithCapacity:1];
    
    
    //点击回收键盘
    UIControl *backControl = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
    [backControl addTarget:self action:@selector(Gshou) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backControl];
    
    
    
    //框
    for (int i = 0; i<2; i++) {
        UIView *kuang = [[UIView alloc]initWithFrame:CGRectMake(10, 25+i*54, 300, 44)];
        kuang.layer.borderColor = [RGBCOLOR(180, 180, 180)CGColor];
        kuang.layer.borderWidth = 0.5;
        [self.view addSubview:kuang];
    }
    
    //titile
    NSArray *titleArray = @[@"新密码",@"重复新密码"];
    for (int i = 0; i<2; i++) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 38+i*52, 50, 18)];
        UITextField *tf = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame), 38+i*52, 200, 18)];
        
        if (i ==1) {
            titleLabel.frame = CGRectMake(15, 38+i*52, 80, 18);
            
            tf.frame = CGRectMake(CGRectGetMaxX(titleLabel.frame), 38+i*52, 200, 18);
            
        }
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.text = titleArray[i];
        
        [self.tfArray addObject:tf];
        
        [self.view addSubview:titleLabel];
        [self.view addSubview:tf];
    }
    
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor orangeColor];
    [btn setTitle:@"修改" forState:UIControlStateNormal];
    btn.titleLabel.textColor = [UIColor whiteColor];
    btn.frame = CGRectMake(10, 160, 300, 50);
    [btn addTarget:self action:@selector(xiugai) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
    
    
    
}


//收键盘
-(void)Gshou{
    for (UITextField *tf in self.tfArray) {
        [tf resignFirstResponder];
    }
}

//修改按钮
-(void)xiugai{
    NSLog(@"%s",__FUNCTION__);
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
