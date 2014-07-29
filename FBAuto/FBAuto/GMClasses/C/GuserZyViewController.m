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
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 568-64-75) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    _page = 1;
    [self prepareUeserInfo];//获取用户信息
    [self prepareUserCar];//获取用户车源信息
    
    
    
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
    
    NSURL *url = [NSURL URLWithString:api];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        
        NSDictionary *dataInfoDic = [dic objectForKey:@"datainfo"];
        NSArray *carSourceArray = [dataInfoDic objectForKey:@"data"];
        
        _dataArray = carSourceArray;
        
        [_tableView reloadData];
        
        
    }];
}


#pragma mark - UITableViewDataSource && UITableViewDelegate

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
    
    cell.separatorInset = UIEdgeInsetsZero;
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger num = 0;
    num = _dataArray.count +4;
    
    NSLog(@"%d",num);
    return num;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
    
    [self.navigationController pushViewController:chat animated:YES];
    
}

- (IBAction)clickToPersonal:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
