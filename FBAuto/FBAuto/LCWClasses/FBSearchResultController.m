//
//  FBSearchResultController.m
//  FBAuto
//
//  Created by lichaowei on 14-7-19.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "FBSearchResultController.h"

#import "FBDetail2Controller.h"
#import "CarSourceClass.h"
#import "CarSourceCell.h"
#define KPageSize  10 //每页条数

@interface FBSearchResultController ()<RefreshDelegate>
{
    RefreshTableView *_table;
    int _searchPage;
    NSArray *_dataArray;
    SearchContentStyle aSearchStyle;
}

@end

@implementation FBSearchResultController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithStyle:(SearchContentStyle)searchStyle
{
    self = [super init];
    if (self) {
        aSearchStyle = searchStyle;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //数据展示table
    
    self.titleLabel.text = @"搜索结果";
    
    _table = [[RefreshTableView alloc]initWithFrame:CGRectMake(0,0, 320, self.view.height - (iPhone5 ? 20 : 0) - 44)];
    
    _table.refreshDelegate = self;
    _table.dataSource = self;
    
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_table];
    
    if (aSearchStyle == Search_carSource) {
        NSLog(@"车源");
    }else if (aSearchStyle == search_findCar){
        NSLog(@"寻车"); 
    }
    
    [_table showRefreshHeader:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - mark 搜索车源数据

- (void)searchCarSourceWithKeyword:(NSString *)keyword page:(int)page
{
    _searchPage = page;
    
    NSString *url = [NSString stringWithFormat:FBAUTO_CARSOURCE_SEARCH,keyword,_searchPage,KPageSize];
    
    NSLog(@"搜索车源列表 %@",url);
    
    __weak typeof(FBSearchResultController *)weakSelf = self;
    
    LCWTools *tool = [[LCWTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"搜索车源列表 result %@, erro%@",result,[result objectForKey:@"errinfo"]);
        
        NSDictionary *dataInfo = [result objectForKey:@"datainfo"];
        int total = [[dataInfo objectForKey:@"total"]intValue];
        
        if (_searchPage < total) {
            
            _table.isHaveMoreData = YES;
        }else
        {
            _table.isHaveMoreData = NO;
        }
        
        
        NSArray *data = [dataInfo objectForKey:@"data"];
        
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:data.count];
        
        for (NSDictionary *aDic in data) {
            
            CarSourceClass *aCar = [[CarSourceClass alloc]initWithDictionary:aDic];
            
            [arr addObject:aCar];
        }
        
        [weakSelf reloadData:arr isReload:_table.isReloadData];
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        NSLog(@"failDic %@",failDic);
        
        if (_table.isReloadData) {
            
            _searchPage --;
            
            [_table performSelector:@selector(finishReloadigData) withObject:nil afterDelay:1.0];
        }else
        {
            [LCWTools showMBProgressWithText:[failDic objectForKey:ERROR_INFO] addToView:self.view];
        }
    }];
    
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
    
    [_table performSelector:@selector(finishReloadigData) withObject:nil afterDelay:1.0];
}

- (void)clickToDetail:(NSString *)carId
{
    FBDetail2Controller *detail = [[FBDetail2Controller alloc]init];
    detail.style = Navigation_Special;
    detail.navigationTitle = @"详情";
    detail.carId = carId;
    detail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];
    
}


#pragma - mark RefreshDelegate <NSObject>

- (void)loadNewData
{
    NSLog(@"loadNewData");
        
    [self searchCarSourceWithKeyword:self.searchKeyword page:1];
        
}

- (void)loadMoreData
{
    NSLog(@"loadMoreData");
        
    _searchPage ++;
    [self searchCarSourceWithKeyword:self.searchKeyword page:_searchPage];
        
}

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CarSourceClass *aCar = (CarSourceClass *)[_dataArray objectAtIndex:indexPath.row];
    
    [self clickToDetail:aCar.id];
}

- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"CarSourceCell";
    
    CarSourceCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"CarSourceCell" owner:self options:nil]objectAtIndex:0];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row % 2 == 0) {
        cell.contentView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    }else
    {
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    
    if (indexPath.row < _dataArray.count) {
        CarSourceClass *aCar = [_dataArray objectAtIndex:indexPath.row];
        [cell setCellDataWithModel:aCar];
    }
    
    return cell;
    
}


@end
