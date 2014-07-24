//
//  GxiaoxiViewController.m
//  FBAuto
//
//  Created by gaomeng on 14-7-24.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "GxiaoxiViewController.h"

#import "GxiaoxiTableViewCell.h"

@interface GxiaoxiViewController ()<RefreshDelegate>
{
    int _page;//第几页
    NSMutableArray *_dataArray;//数据源
    
}
@end

@implementation GxiaoxiViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _tableView = [[RefreshTableView alloc]initWithFrame:CGRectMake(0, 0, 320, 568-64)];
    _tableView.refreshDelegate = self;
    _tableView.dataSource = self;
    _tableView.separatorColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];
    
    
    //网路请求页码标示
    _page =1;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDelegate && UITableViewDatasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return _dataArray.count;
    return 20;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"identifier";
    GxiaoxiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[GxiaoxiTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}


#pragma mark - 请求网络数据
-(void)prepareNetData{
    
}



#pragma - mark RefreshDelegate <NSObject>

- (void)loadNewData
{
    _page = 1;
    
    [self prepareNetData];
}

- (void)loadMoreData
{
    NSLog(@"loadMoreData");
    
    _page ++;
    
    [self prepareNetData];
}


- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    if (_tmpCell) {
        height = [_tmpCell loadViewWithIndexPath:indexPath];
    }else{
        _tmpCell = [[GxiaoxiTableViewCell alloc]init];
        _tmpCell.delegate = self;
        height = [_tmpCell loadViewWithIndexPath:indexPath];
    }
    
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
