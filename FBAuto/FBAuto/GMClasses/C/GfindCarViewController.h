//
//  GfindCarViewController.h
//  FBAuto
//
//  Created by gaomeng on 14-7-8.
//  Copyright (c) 2014年 szk. All rights reserved.
//


//个人界面 寻车
#import <UIKit/UIKit.h>
@class GfindCarTableViewCell;

@interface GfindCarViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableiView;//主tablevew
    GfindCarTableViewCell *_tmpCell;//用户获取单元格高度的cell对象
    
}


@property(nonatomic,strong)NSIndexPath *flagIndexPath;//用于标记有菜单的cell

@property(nonatomic,assign)int gtype;//寻车：3         车源：2



@end
