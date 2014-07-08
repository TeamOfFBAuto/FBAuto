//
//  FBChatViewController.h
//  FBAuto
//
//  Created by lichaowei on 14-7-4.
//  Copyright (c) 2014年 FBLife. All rights reserved.
//

#import "FBBaseViewController.h"

typedef enum{
    Message_Normal = 0,//普通文本、表情
    Message_Image,//图片
}MESSAGE_TYPE;

/**
 *  聊天、好友信息页
 */
@interface FBChatViewController : FBBaseViewController<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(nonatomic,retain)UITableView *table;

@property(nonatomic,retain)NSString *chatWithUser;//交流用户id

@end
