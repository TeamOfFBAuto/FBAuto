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
#import "ZkingSearchView.h"
#import "FBPhotoBrowserController.h"
#import "FBDetailController.h"
#import "FBDetail2Controller.h"

#import "GloginViewController.h"

@interface CarResourceViewController ()
{
    Menu_Advanced *menu_Advanced;//高级
    Menu_Normal *menu_Standard;//规格
    Menu_Normal *menu_Source;//来源
    Menu_Normal *menu_Timelimit;//期限
    
    UIView *menuBgView;
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
    
    ZkingSearchView *zkingSearchV = [[ZkingSearchView alloc]initWithFrame:CGRectMake(0, (44 - 30)/2.0, 300, 30) imgBG:[UIImage imageNamed:@"sousuo_bg548_58"] shortimgbg:[UIImage imageNamed:@"sousuo_bg548_58"] imgLogo:[UIImage imageNamed:@"sousuo_icon26_26"] placeholder:@"请输入手机号或姓名" searchWidth:275.f ZkingSearchViewBlocs:^(NSString *strSearchText, int tag) {
        
        [self searchFriendWithname:nil thetag:tag];
        
    }];
    zkingSearchV.backgroundColor = [UIColor clearColor];
    
    self.navigationItem.titleView = zkingSearchV;
    
    
    //menu选项
    
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
        menuBtn.tag = 100 + i;
        menuBtn.backgroundColor = [UIColor clearColor];
        [menuBgView addSubview:menuBtn];
        
        
        UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(menuBtn.right, 0, 0.5, 40)];
        line.backgroundColor = [UIColor colorWithHexString:@"ffb14d"];
        [menuBgView addSubview:line];
    }
    
    menu_Advanced = [[Menu_Advanced alloc]initWithFrontView:menuBgView];
    
    [menu_Advanced selectBlock:^(BlockStyle style, NSString *selectColor) {
        NSLog(@"%@",selectColor);
    }];
    
    menu_Standard = [[Menu_Normal alloc]initWithFrontView:menuBgView menuStyle:Menu_Standard];
    [menu_Standard selectNormalBlock:^(MenuStyle style, NSString *select) {
        NSLog(@"%@",select);
    }];
    
    menu_Source = [[Menu_Normal alloc]initWithFrontView:menuBgView menuStyle:Menu_Source];
    [menu_Source selectNormalBlock:^(MenuStyle style, NSString *select) {
        NSLog(@"%@",select);
    }];
    
    menu_Timelimit = [[Menu_Normal alloc]initWithFrontView:menuBgView menuStyle:Menu_Timelimit];
    [menu_Timelimit selectNormalBlock:^(MenuStyle style, NSString *select) {
        NSLog(@"%@",select);
    }];
    
    
    [self test];
    // Do any additional setup after loading the view.
}


- (void)test
{
    UIButton *addPhoto2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    addPhoto2.frame = CGRectMake(100,100 + 100, 100, 50);
    [addPhoto2 addTarget:self action:@selector(clickToDetail) forControlEvents:UIControlEventTouchUpInside];
    [addPhoto2 setTitle:@"详情" forState:UIControlStateNormal];
    [self.view addSubview:addPhoto2];
}


- (void)clickToDetail
{
    FBDetail2Controller *detail = [[FBDetail2Controller alloc]init];
    detail.style = Navigation_Special;
    detail.navigationTitle = @"详情";
    detail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];
    
//    FBDetailController *detail = [[FBDetailController alloc]init];
//    detail.style = Navigation_Special;
//    detail.navigationTitle = @"详情";
//    detail.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:detail animated:YES];
    
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
            NSLog(@"取消");
                        
        }
            break;
        case 2:
        {
            
            
        }
            break;
            
        case 3:
        {
            
        }
            break;
            
            
        default:
            break;
    }
    
    
}


#pragma - mark 点击选项

- (void)clickToDo:(Menu_Button *)selectButton
{
    NSInteger aTag = selectButton.tag - 100;
    
    //控制未选项的不显示
    
    if (aTag != 4) {
        [menu_Advanced hidden];
    }
    if (aTag != 1) {
        [menu_Standard hidden];//规格
    }
    if (aTag != 2) {
        [menu_Source hidden];//来源
    }
    if (aTag != 3) {
        [menu_Timelimit hidden];//期限
    }
    
    
    //控制选择项的显示
    
    selectButton.selected = !selectButton.selected;
    
    switch (aTag) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            if (selectButton.selected) {
                
                menu_Standard.itemIndex = aTag;
                
                [menu_Standard showInView:self.view];
                
                
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
                
                
            }else
                
            {
                [menu_Timelimit hidden];
            }
        }
            break;
        case 4:
        {
            if (selectButton.selected) {
                
                menu_Advanced.itemIndex = selectButton.tag - 100;
                
                [menu_Advanced showInView:self.view];
                
                
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
