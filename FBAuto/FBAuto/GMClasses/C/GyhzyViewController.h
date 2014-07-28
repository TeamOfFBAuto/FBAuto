//
//  GyhzyViewController.h
//  FBAuto
//
//  Created by gaomeng on 14-7-11.
//  Copyright (c) 2014年 szk. All rights reserved.
//


//用户主页界面 点击车源信息下面的用户信息view跳转的页面
#import <UIKit/UIKit.h>
@class GyhzyTableViewCell;
@class GuserModel;

@interface GyhzyViewController : FBBaseViewController<UITableViewDataSource,UITableViewDelegate>

{
    UITableView *_tableView;//主tableview
    
    GyhzyTableViewCell *_tmpCell;//临时用来获取高度的cell
    
    
    int _page;//第几页
    NSArray *_dataArray;
    
}

@property(nonatomic,retain)NSString *title;

@property(nonatomic,strong)NSString *userId;//用于获取数据的用户id

@property(nonatomic,strong)GuserModel *guserModel;



@end
