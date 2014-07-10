//
//  GlxwmViewController.m
//  FBAuto
//
//  Created by gaomeng on 14-7-10.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "GlxwmViewController.h"

@interface GlxwmViewController ()

@end

@implementation GlxwmViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //navigation
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 20, 290, 15)];
    
    for (int i = 0; i<5; i++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 20+i*25, 290, 15)];
        if (i == 0) {
            label.font = [UIFont systemFontOfSize:15];
        }else{
            label.font = [UIFont systemFontOfSize:10];
        }
        
        
        
        
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
