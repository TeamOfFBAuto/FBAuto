//
//  FBMayKnowFriendsController.m
//  FBAuto
//
//  Created by lichaowei on 14-7-4.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "FBMayKnowFriendsController.h"
#import "FBFriend2Cell.h"
#import "FBFriendModel.h"
#import "ASIFormDataRequest.h"

@interface FBMayKnowFriendsController ()

@end

@implementation FBMayKnowFriendsController

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
//    self.titleLabel.text = @"可能认识的人";
    
    self.titleLabel.text = self.navigationTitle;
    
    self.table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.height - 44 - (iPhone5 ? 20 : 0)) style:UITableViewStylePlain];
    _table.delegate = self;
    _table.dataSource = self;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
//    _table.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view addSubview:_table];
    
    
    if (self.isAreaFriend) { //地区查询
        
        [self getFriendlistWithAreaId:self.cityId provinceId:self.provinceId];
        
    }else   //从通讯录获取可能认识的人
    {
        [self getMayknowFormAddressBook];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - mark 网络请求

- (void)getMayknowFormAddressBook
{
    NSMutableArray *AddressbookArr   = [SzkAPI AccesstoAddressBookAndGetDetail];
    
    NSMutableArray *nameArr = [NSMutableArray arrayWithCapacity:AddressbookArr.count];
    NSMutableArray *phoneArr = [NSMutableArray arrayWithCapacity:AddressbookArr.count];
    
    for (id aDic in AddressbookArr) {
        
        NSString *fistName = [aDic objectForKey:@"tmpFirstName"];
        NSString *name = [aDic objectForKey:@"tmpLastName"];
        NSString *phone = [aDic objectForKey:@"tmpPhoneIndex0"];
        if (![fistName isEqualToString:@"noresault"]) {
            name = [NSString stringWithFormat:@"%@%@",fistName,name];
        }
        
        if (name && phone && [LCWTools isValidateMobile:phone]) {
            
            [nameArr addObject:name];
            [phoneArr addObject:phone];
        }
        
    }
    
    [self getMayknowFriendlistNameArr:nameArr phoneArr:phoneArr];
}

/**
 *  从通讯录获取信息,匹配好友
 *
 *  @param nameArr  姓名arr
 *  @param phoneArr 电话arr
 */
- (void)getMayknowFriendlistNameArr:(NSArray *)nameArr phoneArr:(NSArray *)phoneArr
{
    
    __block typeof (FBMayKnowFriendsController *)weakSelf = self;
    
    NSString *phoneString = [phoneArr componentsJoinedByString:@","];
    NSString *nameString = [nameArr componentsJoinedByString:@","];
    
    NSString *urlString = [NSString stringWithFormat:@"http://fbautoapp.fblife.com/index.php?c=interface&a=getphonemember&authkey=%@",[GMAPI getAuthkey]];
    NSString *post = [NSString stringWithFormat:@"phone=%@&rname=%@",phoneString,nameString];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    LCWTools *tools = [[LCWTools alloc]initWithUrl:urlString isPost:YES postData:postData];
    
    [tools requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"result %@ erro %@",result,[result objectForKey:@"errinfo"]);
        
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
                [dataArr addObject:aFriend];
            }
            
            [weakSelf reloadData:dataArr];
        }
        
    }];
    
}



/**
 *  通过地区获取好友
 *
 *  @param cityId     城市id,可为空
 *  @param provinceId 省份id,不为空
 */

- (void)getFriendlistWithAreaId:(NSString *)cityId provinceId:(NSString *)provinceId
{
    NSLog(@"provinceId %@",provinceId);
    
    __block typeof (FBMayKnowFriendsController *)weakSelf = self;
    
    
    LCWTools *tools = [[LCWTools alloc]initWithUrl:[NSString stringWithFormat:FBAUTO_FRIEND_AREA,[GMAPI getAuthkey],provinceId,cityId]isPost:NO postData:nil];
    
    [tools requestCompletion:^(NSDictionary *result, NSError *erro) {
        NSLog(@"result %@ erro %@",result,[result objectForKey:@"errinfo"]);
        
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
                [dataArr addObject:aFriend];
            }
            
            [weakSelf reloadData:dataArr];
        }
    }];
}

/**
 *  添加好友
 *
 *  @param friendId userId
 */
- (void)addFriend:(NSString *)friendId
{
    NSLog(@"provinceId %@",friendId);
    
//    __block typeof (FBMayKnowFriendsController *)weakSelf = self;
    
    
    LCWTools *tools = [[LCWTools alloc]initWithUrl:[NSString stringWithFormat:FBAUTO_FRIEND_ADD,[GMAPI getAuthkey],friendId]isPost:NO postData:nil];
    
    [tools requestCompletion:^(NSDictionary *result, NSError *erro) {
        NSLog(@"result %@ erro %@",result,[result objectForKey:@"errinfo"]);
        
        if ([result isKindOfClass:[NSDictionary class]]) {
            
            int erroCode = [[result objectForKey:@"errcode"]intValue];
            NSString *erroInfo = [result objectForKey:@"errinfo"];
            
            if (erroCode != 0) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:erroInfo delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                
                return ;
            }
        }
    }];
}


- (void)reloadData:(NSArray *)arr
{
    self.dataArray = arr;
    
    [self.table reloadData];
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
    FBFriendModel *aModel = [_dataArray objectAtIndex:indexPath.row];
    
    NSString *message = [NSString stringWithFormat:@"是否添加%@为好友",aModel.buddyname];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"添加好友", nil];
    alert.tag = [aModel.uid intValue] + 100;
    
    [alert show];
}

#pragma - mark UIAlertViewDelegate <NSObject>

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self addFriend:[NSString stringWithFormat:@"%ld",alertView.tag - 100]];
    }
}

@end
