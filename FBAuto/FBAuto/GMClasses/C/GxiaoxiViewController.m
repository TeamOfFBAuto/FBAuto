//
//  GxiaoxiViewController.m
//  FBAuto
//
//  Created by gaomeng on 14-7-24.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "GxiaoxiViewController.h"

#import "GxiaoxiTableViewCell.h"

#import "FBCityData.h"

#import "XMPPMessageModel.h"

@interface GxiaoxiViewController ()
{
    
    NSArray *_dataArray;//数据源
    
}
@end

@implementation GxiaoxiViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.titleLabel.text = @"我的消息";
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 568-64) style:UITableViewStylePlain];
//    _tableView.refreshDelegate = self;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];
    
    
    [self queryHistoryMessage];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - mark 消息历史最新一条

//获取数据 : 来自本地数据库
- (void)queryHistoryMessage
{
    NSUserDefaults *defalts = [NSUserDefaults standardUserDefaults];
    NSString *userName = [defalts objectForKey:XMPP_USERID];
    
    NSArray *arr = [FBCityData queryAllNewestMessageForUser:userName];
    
    NSLog(@"queryAllNewestMessageForUser %@ %d",arr,arr.count);
    
    _dataArray = arr;
    
    [_tableView reloadData];
}

#pragma mark - UITableViewDelegate && UITableViewDatasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
//    return 20;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"identifier";
    
    GxiaoxiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[GxiaoxiTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    XMPPMessageModel *aModel = [_dataArray objectAtIndex:indexPath.row];
    
    [cell configWithData:aModel];
    
    
    cell.textLabel.text = aModel.newestMessage;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65.f;
}





- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
//    if (_tmpCell) {
//        height = [_tmpCell loadViewWithIndexPath:indexPath];
//    }else{
//        _tmpCell = [[GxiaoxiTableViewCell alloc]init];
//        _tmpCell.delegate = self;
//        height = [_tmpCell loadViewWithIndexPath:indexPath];
//    }
    
    height = 65;
    return height;
    
}



- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    CarSourceClass *aCar = (CarSourceClass *)[_dataArray objectAtIndex:indexPath.row];
    //
    //    [self clickToDetail:aCar.id car:aCar];
}


//- (void)clickToDetail:(NSString *)info car:(CarSourceClass *)aCar
//{
//    NSLog(@"%@",aCar.stype_name);
//    if ([aCar.stype_name isEqualToString:@"车源"]) {
//        FBDetail2Controller *detail = [[FBDetail2Controller alloc]init];
//        detail.style = Navigation_Special;
//        detail.navigationTitle = @"详情";
//        detail.infoId = info;
//        detail.carId = aCar.car;
//        detail.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:detail animated:YES];
//    }else if ([aCar.stype_name isEqualToString:@"寻车"]){
//        FBFindCarDetailController *detail = [[FBFindCarDetailController alloc]init];
//        detail.style = Navigation_Special;
//        detail.navigationTitle = @"详情";
//        detail.infoId = info;
//        detail.carId = aCar.car;
//        detail.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:detail animated:YES];
//    }
//}


/**
 *  刷新数据列表
 *
 *  @param dataArr  新请求的数据
 *  @param isReload 判断在刷新或者加载更多
 */
- (void)reloadData:(NSArray *)dataArr isReload:(BOOL)isReload
{
    if (isReload) {
        
        _dataArray = [NSMutableArray arrayWithArray:dataArr];
        
    }else
    {
        NSMutableArray *newArr = [NSMutableArray arrayWithArray:_dataArray];
        [newArr addObjectsFromArray:dataArr];
        _dataArray = newArr;
    }
    
    [_tableView performSelector:@selector(finishReloadigData) withObject:nil afterDelay:1.0];
}


@end
