//
//  FindCarViewController.m
//  FBAuto
//
//  Created by 史忠坤 on 14-6-25.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "FindCarViewController.h"
#import "FBFriendsController.h"

@interface FindCarViewController ()

@end

@implementation FindCarViewController

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
    
    self.view.backgroundColor=RGBCOLOR(22, 233, 30);

    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.titleLabel.text = @"寻车";
    self.button_back.hidden = YES;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
