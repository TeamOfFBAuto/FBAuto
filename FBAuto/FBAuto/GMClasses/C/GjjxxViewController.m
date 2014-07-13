//
//  GjjxxViewController.m
//  FBAuto
//
//  Created by gaomeng on 14-7-10.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "GjjxxViewController.h"

@interface GjjxxViewController ()

@end

@implementation GjjxxViewController

- (void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(gsave)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    
    
    //框
    UIView *kuang = [[UIView alloc]initWithFrame:CGRectMake(10, 15, 300, 288)];
    kuang.layer.borderWidth = 0.5;
    kuang.layer.borderColor = [RGBCOLOR(220, 220, 220)CGColor];
    
    
    //输入框textview
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 0, 280, 288)];
    [kuang addSubview:textView];
    
    
    //添加视图
    [self.view addSubview:kuang];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)gsave{
    NSLog(@"%s",__FUNCTION__);
    [self.navigationController popToRootViewControllerAnimated:YES];
}






@end
