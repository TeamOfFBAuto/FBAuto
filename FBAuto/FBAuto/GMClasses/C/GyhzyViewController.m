//
//  GyhzyViewController.m
//  FBAuto
//
//  Created by gaomeng on 14-7-11.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "GyhzyViewController.h"
#import "GyhzyTableViewCell.h"

#import "GuserModel.h"

@interface GyhzyViewController ()

@end

@implementation GyhzyViewController

- (void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleLabel.text = self.title;
    
    NSLog(@"%s",__FUNCTION__);
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 569-64-44) style:UITableViewStylePlain];
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
    return 10;
    
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





@end
