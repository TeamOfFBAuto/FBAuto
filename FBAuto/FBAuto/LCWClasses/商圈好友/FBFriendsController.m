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

@interface FBFriendsController ()

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
    
    self.table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.height - 44 - (iPhone5 ? 20 : 0)) style:UITableViewStylePlain];
    _table.delegate = self;
    _table.dataSource = self;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_table];
    
    _table.tableHeaderView = [self tableHeaderView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            FBChatViewController *addFriend = [[FBChatViewController alloc]init];
            [self.navigationController pushViewController:addFriend animated:YES];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark-UITableViewDelegate

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"A";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return _dataArray.count;
    return 4;
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
    
    cell.textLabel.text = [_dataArray objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    
    __block typeof(FBFriendsController *)weakSelf = self;
    
    [cell getCellData:@"hhe" cellBlock:^(NSString *friendInfo) {
        [weakSelf clickToChat];
    }];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSString *select = [_dataArray objectAtIndex:indexPath.row];
//    self.selectLabel.text = select;
//    [self clickToBack:nil];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

- (void)clickToChat
{
    FBChatViewController *chat = [[FBChatViewController alloc]init];
    chat.chatWithUser = @"test2";
    [self.navigationController pushViewController:chat animated:YES];
}

@end
