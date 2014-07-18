//
//  FindCarViewController.m
//  FBAuto
//
//  Created by lcw on 14-6-25.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "FindCarViewController.h"
#import "FBFriendsController.h"
#import "ZkingSearchView.h"

#import "Menu_Advanced.h"
#import "Menu_Normal.h"
#import "Menu_button.h"
#import "Menu_Car.h"

#import "FindCarCell.h"

#define KPageSize  10 //每页条数

#define CAR_LIST @"CAR_LIST" //车源列表
#define CAR_SEARCH @"CAR_SEARCH" //搜索车源

@interface FindCarViewController ()<UITableViewDataSource,UITableViewDelegate,RefreshDelegate>
{
    UIView *navigationView;
    
    RefreshTableView *_table;
    
    Menu_Advanced *menu_Advanced;//高级
    Menu_Normal *menu_Standard;//规格
    Menu_Normal *menu_Source;//来源
    Menu_Normal *menu_Timelimit;//期限
    Menu_Car *menu_Car;//车型选择
    
    ZkingSearchView *zkingSearchV;
    UIView *menuBgView;
    long openIndex;//当前打开的是第几个
    
    //车源列表参数
    NSString *_car;
    int _spot_future;
    int _color_out;
    int _color_in;
    int _carfrom;
    int _usertype;
    int _province;
    int _city;
    int _page;
    
    //搜索参数
    int _searchPage;//搜索页数
    
    BOOL _isSearch;//是否在搜索(只有当点击搜索之后变为YES,此时刷新、加载更多都基于 搜索；只有点击了选项按钮才设为 NO)
    
    NSString *_lastRequest;//判断两次 请求接口是否一致,如果一致需要更新dataArray
    
    NSString *_searchKeyword;//搜索关键词
    
    NSArray *_dataArray;
    
    UIView *maskView;//遮罩
    
    BOOL _needRefreshCarBrand;//是否需要更新车型数据
}

@end

@implementation FindCarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [zkingSearchV removeFromSuperview];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [self.navigationController.navigationBar addSubview:zkingSearchV];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor=RGBCOLOR(22, 233, 30);

    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.titleLabel.text = @"寻车";
    self.button_back.hidden = YES;
    
    [self createAddButton];
    
    
//    [self.navigationController.navigationBar addSubview:zkingSearchV];
    
//    self.navigationItem.titleView = zkingSearchV;
    
    [self createNavigationView];
    
    //menu选项
    
    [self createMenu];
    
    
    //数据展示table
    
    _table = [[RefreshTableView alloc]initWithFrame:CGRectMake(0, menuBgView.bottom, 320, self.view.height -zkingSearchV.height - menuBgView.height - 49 - 15 - (iPhone5 ? 20 : 0))];
    
    _table.refreshDelegate = self;
    _table.dataSource = self;
    
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_table];
    
    //搜索遮罩
    
    [self createMask];
    
    [_table showRefreshHeader:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - mark 添加寻车信息

- (void)createAddButton
{
    UIButton *saveButton =[[UIButton alloc]initWithFrame:CGRectMake(0,8,30,21.5)];
    [saveButton addTarget:self action:@selector(clickToBack:) forControlEvents:UIControlEventTouchUpInside];
    [saveButton setImage:[UIImage imageNamed:@"xubxhe_fabu_44_44"] forState:UIControlStateNormal];
    UIBarButtonItem *save_item=[[UIBarButtonItem alloc]initWithCustomView:saveButton];
    
    self.navigationItem.rightBarButtonItems = @[save_item];
}

- (void)createNavigationView
{
    navigationView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    navigationView.backgroundColor = [UIColor orangeColor];
    
    UIButton *saveButton =[[UIButton alloc]initWithFrame:CGRectMake(0,8,30,21.5)];
    [saveButton addTarget:self action:@selector(clickToBack:) forControlEvents:UIControlEventTouchUpInside];
    [saveButton setImage:[UIImage imageNamed:@"xubxhe_fabu_44_44"] forState:UIControlStateNormal];
    
    [navigationView addSubview:saveButton];
    
    [self.navigationController.navigationBar addSubview:navigationView];
    
    //搜索
    
    zkingSearchV = [[ZkingSearchView alloc]initWithFrame:CGRectMake(10, (44 - 30)/2.0, 320 - 3 * 10 - saveButton.width, 30) imgBG:[UIImage imageNamed:@"sousuo_bg548_58"] shortimgbg:[UIImage imageNamed:@"sousuo_bg548_58"] imgLogo:[UIImage imageNamed:@"sousuo_icon26_26"] placeholder:@"请输入手机号或姓名" searchWidth:275.f ZkingSearchViewBlocs:^(NSString *strSearchText, int tag) {
        
        //        [self searchFriendWithname:strSearchText thetag:tag];
        
    }];
    zkingSearchV.backgroundColor = [UIColor clearColor];
    
    [navigationView addSubview:zkingSearchV];
    
//    CGRect labFrame = zkingSearchV.cancelLabel.frame;
//    labFrame.origin.x += 5;
//    zkingSearchV.cancelLabel.frame = labFrame;
}


#pragma - mark 搜索遮罩

- (void)createMask
{
    maskView = [[UIView alloc]initWithFrame:self.view.frame];
    maskView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    [self.view addSubview:maskView];
    maskView.hidden = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard)];
    [maskView addGestureRecognizer:tap];
}

- (void)hideKeyboard
{
    [zkingSearchV doCancelButton];
    maskView.hidden = YES;
}

#pragma - mark 创建导航menu

- (void)createMenu
{
    menuBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    menuBgView.backgroundColor = [UIColor colorWithHexString:@"ff9c00"];
    [self.view addSubview:menuBgView];
    
    NSArray *items = @[@"车型",@"规格",@"来源",@"期限",@"高级"];
    
    CGFloat everyWidth = (320 - 4) / items.count;//每个需要的宽度
    CGFloat needWidth = 0.0;
    
    for (int i = 0; i < items.count; i ++) {
        
        needWidth = everyWidth;
        if (i == items.count - 1) { //最后一个宽 + 1
            needWidth += 1;
        }
        
        Menu_Button *menuBtn = [[Menu_Button alloc]initWithFrame:CGRectMake((everyWidth + 1) * i, 0, needWidth, 40) title:[items objectAtIndex:i] target:self action:@selector(clickToDo:)];
        menuBtn.tag = 1000 + i;
        menuBtn.backgroundColor = [UIColor clearColor];
        [menuBgView addSubview:menuBtn];
        
        
        UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(menuBtn.right, 0, 0.5, 40)];
        line.backgroundColor = [UIColor colorWithHexString:@"ffb14d"];
        [menuBgView addSubview:line];
    }
    
    menu_Advanced = [[Menu_Advanced alloc]initWithFrontView:menuBgView];
    
    [menu_Advanced selectBlock:^(BlockStyle style, NSString *colorName, NSString *colorId) {
        
        if (style == Select_Out_Color) {
            NSLog(@"选择颜色:外观 %@ %@",colorName,colorId);
            
            _color_out = [colorId intValue];
            
        }else
        {
            NSLog(@"选择颜色:内饰 %@ %@",colorName,colorId);
            _color_in = [colorId intValue];
        }
        
        [self updateParam];
    }];
    
    [menu_Advanced selectCityBlock:^(NSString *cityName, NSString *provinceId, NSString *cityId) {
        
        NSLog(@"选择城市:%@ %@ %@",cityName,provinceId,cityId);
        
        _province = [provinceId intValue];
        _city = [cityId intValue];
        
        [self updateParam];
        
    }];
    
    menu_Standard = [[Menu_Normal alloc]initWithFrontView:menuBgView menuStyle:Menu_Standard];
    [menu_Standard selectNormalBlock:^(MenuStyle style, NSString *select) {
        NSLog(@"%@",select);
        
        _carfrom = [select intValue];
        
        [self updateParam];
    }];
    
    menu_Source = [[Menu_Normal alloc]initWithFrontView:menuBgView menuStyle:Menu_Source];
    [menu_Source selectNormalBlock:^(MenuStyle style, NSString *select) {
        NSLog(@"%@",select);
        
        _usertype = [select intValue];
        
        [self updateParam];
    }];
    
    menu_Timelimit = [[Menu_Normal alloc]initWithFrontView:menuBgView menuStyle:Menu_Timelimit];
    [menu_Timelimit selectNormalBlock:^(MenuStyle style, NSString *select) {
        NSLog(@"%@",select);
        
        _spot_future = [select intValue];
        
        [self updateParam];
    }];
    
    menu_Car = [[Menu_Car alloc]initWithFrontView:menuBgView];
    [menu_Car selectBlock:^(NSString *select) {
        
        NSLog(@"选择车辆信息 %@",select);
        
        _car = select;
        
        [self updateParam];
    }];
}

#pragma - mark 通过修改参数获取数据

- (void)updateParam
{
    _page = 1;
    _table.isReloadData = YES;
    [self getCarSourceList];
}

#pragma - mark 搜索车源数据

- (void)searchCarSourceWithKeyword:(NSString *)keyword page:(int)page
{
    _searchPage = page;
    
    //比较两次请求关键词是否一致,如果不一致，则刷新数据
    
    if (![_searchKeyword isEqualToString:keyword]) {
        
        _dataArray = nil;
    }
    
    _searchKeyword = keyword;
    
    NSString *url = [NSString stringWithFormat:FBAUTO_CARSOURCE_SEARCH,keyword,_searchPage,KPageSize];
    
    NSLog(@"搜索车源列表 %@",url);
    
    __weak typeof(FindCarViewController *)weakSelf = self;
    
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
            
//            CarSourceClass *aCar = [[CarSourceClass alloc]initWithDictionary:aDic];
//            
//            [arr addObject:aCar];
        }
        
        [weakSelf reloadData:arr isReload:_table.isReloadData requestType:CAR_SEARCH];
        
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

#pragma - mark 获取车型数据

/**
 *  是否需要获取车型数据，一天请求一次
 */
- (BOOL)needGetCarTypeData
{
    NSLog(@"----现在时间%@",[NSDate date]);
    
    NSDate *lastDate = [[NSUserDefaults standardUserDefaults]objectForKey:FBAUTO_CARSOURCE_TIME];
    
    if (lastDate) {
        
        NSTimeInterval timeIn = [lastDate timeIntervalSinceNow];
        NSLog(@"lastDate:%@ timeInterval:%f",lastDate,timeIn);
        
        CGFloat daySeconds = 24 * 60 * 60.f;//一天的时间的秒数
        
        if ((timeIn * -1) >= daySeconds) { //超过一天
            
            return YES;
        }else
        {
            return NO;
        }
    }
    
    return YES;
}

#pragma - mark 获取车源数据

/**
 *  获取车源列表
 *
 *  @param car         车型编码 如 000001001
 *  @param spot_future 现货或者期货id（如果不选择时为0）
 *  @param color_out   外观颜色id（如果不选择时为0）
 *  @param color_in    内饰颜色id（如果不选择时为0）
 *  @param carfrom     汽车规格id（美规，中规，如果不选择时为0）
 *  @param usertype    用户类型id（商家或者个人，如果不选择时为0）
 *  @param province    省份id （如果不选择时为0）
 *  @param city        城市id（如果不选择时为0）
 *  @param page        页码
 */

- (void)getCarSourceList
{
    _car = (_car == nil) ? @"000000000" : _car;
    NSString *url = [NSString stringWithFormat:@"%@&car=%@&spot_future=%d&color_out=%d&color_in=%d&carfrom=%d&usertype=%d&province=%d&city=%d&page=%d&ps=%d",FBAUTO_CARSOURCE_LIST,_car,_spot_future,_color_out,_color_in,_carfrom,_usertype,_province,_city,_page,KPageSize];
    
    NSLog(@"车源列表 %@",url);
    
    __weak typeof(FindCarViewController *)weakSelf = self;
    
    LCWTools *tool = [[LCWTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"车源列表erro%@",[result objectForKey:@"errinfo"]);
        //        NSLog(@"车源列表 result %@",result);
        
        NSDictionary *dataInfo = [result objectForKey:@"datainfo"];
        int total = [[dataInfo objectForKey:@"total"]intValue];
        
        if (_page < total) {
            
            _table.isHaveMoreData = YES;
        }else
        {
            _table.isHaveMoreData = NO;
        }
        
        NSArray *data = [dataInfo objectForKey:@"data"];
        
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:data.count];
        
        for (NSDictionary *aDic in data) {
            
//            CarSourceClass *aCar = [[CarSourceClass alloc]initWithDictionary:aDic];
//            
//            [arr addObject:aCar];
        }
        
        [weakSelf reloadData:arr isReload:_table.isReloadData requestType:CAR_LIST];
        
    }failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        NSLog(@"failDic %@",failDic);
        
        [LCWTools showMBProgressWithText:[failDic objectForKey:ERROR_INFO] addToView:self.view];
        
        if (_table.isReloadData) {
            
            _page --;
            
            [_table performSelector:@selector(finishReloadigData) withObject:nil afterDelay:1.0];
        }
        
    }];
}

/**
 *  刷新数据列表
 *
 *  @param dataArr  新请求的数据
 *  @param isReload 判断在刷新或者加载更多
 */
- (void)reloadData:(NSArray *)dataArr isReload:(BOOL)isReload requestType:(NSString *)requestType
{
    if ([requestType isEqualToString:_lastRequest]) { //两次请求一致
        
        NSLog(@"两次一致");
        
        if ([requestType isEqualToString:CAR_SEARCH]) {
            
            //            isReload = YES;
        }
        
    }else //两次请求不一致
    {
        isReload = YES;//强制刷新
        
        NSLog(@"两次不一致");
    }
    
    _lastRequest = requestType;
    
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
//    FBDetail2Controller *detail = [[FBDetail2Controller alloc]init];
//    detail.style = Navigation_Special;
//    detail.navigationTitle = @"详情";
//    detail.carId = carId;
//    detail.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:detail animated:YES];
    
}

- (void)clickToBigPhoto
{
//    FBPhotoBrowserController *browser = [[FBPhotoBrowserController alloc]init];
//    browser.imagesArray = @[[UIImage imageNamed:@"geren_down46_46"],[UIImage imageNamed:@"haoyou_dianhua40_46"]];
//    browser.showIndex = 1;
//    browser.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:browser animated:YES];
}

-(void)searchFriendWithname:(NSString *)strname thetag:(int )_tag{
    //tag=1,代表取消按钮；tag=2代表开始编辑状态；tag=3代表点击了搜索按钮
    
    // self.navigationController.navigationBarHidden=YES;
    switch (_tag) {
        case 1:
        {
            maskView.hidden = YES;
            
            _searchPage = 1;
        }
            break;
        case 2:
        {
            maskView.hidden = NO;
            _searchPage = 1;
            
        }
            break;
            
        case 3:
        {
            
            _isSearch = YES;
            
            [zkingSearchV doCancelButton];
            
            [self searchCarSourceWithKeyword:strname page:1];
        }
            break;
            
            
        default:
            break;
    }
    
}


#pragma - mark 点击选项

- (void)clickToDo:(Menu_Button *)selectButton
{
    _isSearch = NO;
    
    //搜索框恢复
    
    [zkingSearchV doCancelButton];
    
    NSInteger aTag = selectButton.tag - 1000;
    
    
    //控制选择项的显示
    
    selectButton.selected = !selectButton.selected;
    
    NSLog(@"%d",selectButton.selected);
    
    switch (aTag) {
        case 0:
        {
            Menu_Button *button = (Menu_Button *)[menuBgView viewWithTag:1000];
            
            if (button.selected) {
                
                menu_Car.itemIndex = aTag;
                [menu_Car showInView:self.view];
                
                [self openTag:(int)aTag];
                
            }else
            {
                [menu_Car hidden];
            }
        }
            break;
        case 1:
        {
            if (selectButton.selected) {
                
                menu_Standard.itemIndex = aTag;
                
                [menu_Standard showInView:self.view];
                
                [self openTag:(int)aTag];
                
            }else
                
            {
                [menu_Standard hidden];
            }
        }
            break;
        case 2:
        {
            if (selectButton.selected) {
                
                menu_Source.itemIndex = aTag;
                
                [menu_Source showInView:self.view];
                
                [self openTag:(int)aTag];
                
            }else
                
            {
                [menu_Source hidden];
            }
        }
            break;
        case 3:
        {
            if (selectButton.selected) {
                
                menu_Timelimit.itemIndex = aTag;
                
                [menu_Timelimit showInView:self.view];
                
                [self openTag:(int)aTag];
                
            }else
                
            {
                [menu_Timelimit hidden];
            }
        }
            break;
        case 4:
        {
            if (selectButton.selected) {
                
                menu_Advanced.itemIndex = aTag;
                
                [menu_Advanced showInView:self.view];
                
                [self openTag:(int)aTag];
                
            }else
                
            {
                [menu_Advanced hidden];
            }
        }
            break;
            
        default:
            break;
    }
    
}

- (void)openTag:(int)openTag
{
    long newIndex = openTag + 1000;
    if (newIndex == openIndex) {
        return;
    }
    
    switch (openIndex - 1000) {
        case 0:
        {
            [menu_Car hidden];
        }
            break;
        case 1:
        {
            [menu_Standard hidden];
        }
            break;
        case 2:
        {
            [menu_Source hidden];
        }
            break;
        case 3:
        {
            [menu_Timelimit hidden];
        }
            break;
        case 4:
        {
            [menu_Advanced hidden];
        }
            break;
            
        default:
            break;
    }
    
    openIndex = newIndex;
    
}

#pragma - mark RefreshDelegate <NSObject>

- (void)loadNewData
{
    NSLog(@"loadNewData");
    
    if (_isSearch) {
        
        [self searchCarSourceWithKeyword:_searchKeyword page:1];
        
    }else
    {
        _car = @"000000000";
        _spot_future = 0;
        _color_out = 0;
        _color_in = 0;
        _carfrom = 0;
        _usertype = 0;
        _province = 0;
        _city = 0;
        _page = 1;
        [self getCarSourceList];
    }
}

- (void)loadMoreData
{
    NSLog(@"loadMoreData");
    
    if (_isSearch) {
        
        _searchPage ++;
        [self searchCarSourceWithKeyword:_searchKeyword page:_searchPage];
        
    }else
    {
        _page ++;
        [self getCarSourceList];
    }
}

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    CarSourceClass *aCar = (CarSourceClass *)[_dataArray objectAtIndex:indexPath.row];
//    
//    [self clickToDetail:aCar.id];
}
- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

#pragma mark - UITableViewDelegate


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
    static NSString * identifier = @"FindCarCell";
    
    FindCarCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"FindCarCell" owner:self options:nil]objectAtIndex:0];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    if (indexPath.row < _dataArray.count) {
//        CarSourceClass *aCar = [_dataArray objectAtIndex:indexPath.row];
//        [cell setCellDataWithModel:aCar];
    }
    
    return cell;
    
}


@end
