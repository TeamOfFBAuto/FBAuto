//
//  FBSearchFriendsController.m
//  FBAuto
//
//  Created by lichaowei on 14-7-4.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "FBSearchFriendsController.h"
#import "FBFriend2Cell.h"
#import "ZkingSearchView.h"
#import "FBFriendModel.h"

@interface FBSearchFriendsController ()
{
    ZkingSearchView *zkingSearchV;
}

@end

@implementation FBSearchFriendsController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [zkingSearchV removeFromSuperview];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //搜索
    
    zkingSearchV = [[ZkingSearchView alloc]initWithFrame:CGRectMake(20 + 5, (44 - 30)/2.0, 300, 30) imgBG:[UIImage imageNamed:@"sousuo_bg548_58"] shortimgbg:[UIImage imageNamed:@"sousuo_bg548_58"] imgLogo:[UIImage imageNamed:@"sousuo_icon26_26"] placeholder:@"请输入手机号或姓名" searchWidth:275.f ZkingSearchViewBlocs:^(NSString *strSearchText, int tag) {
        
        [self searchFriendWithname:strSearchText thetag:tag];
        
    }];
    zkingSearchV.backgroundColor = [UIColor clearColor];
    
    CGRect labFrame = zkingSearchV.cancelLabel.frame;
    labFrame.origin.x += 5;
    zkingSearchV.cancelLabel.frame = labFrame;
    
    [self.navigationController.navigationBar addSubview:zkingSearchV];
    
    
    
    self.table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.height - 44 - (iPhone5 ? 20 : 0)) style:UITableViewStylePlain];
    _table.delegate = self;
    _table.dataSource = self;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    _table.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view addSubview:_table];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - mark 搜索好友

- (void)searchFriendWithKeyword:(NSString *)keyWord
{
    LCWTools *tools = [[LCWTools alloc]initWithUrl:[NSString stringWithFormat:FBAUTO_FRIEND_SEARCH,[GMAPI getAuthkey],keyWord] isPost:NO postData:nil];
    
    __block typeof (FBSearchFriendsController *)weakSelf = self;
    
    
    [tools requestCompletion:^(NSDictionary *result, NSError *erro){
        
        if ([result isKindOfClass:[NSDictionary class]]) {
            
            int erroCode = [[result objectForKey:@"errcode"]intValue];
            NSString *erroInfo = [result objectForKey:@"errinfo"];
            
            NSLog(@"result %@ erroInfo %@",result,erroInfo);
            
            if (erroCode != 0) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:erroInfo delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                
                return ;
            }
            
            NSArray *dataInfo = [result objectForKey:@"datainfo"];
            NSMutableArray *dataArr = [NSMutableArray arrayWithCapacity:dataInfo.count];
            for (NSDictionary *aDic in dataInfo) {
                FBFriendModel *aFriend = [[FBFriendModel alloc]initWithDictionary:aDic];
                [dataArr addObject:aFriend];
            }
            
            [weakSelf reloadTableWithDataArray:dataArr];
            
        }

    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        NSLog(@"failDic %@",failDic);
        [LCWTools showMBProgressWithText:[failDic objectForKey:ERROR_INFO] addToView:self.view];
    }];
}

- (void)reloadTableWithDataArray:(NSArray *)arr
{
    self.dataArray = arr;
    [self.table reloadData];
}


-(void)searchFriendWithname:(NSString *)strname thetag:(int )_tag{
    //tag=1,代表取消按钮；tag=2代表开始编辑状态；tag=3代表点击了搜索按钮
    
    CGFloat searchLeft = 0.0f;
    
    // self.navigationController.navigationBarHidden=YES;
    switch (_tag) {
        case 1:
        {
            NSLog(@"取消");
            UIBarButtonItem *back_item=[[UIBarButtonItem alloc]initWithCustomView:self.button_back];
            self.navigationItem.leftBarButtonItems=@[back_item];
            
            searchLeft = 25.f;
            
        }
            break;
        case 2:
        {
            UIButton *_button_back=[[UIButton alloc]initWithFrame:CGRectMake(0,0,0,0)];
            UIBarButtonItem *back_item=[[UIBarButtonItem alloc]initWithCustomView:_button_back];
            self.navigationItem.leftBarButtonItems=@[back_item];
            
            searchLeft = 0.0f;
            
        }
            break;
            
        case 3:
        {
            if (strname.length == 0) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"输入内容不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                return;
            }
            [self searchFriendWithKeyword:strname];
        }
            break;
            
            
        default:
            break;
    }
    
    
    CGRect aFrame = zkingSearchV.frame;
    aFrame.origin.x = searchLeft;
    zkingSearchV.frame = aFrame;
    
}


#pragma mark-UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"fbFriend2Cell";
    
    FBFriend2Cell * cell = (FBFriend2Cell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"FBFriend2Cell" owner:self options:nil]objectAtIndex:0];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    FBFriendModel *aModel = [_dataArray objectAtIndex:indexPath.row];
    
    [cell getCellData:aModel];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSString *select = [_dataArray objectAtIndex:indexPath.row];
    //    self.selectLabel.text = select;
    //    [self clickToBack:nil];
}


@end
