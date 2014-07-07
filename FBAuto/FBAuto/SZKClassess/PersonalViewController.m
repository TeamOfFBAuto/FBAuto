//
//  PersonalViewController.m
//  FBAuto
//
//  Created by 史忠坤 on 14-6-25.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "PersonalViewController.h"
#import "FBFriendsController.h"
#import "FBPhotoBrowserController.h"

@interface PersonalViewController ()

@end

@implementation PersonalViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=RGBCOLOR(22, 23, 3);

    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.titleLabel.text = @"个人中心";
    self.button_back.hidden = YES;
    
    [self test];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)test
{
    UIButton *addPhoto2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    addPhoto2.frame = CGRectMake(100,100 + 100, 100, 50);
    [addPhoto2 addTarget:self action:@selector(clickToDetail) forControlEvents:UIControlEventTouchUpInside];
    [addPhoto2 setTitle:@"商圈" forState:UIControlStateNormal];
    [self.view addSubview:addPhoto2];
}

- (void)clickToDetail
{
    FBFriendsController *friends = [[FBFriendsController alloc]init];
    friends.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:friends animated:YES];
}


@end
