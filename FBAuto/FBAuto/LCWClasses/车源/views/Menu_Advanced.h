//
//  Menu_Advanced.h
//  FBAuto
//
//  Created by lichaowei on 14-6-30.
//  Copyright (c) 2014年 szk. All rights reserved.
//

/**
 *  仅用于 高级
 */


#import <UIKit/UIKit.h>
typedef enum {
    Select_Area = 0,//block类型,地区
    Select_Out_Color,//外饰颜色
    Select_In_Color//内饰颜色
}BlockStyle;

typedef void(^SelectBlock) (BlockStyle style, NSString *select);

@interface Menu_Advanced : UIView<UITableViewDataSource,UITableViewDelegate>
{
    UIView *frontV;//需要提前的view
    UIImageView *arrowImage;//箭头
    
    NSMutableDictionary *cityDic;//存储分组城市
    NSArray *firstLetterArray;//分组首字母数据
    
    UITableView *table;
    NSArray *dataArray;
    
    UITableView *secondTable;//二级table
    NSArray *secondArray;
    
    UITableView *thirdTable;//三级table
    NSArray *thirdArray;
    
    UITableView *colorTable;//控制颜色相关table
    NSArray *colorArray;
    
    CGFloat sumHeight;//总高度
    SelectBlock selectBlock;
    
    BlockStyle blockStyle;//一级的上一次选择
}

@property(nonatomic,assign)NSInteger itemIndex;//第几个item,用于控制箭头位置

- (id)initWithFrontView:(UIView *)frontView;
- (void)showInView:(UIView *)aView;
- (void)hidden;

- (void)selectBlock:(SelectBlock)aBlock;

@end
