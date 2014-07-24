//
//  GxiaoxiTableViewCell.h
//  FBAuto
//
//  Created by gaomeng on 14-7-24.
//  Copyright (c) 2014年 szk. All rights reserved.
//


//站内消息
#import <UIKit/UIKit.h>
@class GxiaoxiViewController;

@interface GxiaoxiTableViewCell : UITableViewCell


@property(nonatomic,assign)GxiaoxiViewController *delegate;

-(CGFloat)loadViewWithIndexPath:(NSIndexPath *)theIndexPath;

-(void)configWithNetData:(NSMutableArray*)array indexPath:(NSIndexPath*)theIndexPath;

@end
