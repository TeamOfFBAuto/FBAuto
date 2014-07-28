//
//  GjjxxViewController.m
//  FBAuto
//
//  Created by gaomeng on 14-7-10.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "GjjxxViewController.h"

#import "GmLoadData.h"

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
    
    NSLog(@"%s",__FUNCTION__);
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(gsave)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    
    
    
    
    //框
    UIView *kuang = [[UIView alloc]initWithFrame:CGRectMake(10, 15, 300, 288)];
    kuang.layer.borderWidth = 0.5;
    kuang.layer.borderColor = [RGBCOLOR(220, 220, 220)CGColor];
    
    
    //输入框textview
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 0, 280, 288)];
    [kuang addSubview:_textView];
    
    
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
    //上传详细地址
    [self testDizhi];
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 上传地区信息(文本)
-(void)testDizhi{
    if (self.gtype == 3) {//详细地址
        GmLoadData *_test=[[GmLoadData alloc]init];
        
        NSString *dizhi = [_textView.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        
        //转码
        NSString *dizhiUtf8 = [dizhi stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSString *str = [NSString stringWithFormat:FBAUTO_MODIFY_ADDRESS,[GMAPI getAuthkey],dizhiUtf8];
        
        //get
        [_test SeturlStr:str block:^(NSDictionary *dataInfo, NSString *errorinfo, NSInteger errcode) {
            if (errcode == 0) {
                
                NSLog(@"成功");
                //发通知
                [[NSNotificationCenter defaultCenter]postNotificationName:FBAUTO_CHANGEPERSONALINFO object:nil];
            }else{
                
                NSLog(@"修改失败 == %@",errorinfo);
                
            }
        }];
        
        
    }else if (self.gtype == 4){//简介
        
        GmLoadData *_test = [[GmLoadData alloc]init];
        NSString *jianjie = [_textView.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *str = [NSString stringWithFormat:FBAUTO_MODIFY_JIANJIE,[GMAPI getAuthkey],jianjie];
        //get请求
        [_test SeturlStr:str block:^(NSDictionary *dataInfo, NSString *errorinfo, NSInteger errcode) {
            
            
            if (errcode == 0) {
                NSLog(@"成功");
                //发通知
                [[NSNotificationCenter defaultCenter]postNotificationName:FBAUTO_CHANGEPERSONALINFO object:nil];
            }else{
                NSLog(@"修改失败 == %@",errorinfo);
            }
        }];
    }
    
}



@end
