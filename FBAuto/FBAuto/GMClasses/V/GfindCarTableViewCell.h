//
//  GfindCarTableViewCell.h
//  FBAuto
//
//  Created by gaomeng on 14-7-8.
//  Copyright (c) 2014年 szk. All rights reserved.
//


// 个人中心 寻车自定义cell
#import <UIKit/UIKit.h>
@class GfindCarViewController;

typedef void (^addViewBlock)();//点击箭头添加选项菜单view

@interface GfindCarTableViewCell : UITableViewCell

@property(nonatomic,assign)BOOL ischoose;//是否添加了视图
@property(nonatomic,copy)addViewBlock addviewBlock;
@property(nonatomic,strong)GfindCarViewController *delegate;//代理
@property(nonatomic,strong)NSIndexPath *flagIndexPath;//标记

@property(nonatomic,assign)int isGreen;//是否点击 再点一下收起  60开  120收

-(void)setAddviewBlock:(addViewBlock)addviewBlock;

-(CGFloat)loadView:(NSIndexPath*)theIndexPath;//加载控件并返回高度


@end
