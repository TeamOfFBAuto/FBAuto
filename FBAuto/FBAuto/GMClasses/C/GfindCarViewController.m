//
//  GfindCarViewController.m
//  FBAuto
//
//  Created by gaomeng on 14-7-8.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "GfindCarViewController.h"
#import "GfindCarTableViewCell.h"
#import "FBFindCarDetailController.h"
#import "FBDetail2Controller.h"
#import "CarSourceClass.h"
#import "GmLoadData.h"

#import "DXAlertView.h"

@interface GfindCarViewController ()<RefreshDelegate>
{
    int _page;//第几页
    NSArray *_dataArray;
}

@end

@implementation GfindCarViewController

- (void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"%s",__FUNCTION__);
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.flagHeight = 60;
    
    _tableView = [[RefreshTableView alloc]initWithFrame:CGRectMake(0, 0, 320, 568-64-44)];
    _tableView.refreshDelegate = self;
    _tableView.dataSource = self;
    
    _tableView.separatorColor = [UIColor whiteColor];
    
    [self.view addSubview:_tableView];
    
    
    if (self.gtype == 2) {//我的车源
        
        self.titleLabel.text = @"我的车源";
        
    }else if (self.gtype == 3){//我的寻车
        
        self.titleLabel.text = @"我的寻车";
    }
    
    [self prepareDataForType:self.gtype];
}

#pragma mark - 请求网络数据
//我的车源
-(void)prepareDataForType:(int)aType{
    //获取我的车源列表
    //http://fbautoapp.fblife.com/index.php?c=interface&a=getmycheyuan&authkey=VWMHKVFzUWYBdAAuAWdRJgdz
    
    __weak typeof(GfindCarViewController *)weakSelf = self;
    NSString *api = @"";
    
    if (aType == 2) {
        api = [NSString stringWithFormat:FBAUTO_CARSOURCE_MYSELF,[GMAPI getAuthkey]];
    }else if (aType == 3)
    {
        api = [NSString stringWithFormat:FBAUTO_FINCAR_MYSELF,[GMAPI getAuthkey]];
    }
    
    NSString *url = [NSString stringWithFormat:@"%@&page=%d&ps=%d",api,_page,KPageSize];
    LCWTools *tool = [[LCWTools alloc]initWithUrl:url isPost:nil postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"寻车列表erro%@",[result objectForKey:@"errinfo"]);
        
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

//我的寻车
-(void)prepareXunche{
    
}

- (void)clickToDetail:(NSString *)info car:(NSString *)car
{
    
    
    if (self.gtype == 2) {//我的车源
        
        FBDetail2Controller *detail = [[FBDetail2Controller alloc]init];
        detail.style = Navigation_Special;
        detail.navigationTitle = @"详情";
        detail.infoId = info;
        detail.carId = car;
        detail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detail animated:YES];
        
    }else if (self.gtype == 3){//我的寻车
        
        FBFindCarDetailController *detail = [[FBFindCarDetailController alloc]init];
        detail.style = Navigation_Special;
        detail.navigationTitle = @"详情";
        detail.infoId = info;
        detail.carId = car;
        detail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detail animated:YES];
    }
    
}

#pragma - mark RefreshDelegate <NSObject>

- (void)loadNewData
{
    _page = 1;
    
    [self prepareDataForType:self.gtype];
}

- (void)loadMoreData
{
    NSLog(@"loadMoreData");
    
    _page ++;
    
    [self prepareDataForType:self.gtype];
}

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CarSourceClass *aCar = (CarSourceClass *)[_dataArray objectAtIndex:indexPath.row];
    
    [self clickToDetail:aCar.id car:aCar.car];
}
- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    if (_tmpCell) {
        height = [_tmpCell loadView:indexPath];
    }else{
        _tmpCell = [[GfindCarTableViewCell alloc]init];
        _tmpCell.delegate = self;
        height = [_tmpCell loadView:indexPath];
    }
    
    
    NSLog(@"%f",height);
    
    return height;
}


#pragma mark - UITableiViewDelegate && UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%s",__FUNCTION__);
    static NSString *identifier = @"identifier";
    GfindCarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[GfindCarTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.delegate = self;
        
    }
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    [cell loadView:indexPath];
    
    __weak typeof (self)bself = self;
    __weak typeof (_tableView)btableview = _tableView;
    
    //设置上下箭头的点击
    [cell setAddviewBlock:^{
        
        //flag不为空的时候赋值给last
        if (bself.flagIndexPath) {
            
            bself.lastIndexPath = bself.flagIndexPath;
        }
        //当前点击的indexPath赋值给flag
        bself.flagIndexPath = indexPath;
        
        //把flag加到数组里
        NSArray *indexPathArray = @[bself.flagIndexPath];

        //如果last有值 并且和flag不同 就加到数组里
        if (bself.lastIndexPath && (bself.lastIndexPath.row!=bself.flagIndexPath.row || bself.lastIndexPath.section != bself.flagIndexPath.section)) {
            indexPathArray = @[bself.lastIndexPath,bself.flagIndexPath];
        }
        
        self.indexPathArray = indexPathArray;
        
        NSLog(@"%ld  %ld",(long)bself.lastIndexPath.row,(long)bself.flagIndexPath.row);
        

        
        //单元格高度标示
        if (indexPathArray.count == 2) {//有last 有flag
            bself.flagHeight = 120;
        }else if (indexPathArray.count == 1){//last和flag为同一个
            if (bself.flagHeight == 120) {
                bself.flagHeight = 60;
                
            }else if (bself.flagHeight == 60){
                bself.flagHeight = 120;
                
            }
        }
        
        [btableview reloadRowsAtIndexPaths:self.indexPathArray withRowAnimation:UITableViewRowAnimationFade];
        
    }];
    
    [cell setCaozuoBtnBlock:^(NSInteger btnTag) {
        switch (btnTag) {
            case 10://删除
            {
                DXAlertView *al = [[DXAlertView alloc]initWithTitle:@"您确定删除此条消息吗？" contentText:nil leftButtonTitle:@"取消" rightButtonTitle:@"确定"];
                [al show];
                al.leftBlock = ^(){
                    NSLog(@"取消");
                };
                al.rightBlock = ^(){
                    NSLog(@"确定");
                };
            }
                
                break;
            case 11://修改
                
                
                
                break;
            case 12://刷新
                
                break;
            case 13://分享
                
                break;
            default:
                break;
        }
    }];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.separatorInset = UIEdgeInsetsZero;
    
    if (indexPath.row < _dataArray.count) {
        CarSourceClass *aCar = [_dataArray objectAtIndex:indexPath.row];
        
//        @property(nonatomic,retain)UILabel *ciLable;
//        @property(nonatomic,retain)UILabel *cLabel;
//        @property(nonatomic,retain)UILabel *tLabel;
        
        cell.cLabel.text = aCar.car_name;
        cell.tLabel.text = [LCWTools timechange3:aCar.dateline];
    }
    
    return cell;
}

#pragma mark - UIAlerViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"%ld",buttonIndex);
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
