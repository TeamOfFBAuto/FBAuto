//
//  FBFriendsController.m
//  FBAuto
//
//  Created by lichaowei on 14-7-3.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "FBFriendsController.h"
#import "Section_Button.h"
#import "FBFriendCell.h"
#import "FBAddFriendsController.h"
#import "FBChatViewController.h"
#import "FBAreaFriensController.h"
#import "FBFriendModel.h"
#import "DXAlertView.h"

#import "XMPPServer.h"

@interface FBFriendsController ()<chatDelegate>
{
    XMPPServer *xmppServer;//xmpp 中心
}

@end

@implementation FBFriendsController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleLabel.text = @"我的好友";
    
    _table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.height - 44 - 20) style:UITableViewStylePlain];
    _table.delegate = self;
    _table.dataSource = self;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_table];
    
    if (self.isShare == NO) {
        _table.tableHeaderView = [self tableHeaderView];
    }
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 10)];
    view.backgroundColor = [UIColor clearColor];
    _table.tableFooterView = view;
    
    [self getFriendlist];
    
    xmppServer = [XMPPServer shareInstance];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    NSLog(@"--------%s",__FUNCTION__);
    _table.dataSource = nil;
    _table.delegate = nil;
    _table = nil;
    firstLetterArr = nil;
    friendsDic = nil;
}

#pragma - mark 网络请求

- (void)getFriendlist
{
    __weak typeof (self)weakSelf = self;
    
    LCWTools *tools = [[LCWTools alloc]initWithUrl:[NSString stringWithFormat:FBAUTO_FRIEND_LIST,[GMAPI getUid]]isPost:NO postData:nil];
    
    [tools requestCompletion:^(NSDictionary *result, NSError *erro) {
        NSLog(@"result %@ erro %@",result,erro);
        
        if ([result isKindOfClass:[NSDictionary class]]) {
            
            int erroCode = [[result objectForKey:@"errcode"]intValue];
            NSString *erroInfo = [result objectForKey:@"errinfo"];
            
            if (erroCode != 0) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:erroInfo delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                
                return ;
            }
            
            NSArray *dataInfo = [result objectForKey:@"datainfo"];
            NSMutableArray *dataArr = [NSMutableArray arrayWithCapacity:dataInfo.count];
            for (NSDictionary *aDic in dataInfo) {
                FBFriendModel *aFriend = [[FBFriendModel alloc]initWithDictionary:aDic];
                
                if (aFriend.buddyname.length > 0) {
                    [dataArr addObject:aFriend];
                }
                
            }
            
            [weakSelf groupForFriends:dataArr];
            
        }
    }failBlock:^(NSDictionary *failDic, NSError *erro) {
        NSLog(@"failDic %@",failDic);
        [LCWTools showMBProgressWithText:[failDic objectForKey:ERROR_INFO] addToView:self.view];
    }];
}

//首字母进行分组
- (void)groupForFriends:(NSMutableArray *)friendsArr
{
    friendsDic = [NSMutableDictionary dictionary];//如： key:A ; value:数组
    firstLetterArr = [NSMutableArray array];
    
    for (FBFriendModel *aModel in friendsArr)
    {
        NSString *firstLetter = [aModel.buddyname getFirstLetter];

        NSMutableArray *groupArr = [NSMutableArray arrayWithArray:[friendsDic objectForKey:firstLetter]];
        [groupArr addObject:aModel];
        [friendsDic setObject:groupArr forKey:firstLetter];
    }
    
    NSArray* arr = [friendsDic allKeys];
    arr = [arr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
            NSComparisonResult result = [obj1 compare:obj2];
            return result==NSOrderedDescending;
        }];
    firstLetterArr = arr;

    [_table reloadData];
}

#pragma - mark 创建headerView

- (UIView *)tableHeaderView
{
    UIView *head = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 165 + 10)];
    head.backgroundColor = [UIColor whiteColor];
    
    NSArray *titles = @[@"添加好友",@"按地区查找",@"联系客服"];
    for (int i = 0; i < 3; i ++) {
        Section_Button *btn = [[Section_Button alloc]initWithFrame:CGRectMake(10, 10 + (10 + 45) * i, 300, 45) title:[titles objectAtIndex:i] target:self action:@selector(clickToDoSomething:) sectionStyle:Section_Normal image:nil];
        btn.tag = 100 + i;
        [head addSubview:btn];
    }
    
    return head;
}

- (void)clickToDoSomething:(Section_Button *)btn
{
    switch (btn.tag) {
        case 100:
        {
            FBAddFriendsController *addFriend = [[FBAddFriendsController alloc]init];
            [self.navigationController pushViewController:addFriend animated:YES];
        }
            break;
        case 101:
        {
            FBAreaFriensController *addFriend = [[FBAreaFriensController alloc]init];
            [self.navigationController pushViewController:addFriend animated:YES];
        }
            break;
        case 102:
        {
            DXAlertView *alert = [[DXAlertView alloc]initWithTitle:@"暂未开通客服" contentText:nil leftButtonTitle:nil rightButtonTitle:@"确定"];
            [alert show];
            
//            __weak typeof(self)weakSelf = self;
            alert.leftBlock = ^(){
                NSLog(@"确定");

            };
            alert.rightBlock = ^(){
                NSLog(@"取消");
                
            };
        }
            break;
            
        default:
            break;
    }
}

#pragma mark-UITableViewDelegate

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [firstLetterArr objectAtIndex:section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [firstLetterArr count];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arr = [friendsDic objectForKey:[firstLetterArr objectAtIndex:section]];
    return [arr count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"fbFriendCell";
    
    FBFriendCell * cell = (FBFriendCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"FBFriendCell" owner:self options:nil]objectAtIndex:0];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSArray *arr = [friendsDic objectForKey:[firstLetterArr objectAtIndex:indexPath.section]];
    FBFriendModel *aModel = [arr objectAtIndex:indexPath.row];
    
    __weak typeof(self)weakSelf = self;
    
    [cell getCellData:aModel cellBlock:^(NSString *friendInfo,int tag) {
        
        if (tag == 0) {
            [weakSelf clickToChatWithUser:aModel.phone userName:aModel.buddyname ? aModel.buddyname : aModel.name userId:aModel.buddyid];
        }else if (tag == 1)
        {
//            [weakSelf clickToShare:aModel.phone userName:aModel.buddyname];
        }
        
    }];
    if (self.isShare) {
        cell.chatToolBgView.hidden = YES;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isShare) {
        NSArray *arr = [friendsDic objectForKey:[firstLetterArr objectAtIndex:indexPath.section]];
        FBFriendModel *aModel = [arr objectAtIndex:indexPath.row];
        
        [self clickToChatWithUser:aModel.phone userName:aModel.buddyname userId:aModel.buddyid];
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

- (void)clickToChatWithUser:(NSString *)user userName:(NSString *)userName userId:(NSString *)userId
{
    FBChatViewController *chat = [[FBChatViewController alloc]init];
    chat.chatWithUser = user;
    chat.chatWithUserName = userName;
    chat.chatUserId = userId;
    chat.isShare = self.isShare;
    if (self.isShare) {
        chat.shareContent = self.shareContent;
    }
    [self.navigationController pushViewController:chat animated:YES];
}

- (void)clickToShare:(NSString *)user userName:(NSString *)userName
{
    DXAlertView *alert = [[DXAlertView alloc]initWithTitle:nil contentText:[self.shareContent objectForKey:@"text"] leftButtonTitle:@"取消" rightButtonTitle:@"分享" isInput:YES];
    [alert show];
    
    __weak typeof(DXAlertView *)weakAlert = alert;
    __weak typeof(self)weakSelf = self;
    alert.leftBlock = ^(){
        NSLog(@"取消");
    };
    alert.rightBlock = ^(){
        NSLog(@"确定");
        [xmppServer sendMessage:weakAlert.inputTextView.text toUser:user shareLink:[self.shareContent objectForKey:@"infoId"] messageBlock:^(NSDictionary *params, int tag) {
            
            if (tag == 1) {
                [LCWTools showMBProgressWithText:@"分享成功" addToView:weakSelf.view];
            }else{
                [LCWTools showMBProgressWithText:@"分享失败" addToView:weakSelf.view];
            }
            
        }];
    };
}

@end
