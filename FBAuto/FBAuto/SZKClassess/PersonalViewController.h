//
//  PersonalViewController.h
//  FBAuto
//
//  Created by 史忠坤 on 14-6-25.
//  Copyright (c) 2014年 szk. All rights reserved.
//


//个人中心 
#import <UIKit/UIKit.h>

@interface PersonalViewController : FBBaseViewController<UITableViewDelegate,UITableViewDataSource>

{
    UITableView *_tableView;//主tableview
}

@property(nonatomic,strong)UIImageView *userFaceImv;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *nameLabel1;



@end
