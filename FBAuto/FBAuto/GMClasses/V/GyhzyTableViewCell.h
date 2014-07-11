//
//  GyhzyTableViewCell.h
//  FBAuto
//
//  Created by gaomeng on 14-7-11.
//  Copyright (c) 2014年 szk. All rights reserved.
//

//用户主页自定义单元格

#import <UIKit/UIKit.h>

@interface GyhzyTableViewCell : UITableViewCell



//加载控件 并 返回高度
-(CGFloat)loadViewWithIndexPath:(NSIndexPath *)theIndexPath;



@end
