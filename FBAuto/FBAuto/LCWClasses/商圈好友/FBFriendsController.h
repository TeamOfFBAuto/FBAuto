//
//  FBFriendsController.h
//  FBAuto
//
//  Created by lichaowei on 14-7-3.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "FBBaseViewController.h"

/**
 *  好友列表
 */
@interface FBFriendsController : FBBaseViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *firstLetterArr;//存放首字母
    NSMutableDictionary *friendsDic;//存放分组的好友
}
@property(nonatomic,retain)NSArray *dataArray;
@property(nonatomic,retain)UITableView *table;
@end
