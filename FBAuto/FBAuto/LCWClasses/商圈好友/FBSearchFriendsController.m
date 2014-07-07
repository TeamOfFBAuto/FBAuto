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

@interface FBSearchFriendsController ()

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //搜索
    
    ZkingSearchView *zkingSearchV = [[ZkingSearchView alloc]initWithFrame:CGRectMake(0, (44 - 30)/2.0, 550/2.0 + 10, 30) imgBG:[UIImage imageNamed:@"sousuo_bg548_58"] shortimgbg:[UIImage imageNamed:@"sousuo_bg548_58"] imgLogo:[UIImage imageNamed:@"sousuo_icon26_26"] placeholder:@"请输入手机号或姓名" searchWidth:550/2.0 ZkingSearchViewBlocs:^(NSString *strSearchText, int tag) {
        
        [self searchFriendWithname:nil thetag:tag];
    }];
    
    zkingSearchV.isLeft = YES;
    
    zkingSearchV.backgroundColor = [UIColor clearColor];
    
    self.navigationItem.titleView = zkingSearchV;
    
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

-(void)searchFriendWithname:(NSString *)strname thetag:(int )_tag{
    //tag=1,代表取消按钮；tag=2代表开始编辑状态；tag=3代表点击了搜索按钮
    
    // self.navigationController.navigationBarHidden=YES;
    switch (_tag) {
        case 1:
        {
            NSLog(@"取消");
            UIBarButtonItem *back_item=[[UIBarButtonItem alloc]initWithCustomView:self.button_back];
            self.navigationItem.leftBarButtonItems=@[back_item];
            
        }
            break;
        case 2:
        {
//            self.navigationItem.leftItemsSupplementBackButton = NO;
            
            UIButton *_button_back=[[UIButton alloc]initWithFrame:CGRectMake(0,0,0,0)];
            UIBarButtonItem *back_item=[[UIBarButtonItem alloc]initWithCustomView:_button_back];
            self.navigationItem.leftBarButtonItems=@[back_item];
            
        }
            break;
            
        case 3:
        {
            
        }
            break;
            
            
        default:
            break;
    }
    
    
}


#pragma mark-UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    return _dataArray.count;
    return 4;
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
    
    cell.textLabel.text = [_dataArray objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSString *select = [_dataArray objectAtIndex:indexPath.row];
    //    self.selectLabel.text = select;
    //    [self clickToBack:nil];
}


@end
