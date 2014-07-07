//
//  FBChatViewController.h
//  FBAuto
//
//  Created by lichaowei on 14-7-4.
//  Copyright (c) 2014年 FBLife. All rights reserved.
//

#import "FBBaseViewController.h"

/**
 *  聊天、好友信息页
 */
@interface FBChatViewController : FBBaseViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,retain)UITableView *table;

@end
