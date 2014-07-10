//
//  GperInfoViewController.h
//  FBAuto
//
//  Created by gaomeng on 14-7-10.
//  Copyright (c) 2014年 szk. All rights reserved.
//



//个人中心 我的资料
#import <UIKit/UIKit.h>

@class GperInfoTableViewCell;

@interface GperInfoViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

{
    UITableView *_tableview;//主tableview
    
    GperInfoTableViewCell *_tmpCell;//临时cell用户获取单元格高度
}


@end
