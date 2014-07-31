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

@interface GuserZyViewController ()

@end

@implementation GuserZyViewController

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

#pragma mark - 请求网络数据
//获取用户信息
-(void)prepareUeserInfo{
    NSString *api = [NSString stringWithFormat:FBAUTO_GET_USER_INFORMATION,self.userId];
    NSLog(@"获取用户信息 api === %@",api);
    NSURL *url = [NSURL URLWithString:api];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSDictionary *dataInfo = [dic objectForKey:@"datainfo"];
        
        NSLog(@"%@",dic);
        
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
        self.addressLabel.text = [NSString stringWithFormat:@"%@%@",guserModel.province,guserModel.city];
        [self.headImage sd_setImageWithURL:[NSURL URLWithString:guserModel.headimage] placeholderImage:[UIImage imageNamed:@"detail_test"]];
        
        
        NSLog(@"%@",self.phoneNumLabel.text);
        NSLog(@"%@",self.nameLabel.text);
        NSLog(@"%@",self.addressLabel.text);
        NSLog(@"%@",self.saleTypeBtn);
        
        
        
        [_tableView reloadData];
        
    }];
    
}

//获取用户车源信息
-(void)prepareUserCar{
    //获取用户车源信息
    NSString *api = [NSString stringWithFormat:FBAUTO_CARSOURCE_MYSELF,self.userId,_page,10];
    
    NSLog(@"用户车源信息接口:%@",api);
    
//    NSURL *url = [NSURL URLWithString:api];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//        
//        if (data.length == 0) {
//            return ;
//        }
//        
//        NSLog(@"%@",dic);
//        
//        NSDictionary *dataInfoDic = [dic objectForKey:@"datainfo"];
//        NSArray *carSourceArray = [dataInfoDic objectForKey:@"data"];
//        
//        NSMutableArray *marray = [NSMutableArray arrayWithCapacity:1];
//        
//        
//        for (NSDictionary *dic in carSourceArray) {
//            CarSourceClass *car = [[CarSourceClass alloc]initWithDictionary:dic];
//            [marray addObject:car];
//        }
//        
//        _dataArray = marray;
//        
//        [_tableView reloadData];
//        
//        
//    }];
    
    
    
    
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

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
