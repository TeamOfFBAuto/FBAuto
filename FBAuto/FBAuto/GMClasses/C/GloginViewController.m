//
//  GloginViewController.m
//  FBAuto
//
//  Created by gaomeng on 14-7-1.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "GloginViewController.h"
#import "GloginView.h"//登录界面view
#import "GzhuceViewController.h"//注册
#import "GfindPasswViewController.h"//找回密码




@interface GloginViewController ()

@end

@implementation GloginViewController



-(void)dealloc{
    NSLog(@"%s",__FUNCTION__);
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



-(void)viewWillAppear:(BOOL)animated{
    //隐藏navigationBar
    self.navigationController.navigationBarHidden = YES;
    
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    
    GloginView *gloginView = [[GloginView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
    self.gloginView = gloginView;
    [self.view addSubview:gloginView];
    
    
    __weak typeof (self)bself = self;
    __weak typeof (gloginView)bgloginView = gloginView;
    
    //设置跳转注册block
    [gloginView setZhuceBlock:^{
        [bgloginView Gshou];
        [bself pushToZhuceVC];
    }];
    
    //设置找回密码block
    [gloginView setFindPassBlock:^{
        [bgloginView Gshou];
        [bself pushToFindPassWordVC];
    }];
    
    //登录
    [gloginView setDengluBlock:^(NSString *usern, NSString *passw) {
        
        NSLog(@"%@     %@",usern,passw);
        
        [bself dengluWithUserName:usern pass:passw];
    }];
    
    
    
    
}






#pragma mark - 登录
-(void)dengluWithUserName:(NSString *)name pass:(NSString *)passw{
    NSString *str = [NSString stringWithFormat:FBAUTO_LOG_IN,name,passw,@"textToken"];
    
    NSLog(@"登录请求接口======%@",str);
    
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",dic);
        
        
        
        if (![dic objectForKey:@"errcode"]) {
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
        
        
    }];
    
    
}



#pragma mark - 跳转到注册界面
-(void)pushToZhuceVC{
    GzhuceViewController *gzhuceVc = [[GzhuceViewController alloc]init];
    [self.navigationController pushViewController:gzhuceVc animated:YES];
}

#pragma mark - 跳转找回密码界面
-(void)pushToFindPassWordVC{
    GfindPasswViewController *gfindwVc = [[GfindPasswViewController alloc]init];
    [self.navigationController pushViewController:gfindwVc animated:YES];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
