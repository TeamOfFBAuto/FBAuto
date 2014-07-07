//
//  SendCarParamsController.h
//  FBAuto
//
//  Created by lichaowei on 14-7-2.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "FBBaseViewController.h"

/**
 *  发布车源 参数选择页
 */

typedef enum{
    
    Data_Car_Series = 0,//车系
    Data_Car_Model, //车型
    Data_Standard, //规格
    Data_Price,//价格
    Data_Timelimit, //期限
    Data_Color_Out,//外观颜色
    Data_Color_In//内饰颜色
    
}DATASTYLE;

//typedef void(^ selectParams) (da);

@interface SendCarParamsController : FBBaseViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,retain)NSArray *dataArray;
@property(nonatomic,retain)UITableView *table;
@property(nonatomic,assign)DATASTYLE dataStyle;
@property(nonatomic,retain)UILabel *selectLabel;//选中label

@end