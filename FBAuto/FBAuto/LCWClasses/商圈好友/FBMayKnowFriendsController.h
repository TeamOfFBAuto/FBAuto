//
//  FBMayKnowFriendsController.h
//  FBAuto
//
//  Created by lichaowei on 14-7-4.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "FBBaseViewController.h"
/**
 *  可能认识的人
 */
@interface FBMayKnowFriendsController : FBBaseViewController<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,retain)NSArray *dataArray;
@property(nonatomic,retain)UITableView *table;

@end
