//
//  GmarkViewController.m
//  FBAuto
//
//  Created by gaomeng on 14-7-9.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "GmarkViewController.h"
#import "GmarkTableViewCell.h"
#import "LoadingIndicatorView.h"//上提加载更多

@interface GmarkViewController ()

@end

@implementation GmarkViewController

- (void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
}

-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
    [_dview removeFromSuperview];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor=[UIColor redColor];
    NSLog(@"%s",__FUNCTION__);
    
    self.titleLabel.text = @"我的收藏";
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"lajitong44_44.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(ggDel)];
    
    self.navigationItem.rightBarButtonItem = right;
    
    self.delClicked = NO;
    
    _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 568-64) style:UITableViewStylePlain];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.separatorColor = [UIColor whiteColor];
    [self.view addSubview:_tableview];
    
    //底部删除view
    _dview = [[UIView alloc]initWithFrame:CGRectMake(0, 568, 320, 80)];
    _dview.backgroundColor = [UIColor whiteColor];
    _dview.userInteractionEnabled = YES;
    
    //红色view
    UIView *redView = [[UIView alloc]initWithFrame:CGRectMake(65, 35, 190, 29)];
    redView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doTap1)];
    [redView addGestureRecognizer:tap];
    redView.backgroundColor = [UIColor redColor];
    redView.layer.cornerRadius = 4;
    [_dview addSubview:redView];
    
    //确定删除Label
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(54, 7, 50, 14)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.text = @"确定删除";
    [redView addSubview:titleLabel];
    
    //删除状态下的计数Label
    self.numLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame)+5, titleLabel.frame.origin.y-1, 45, titleLabel.frame.size.height)];
    self.numLabel.font = [UIFont systemFontOfSize:12];
    self.numLabel.text = @"(  )";
    self.numLabel.textColor = [UIColor whiteColor];
    [redView addSubview:self.numLabel];
    
    
    //默认为正常状态
    self.delType = 2;
    
    
    //非配内存
    self.indexes = [NSMutableArray arrayWithCapacity:1];
    self.netDataArray = [NSMutableArray arrayWithCapacity:1];
    
    
    
    //添加到window上
//    [[[UIApplication sharedApplication]keyWindow] addSubview:_dview];
    
    [self.view addSubview:_dview];
    
    
    
    
    //下拉刷新
    
    _refreshHeaderView = [[EGORefreshTableHeaderView alloc]initWithFrame:CGRectMake(0, 0-_tableview.bounds.size.height, 320, _tableview.bounds.size.height)];
    _refreshHeaderView.delegate = self;
    [_tableview addSubview:_refreshHeaderView];
    _currentPage = 1;
    _isupMore = NO;//是否为上提加载
    _isUpMoreSuccess = NO;//上提加载是否成功
    
    
    
    //上提加载更多
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    _upMoreView = [[LoadingIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    _upMoreView.type = 1;
    _upMoreView.hidden = YES;
    [view addSubview:_upMoreView];
    
    _tableview.tableFooterView = view;
    
    

    
    [self prepareNetData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - 请求网络数据
-(void)prepareNetData{
    NSString *api = [NSString stringWithFormat:FBAUTO_CARSOURCE_MYSELF,[GMAPI getAuthkey],_currentPage,10];
    NSLog(@"我的收藏请求的接口：%@",api);
    NSURL *url = [NSURL URLWithString:api];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            NSDictionary *datainfo = [dic objectForKey:@"datainfo"];
            self.netDataArray = [datainfo objectForKey:@"data"];
            //判断有没有更多
            if (self.netDataArray.count<10) {
                [_upMoreView stopLoading:3];
            }else{
                [_upMoreView stopLoading:1];
            }
            
            //判断是否为上提加载更多
            if (_isupMore) {//是加载更多的话把请求到的文章加到原来的数组中
                [self.dataSourceArray addObjectsFromArray:(NSArray *)self.netDataArray];
                
            }else{//不是上提加载更多
                self.dataSourceArray = self.netDataArray;
            }
            
            _isUpMoreSuccess = YES;//上体加载更多的标志位
            
            //有文章再显示上提加载更多
            if (self.netDataArray.count>0) {
                _upMoreView.hidden = NO;
            }else{
                _upMoreView.hidden = YES;
            }
            
            
            [self doneLoadingTableViewData];
            
            
            [_tableview reloadData];
        }
    }];
}



#pragma mark - UITableViewDelegate && UITableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"identifer";
    GmarkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[GmarkTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.delegate = self;
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    [cell loadViewWithIndexPath:indexPath];//加载控件
    [cell configWithNetData:self.netDataArray];//填充数据
    
    //记录indexPath 保存到self.indexs数组里
    __weak typeof (cell)bcell = cell;
    [cell setDelImvClickedBlock:^(NSInteger gtag) {
        NSLog(@"%ld",(long)gtag);
        BOOL isHave = NO;
        for (NSIndexPath *ip in self.indexes) {
            if (ip.row == gtag) {
                [self.indexes removeObject:ip];
                [bcell.clickImv setImage:[UIImage imageNamed:@"xuanze_up_44_44.png"]];
                isHave = YES;
                break;
            }
        }
        if (!isHave) {
            [self.indexes addObject:[NSIndexPath indexPathForRow:gtag inSection:0]];
            [bcell.clickImv setImage:[UIImage imageNamed:@"xuanze_down_44_44.png"]];
        }
        
        NSLog(@"indexs %lu",(unsigned long)self.indexes.count);
        self.numLabel.text = [NSString stringWithFormat:@"( %lu )",(unsigned long)self.indexes.count];
        
    }];
    
    
    //遍历self.indexs数组 找到标记的收藏
    for (NSIndexPath *ip in self.indexes) {
        if (ip.row == indexPath.row) {
            [cell.clickImv setImage:[UIImage imageNamed:@"xuanze_down_44_44.png"]];
        }
    }
    
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0;
    if (_tmpCell) {
        height = [_tmpCell loadViewWithIndexPath:indexPath];
    }else{
        _tmpCell = [[GmarkTableViewCell alloc]init];
        _tmpCell.delegate = self;
        height = [_tmpCell loadViewWithIndexPath:indexPath];
    }
    return height;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArray.count;
}


#pragma mark - 右上角删除按钮
-(void)ggDel{
    
    self.delClicked = !self.delClicked;
    
    NSLog(@"%d",self.delClicked);
    
    if (self.delClicked) {//删除界面
        self.delType = 3;
        //清空数据
        [self.indexes removeAllObjects];
        self.numLabel.text =  @"(  )";
        [UIView animateWithDuration:0.1 animations:^{
            _dview.frame = CGRectMake(0, 568-80-64, 320, 80);
        } completion:^(BOOL finished) {
            [_tableview reloadData];
        }];
    }else{//正常界面
        self.delType = 2;
        [UIView animateWithDuration:0.1 animations:^{
            _dview.frame = CGRectMake(0, 568, 320, 80);
        } completion:^(BOOL finished) {
            [_tableview reloadData];
        }];
    }
    
}


#pragma mark - 确认删除
-(void)doTap1{
    NSLog(@"%s",__FUNCTION__);
    [self ggDel];
}





#pragma mark -  下拉刷新代理
-(void)reloadTableViewDataSource{
    _reloading = YES;
}

-(void)doneLoadingTableViewData{
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_tableview];
    
}


#pragma mark - EGORefreshTableHeaderDelegate

//-(void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view{
//    _currentPage = 1;
//    _isupMore = NO;
//    [self reloadTableViewDataSource];
//    [self prepareNetData];
//}
//
//-(BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view{
//    return _reloading;
//}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    
    return [NSDate date];
}



//
- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos{
    _currentPage = 1;
    _isupMore = NO;
    [self reloadTableViewDataSource];
    [self prepareNetData];
}
- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view{
    return _reloading;
}



#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    
    if(_tableview.contentOffset.y > (_tableview.contentSize.height - _tableview.frame.size.height+40)&&_isUpMoreSuccess==YES&&[self.netDataArray count]>0)
    {
        [_upMoreView startLoading];
        _isupMore = YES;
        _isUpMoreSuccess = NO;
        if (self.netDataArray) {
            _currentPage++;
        }
        [self prepareNetData];
    }
}


@end
