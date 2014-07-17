//
//  CarResourceViewController.m
//  FBAuto
//
//  Created by 史忠坤 on 14-6-25.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "CarResourceViewController.h"
#import "FBAutoAPIHeader.h"
#import "Menu_Advanced.h"
#import "Menu_Normal.h"
#import "Menu_button.h"
#import "Menu_Car.h"
#import "ZkingSearchView.h"
#import "FBPhotoBrowserController.h"
#import "FBDetailController.h"
#import "FBDetail2Controller.h"

#import "GloginViewController.h"

#import "CarBrand.h"
#import "CarStyle.h"
#import "CarType.h"

#import "AppDelegate.h"

#import "CarSourceCell.h"
#import "CarSourceClass.h"

#define KPageSize  10 //每页条数

#define CAR_LIST @"CAR_LIST" //车源列表
#define CAR_SEARCH @"CAR_SEARCH" //搜索车源

@interface CarResourceViewController ()<RefreshDelegate>
{
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
}

@end

@implementation CarResourceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:YES];
    if (![GMAPI getUsername].length) {
        
        [self presentViewController:[[UINavigationController alloc]initWithRootViewController:[[GloginViewController alloc]init]] animated:NO completion:^{
        }];
        
    }else{
        NSLog(@"xxname===%@",[GMAPI getUsername]);
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor=RGBCOLOR(22, 233, 3);
    self.view.backgroundColor = [UIColor whiteColor];
    
    //适配ios7navigationbar高度
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"daohanglan_bg_640_88"] forBarMetrics: UIBarMetricsDefault];
    
    //搜索
    
    zkingSearchV = [[ZkingSearchView alloc]initWithFrame:CGRectMake(0, (44 - 30)/2.0, 300, 30) imgBG:[UIImage imageNamed:@"sousuo_bg548_58"] shortimgbg:[UIImage imageNamed:@"sousuo_bg548_58"] imgLogo:[UIImage imageNamed:@"sousuo_icon26_26"] placeholder:@"请输入车型、电话、姓名或公司名" searchWidth:275.f ZkingSearchViewBlocs:^(NSString *strSearchText, int tag) {
        
        [self searchFriendWithname:strSearchText thetag:tag];
        
    }];
    zkingSearchV.backgroundColor = [UIColor clearColor];
    
    self.navigationItem.titleView = zkingSearchV;
    
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
    
    //定时更新
    
    if ([self needGetCarTypeData]) {
        
        [self getCarData];
    }
    
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    _searchKeyword = keyword;
    
    NSString *url = [NSString stringWithFormat:FBAUTO_CARSOURCE_SEARCH,keyword,_searchPage,KPageSize];
    
    NSLog(@"搜索车源列表 %@",url);
    
    __weak typeof(CarResourceViewController *)weakSelf = self;
    
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
        
        [weakSelf reloadData:arr isReload:_table.isReloadData requestType:CAR_SEARCH];
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        NSLog(@"failDic %@",failDic);
        if (_table.isReloadData) {
            
            _searchPage --;
            
            [_table finishReloadigData];
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

- (NSManagedObjectContext *)context
{
    return ((AppDelegate *)[[UIApplication sharedApplication]delegate]).managedObjectContext;
}

- (void)getCarData
{
    LCWTools *tools = [[LCWTools alloc]initWithUrl:FBAUTO_CARSOURCE_CARTYPE isPost:NO postData:nil];
    [tools requestCompletion:^(NSDictionary *result, NSError *erro) {
        NSLog(@"result %@",result);
        
        if ([result isKindOfClass:[NSDictionary class]]) {
            
            int erroCode = [[result objectForKey:@"errcode"]intValue];
            NSString *erroInfo = [result objectForKey:@"errinfo"];
            
            if (erroCode != 0) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:erroInfo delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                
                return ;
            }
            
            __weak typeof(CarResourceViewController *)weakSelf = self;
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                [weakSelf localCardata:result];
            });
        }
    }failBlock:^(NSDictionary *failDic, NSError *erro) {
        NSLog(@"failDic %@",failDic);
    }];
}

//存储本地
- (void)localCardata:(NSDictionary *)result
{
    NSArray *dataInfo = [result objectForKey:@"datainfo"];
    
    //品牌、车型、车款
    
    //dataInfo为数组,有效数据从下标为1开始
    for (int i = 1; i < dataInfo.count; i ++) {
        
        NSArray *carTypeArray = [dataInfo objectAtIndex:i];
        
        //carType下标为 0时代表上级名称，下标从 1 开始代表车型数据
        
        NSString *brand = [carTypeArray objectAtIndex:0];//品牌名称
        
        NSArray *brandArr = [brand componentsSeparatedByString:@"  "];
        NSString *firstLetter = [brandArr objectAtIndex:0];
        NSString *brandName = [brandArr objectAtIndex:1];
        
        
//        NSLog(@"品牌-------id:%@ 名称: %@ 首字母:%@",[self carCodeForIndex:i],brandName,firstLetter);
        CarBrand *aEntityMenu = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([CarBrand class]) inManagedObjectContext:[self context]];
        
        aEntityMenu.brandId = [self carCodeForIndex:i];
        aEntityMenu.brandName = brandName;
        aEntityMenu.brandFirstLetter = firstLetter;
        
        NSError *erro;
        if (![[self context] save:&erro]) {
//            NSLog(@"brand 保存失败：%@",erro);
        }else
        {
//            NSLog(@"brand 保存成功");
        }
        
        
        for (int j = 1; j < carTypeArray.count; j ++) {
            
            NSArray *carStyleArray = [carTypeArray objectAtIndex:j];
            
            NSString *style = [carStyleArray objectAtIndex:0];//车型名称
            
            NSArray *styleArr = [style componentsSeparatedByString:@"  "];
            NSString *styleArrFirstLetter = [styleArr objectAtIndex:0];
            NSString *styleName = [styleArr objectAtIndex:1];
            
//            NSLog(@"车型：：id:%@ 车型名称:%@",[self carCodeForIndex:j],styleName);
            
            
            CarType *aType = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([CarType class]) inManagedObjectContext:[self context]];
            aType.parentId = [self carCodeForIndex:i];
            aType.typeId = [self carCodeForIndex:j];
            aType.typeName = styleName;
            aType.firstLetter = styleArrFirstLetter;
            
            NSError *erro;
            if (![[self context] save:&erro]) {
//                NSLog(@"type 保存失败：%@",erro);
            }else
            {
//                NSLog(@"type 保存成功");
            }
            
            
            for (int k = 1; k < carStyleArray.count; k ++) {
                
                NSString *carStyle = [carStyleArray objectAtIndex:k];
                
//                NSLog(@"车款id:%@ 车款名称:%@",[self carCodeForIndex:k],carStyle);
                
                CarStyle *aType = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([CarStyle class]) inManagedObjectContext:[self context]];
                aType.parentId = [self carCodeForIndex:j];
                aType.styleId = [self carCodeForIndex:k];
                aType.styleName = carStyle;
                
                NSError *erro;
                if (![[self context] save:&erro]) {
//                    NSLog(@"style 保存失败：%@",erro);
                }else
                {
                    NSLog(@"style 保存成功");
                }
            }
        }
    }
    
    NSLog(@"车型数据保存完成");
    
    //记录请求数据成功时间
    
    [[NSUserDefaults standardUserDefaults]setObject:[NSDate date] forKey:FBAUTO_CARSOURCE_TIME];
    [[NSUserDefaults standardUserDefaults]synchronize];

}

/**
 *  一位数补两个0，两位数补一个0，三个数不用补
 *
 *  @param index 数组下标
 */
- (NSString *)carCodeForIndex:(int)index
{
    NSString *code = @"";
    if (index < 10)
    {
        code = [NSString stringWithFormat:@"00%d",index];
        
    }else if (index < 100)
    {
       code = [NSString stringWithFormat:@"0%d",index];
        
    }else
    {
       code = [NSString stringWithFormat:@"0%d",index];
    }
    return code;
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
    
    __weak typeof(CarResourceViewController *)weakSelf = self;
    
    LCWTools *tool = [[LCWTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"车源列表 result %@, erro%@",result,[result objectForKey:@"errinfo"]);
        
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
            
            CarSourceClass *aCar = [[CarSourceClass alloc]initWithDictionary:aDic];
            
            [arr addObject:aCar];
        }
        
        [weakSelf reloadData:arr isReload:_table.isReloadData requestType:CAR_LIST];
        
    }failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        NSLog(@"failDic %@",failDic);
        if (_table.isReloadData) {
            
            _page --;
            
            [_table finishReloadigData];
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
        
    }else //两次请求不一致
    {
        isReload = YES;//强制刷新
        
        NSLog(@"两次不一致");
    }
    
    _lastRequest = requestType;
    
    if (isReload) {
        
        _dataArray = dataArr;
        
        NSLog(@"走着了");
        
    }else
    {
        NSMutableArray *newArr = [NSMutableArray arrayWithArray:_dataArray];
        [newArr addObjectsFromArray:dataArr];
        _dataArray = newArr;
        
        NSLog(@"走着了 22");
    }
    
    [_table finishReloadigData];
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

- (void)clickToBigPhoto
{
    FBPhotoBrowserController *browser = [[FBPhotoBrowserController alloc]init];
    browser.imagesArray = @[[UIImage imageNamed:@"geren_down46_46"],[UIImage imageNamed:@"haoyou_dianhua40_46"]];
    browser.showIndex = 1;
    browser.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:browser animated:YES];
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
    CarSourceClass *aCar = (CarSourceClass *)[_dataArray objectAtIndex:indexPath.row];
    
    [self clickToDetail:aCar.id];
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
    
    CarSourceClass *aCar = [_dataArray objectAtIndex:indexPath.row];
    [cell setCellDataWithModel:aCar];
    
    return cell;
    
}


@end
