//
//  GuserZyViewController.m
//  FBAuto
//
//  Created by gaomeng on 14-7-29.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "GuserZyViewController.h"

#import "FBChatViewController.h"
#import "GyhzyTableViewCell.h"

#import "GuserModel.h"


#import "CarSourceClass.h"//车源modle


#import "FBDetail2Controller.h"

#import "FBCityData.h"

#import "DXAlertView.h"

@interface GuserZyViewController ()

@end

@implementation GuserZyViewController



- (void)dealloc
{
    
    
    NSLog(@"%s",__FUNCTION__);
}



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
    // Do any additional setup after loading the view from its nib.
    
    self.titleLabel.text = self.title;
    
    NSLog(@"%s",__FUNCTION__);
    
    _tableView = [[RefreshTableView alloc]initWithFrame:CGRectMake(0, 0, 320, 568-64-75)];
    _tableView.refreshDelegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    
    UIButton *rightButton2 =[[UIButton alloc]initWithFrame:CGRectMake(0,8,30,21.5)];
    [rightButton2 addTarget:self action:@selector(clickToAdd:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton2 setImage:[UIImage imageNamed:@"tianjia44_44"] forState:UIControlStateNormal];
    UIBarButtonItem *save_item2=[[UIBarButtonItem alloc]initWithCustomView:rightButton2];
    self.navigationItem.rightBarButtonItems = @[save_item2];
    
    _page = 1;
    [self prepareUeserInfo];//获取用户信息
    [self prepareUserCar];//获取用户车源信息
    
    [_tableView showRefreshHeader:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clickToAdd:(id)sender
{
    [self addFriend:self.userId];
}

#pragma mark - 请求网络数据
//获取用户信息
-(void)prepareUeserInfo{
    NSString *api = [NSString stringWithFormat:FBAUTO_GET_USER_INFORMATION,self.userId];
    
    NSLog(@"获取用户信息 api === %@",api);
    
    LCWTools *tool = [[LCWTools alloc]initWithUrl:api isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        NSDictionary *dataInfo = [result objectForKey:@"datainfo"];

        NSLog(@"%@",dataInfo);

        GuserModel *guserModel = [[GuserModel alloc]initWithDic:dataInfo];
        self.guserModel = guserModel;

        //商家信息
        self.nameLabel.text = guserModel.name;
        self.saleTypeBtn.titleLabel.text = guserModel.usertype;//商家类型
        if ([guserModel.usertype intValue] == 1) {
            self.saleTypeBtn.titleLabel.text = @"个人";
        }else if ([guserModel.usertype intValue] == 2){
            self.saleTypeBtn.titleLabel.text = @"商家";
        }
        self.phoneNumLabel.text = guserModel.phone;

        NSString *sheng = [FBCityData cityNameForId:[guserModel.province intValue]];
        NSString *shi = [FBCityData cityNameForId:[guserModel.city intValue]];

        self.addressLabel.text = [NSString stringWithFormat:@"%@%@",sheng,shi];
        [self.headImage sd_setImageWithURL:[NSURL URLWithString:guserModel.headimage] placeholderImage:[UIImage imageNamed:@"detail_test"]];
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        NSString *str = [failDic objectForKey:ERROR_INFO];
        UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [al show];
    }];
    
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}




//获取用户车源信息
-(void)prepareUserCar{
    //获取用户车源信息
    NSString *api = [NSString stringWithFormat:FBAUTO_CARSOURCE_MYSELF,self.userId,_page,10];
    
    NSLog(@"用户车源信息接口:%@",api);
    __weak typeof (self)weakSelf = self;
    
    LCWTools *tool = [[LCWTools alloc]initWithUrl:api isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"用户车源列表erro%@",[result objectForKey:@"errinfo"]);
        
        NSDictionary *dataInfo = [result objectForKey:@"datainfo"];
        int total = [[dataInfo objectForKey:@"total"]intValue];
        
        if (_page < total) {
            
            _tableView.isHaveMoreData = YES;
        }else
        {
            _tableView.isHaveMoreData = NO;
        }
        
        NSArray *data = [dataInfo objectForKey:@"data"];
        
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:data.count];
        
        for (NSDictionary *aDic in data) {
            
            CarSourceClass *aCar = [[CarSourceClass alloc]initWithDictionary:aDic];
            
            [arr addObject:aCar];
        }
        
        [weakSelf reloadData:arr isReload:_tableView.isReloadData];
        
    }failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        NSLog(@"failDic %@",failDic);
        
        [LCWTools showMBProgressWithText:[failDic objectForKey:ERROR_INFO] addToView:self.view];
        
        if (_tableView.isReloadData) {
            
            _page --;
            
            [_tableView performSelector:@selector(finishReloadigData) withObject:nil afterDelay:1.0];
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
    
    LCWTools *tools = [[LCWTools alloc]initWithUrl:[NSString stringWithFormat:FBAUTO_FRIEND_ADD,[GMAPI getAuthkey],friendId]isPost:NO postData:nil];
    
    [tools requestCompletion:^(NSDictionary *result, NSError *erro) {
        NSLog(@"result %@ erro %@",result,[result objectForKey:@"errinfo"]);
        
        if ([result isKindOfClass:[NSDictionary class]]) {
            
            //            int erroCode = [[result objectForKey:@"errcode"]intValue];
            NSString *erroInfo = [result objectForKey:@"errinfo"];
            
            DXAlertView *alert = [[DXAlertView alloc]initWithTitle:erroInfo contentText:nil leftButtonTitle:nil rightButtonTitle:@"确定" isInput:NO];
            [alert show];
            
            alert.leftBlock = ^(){
                NSLog(@"确定");
            };
            alert.rightBlock = ^(){
                NSLog(@"取消");
                
            };
            
        }
    }failBlock:^(NSDictionary *failDic, NSError *erro) {
        NSLog(@"failDic %@",failDic);
        //        [LCWTools showMBProgressWithText:[failDic objectForKey:ERROR_INFO] addToView:self.view];
        
        DXAlertView *alert = [[DXAlertView alloc]initWithTitle:[failDic objectForKey:ERROR_INFO] contentText:nil leftButtonTitle:nil rightButtonTitle:@"确定" isInput:NO];
        [alert show];
        
        alert.leftBlock = ^(){
            NSLog(@"确定");
        };
        alert.rightBlock = ^(){
            NSLog(@"取消");
            
        };
    }];
}



#pragma mark - UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"identifer";
    GyhzyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[GyhzyTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    [cell loadViewWithIndexPath:indexPath model:self.guserModel];
    [cell configWithUserModel:self.guserModel];
    if (indexPath.row>3) {
        [cell configWithCarModel:_dataArray[indexPath.row-4] userModel:self.guserModel];
    }
    
    
    if (indexPath.row == _dataArray.count+3) {
        UIView *fenView = [[UIView alloc]initWithFrame:CGRectMake(0, 84, 320, 0.5)];
        fenView.backgroundColor = RGBCOLOR(214, 214, 214);
        [cell.contentView addSubview:fenView];
    }
    
    cell.separatorInset = UIEdgeInsetsZero;
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger num = 0;
    num = _dataArray.count +4;
    
    NSLog(@"%d",num);
    return num;
    
}





/**
 *  刷新数据列表
 *
 *  @param dataArr  新请求的数据
 *  @param isReload 判断在刷新或者加载更多
 */
- (void)reloadData:(NSArray *)dataArr isReload:(BOOL)isReload
{
    if (isReload) {
        
        _dataArray = dataArr;
        
    }else
    {
        NSMutableArray *newArr = [NSMutableArray arrayWithArray:_dataArray];
        [newArr addObjectsFromArray:dataArr];
        _dataArray = newArr;
    }
    
    [_tableView performSelector:@selector(finishReloadigData) withObject:nil afterDelay:1.0];
}




#pragma - mark RefreshDelegate <NSObject>

- (void)loadNewData
{
    _page = 1;
    
    [self prepareUserCar];
}

- (void)loadMoreData
{
    NSLog(@"loadMoreData");
    
    _page ++;
    
    [self prepareUserCar];
}

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%d",indexPath.row);
    
    FBDetail2Controller *fbdetailvc = [[FBDetail2Controller alloc]init];
    
    if (indexPath.row>3) {
        CarSourceClass *car = _dataArray[indexPath.row-4];
        fbdetailvc.infoId = car.id;
        fbdetailvc.isHiddenUeserInfo = YES;
        
        [self.navigationController pushViewController:fbdetailvc animated:YES];
    }
    
    
    
    
    
}

- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    
    if (_tmpCell) {
        height = [_tmpCell loadViewWithIndexPath:indexPath model:self.guserModel];
    }else{
        _tmpCell = [[GyhzyTableViewCell alloc]init];
        height = [_tmpCell loadViewWithIndexPath:indexPath model:self.guserModel];
    }
    
    return height;
}






#pragma mark - 最下面的view的点击事件
- (IBAction)clickToDial:(UIButton *)sender {
    NSString *num = [[NSString alloc] initWithFormat:@"tel://%@",self.phoneNumLabel.text];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]];
}

- (IBAction)clickToChat:(UIButton *)sender {
    if ([self.phoneNumLabel.text isEqualToString:[[NSUserDefaults standardUserDefaults]stringForKey:XMPP_USERID]]) {
        
        [LCWTools alertText:@"本人发布信息"];
        return;
    }
    
    FBChatViewController *chat = [[FBChatViewController alloc]init];
    chat.chatWithUser = self.phoneNumLabel.text;
    chat.chatWithUserName = self.nameLabel.text;
    chat.chatUserId = _userId;
    [self.navigationController pushViewController:chat animated:YES];
    
}

- (IBAction)clickToPersonal:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}




- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}




@end
