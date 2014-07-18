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

@property(nonatomic,strong)NSIndexPath *lastIndexPath;//上一个indexpath

@property(nonatomic,assign)int flagHeight;//现在的点击的高
@property(nonatomic,assign)int lastHeight;//上一个indxpath的高

@property(nonatomic,assign)int gtype;// 2:我的车源    3我的寻车


@end
