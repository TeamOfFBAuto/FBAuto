//
//  PersonalViewController.m
//  FBAuto
//
//  Created by 史忠坤 on 14-6-25.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "PersonalViewController.h"
#import "FBFriendsController.h"
#import "FBPhotoBrowserController.h"

#import "GPersonTableViewCell.h"//自定义单元格
#import "GChangePwViewController.h"//修改密码
#import "GfindCarViewController.h"//寻车界面
#import "GpersonTZViewController.h"//通知
#import "GMessageSViewController.h"//消息设置
#import "GmarkViewController.h"//我的收藏
#import "GperInfoViewController.h"//我的资料
#import "GlxwmViewController.h"//联系我们


//测试
#import "GyhzyViewController.h"//用户主页


@interface PersonalViewController ()

@end

@implementation PersonalViewController

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
    self.view.backgroundColor=RGBCOLOR(22, 23, 3);

    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.titleLabel.text = @"个人中心";
    self.button_back.hidden = YES;
    
    //头像
    self.userFaceImv = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 45, 45)];
    self.userFaceImv.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.userFaceImv];
    
    //公司名称
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.userFaceImv.frame)+10, CGRectGetMinY(self.userFaceImv.frame)+5, 245, 15)];
    self.nameLabel.font = [UIFont systemFontOfSize:15];
    self.nameLabel.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:self.nameLabel];
    
    self.nameLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(self.nameLabel.frame.origin.x, CGRectGetMaxY(self.nameLabel.frame)+6, 245, 13)];
    self.nameLabel1.backgroundColor = [UIColor purpleColor];
    self.nameLabel1.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:self.nameLabel1];
    
    
    
    NSArray *titileArray = @[@"商圈",@"消息",@"通知"];
    
    //商圈 消息 通知
    for (int i = 0; i<3; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:titileArray[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(8, 43, 8, 22)];
        btn.frame = CGRectMake(10+i*105, CGRectGetMaxY(self.userFaceImv.frame)+14, 91, 30);
        btn.backgroundColor = [UIColor orangeColor];
        btn.layer.cornerRadius = 4;
        btn.tag = 50+i;
        [btn addTarget:self action:@selector(clickToDetail:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    
    
    //展示信息的tableView
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 114, 320, 568-64-164) style:UITableViewStyleGrouped];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    
    
    
    //[self test];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDelegate && UITableViewDataSource


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger num = 0;
    if (section == 0) {
        num = 4;
    }else if (section == 1){
        num = 3;
    }
    
    return num;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,17, 60, 13)];
    titleLabel.font = [UIFont systemFontOfSize:13];
    titleLabel.textColor = RGBCOLOR(129, 129, 129);
    [view addSubview:titleLabel];
    
    
    if (section == 0) {
        titleLabel.text = @"个人信息";
    }else if (section == 1){
        titleLabel.text = @"系统设置";
    }
    return view;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"identifier";
    GPersonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[GPersonTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    UIView *xiatiao = [[UIView alloc]initWithFrame:CGRectMake(10.5, 43, 299, 1)];
    xiatiao.backgroundColor = [UIColor whiteColor];
    [cell.contentView addSubview:xiatiao];
    
    if ((indexPath.row == 3 && indexPath.section == 0)||(indexPath.row ==2 && indexPath.section == 1)) {
        xiatiao.hidden = YES;
    }
    
    [cell dataWithTitleLableWithIndexPath:indexPath];
    
    
    __weak typeof (cell)bcell = cell;
    
    [cell setKuangBlock:^(NSInteger index) {
        NSLog(@"%ld",(long)(index));
        [UIView animateWithDuration:0.05 animations:^{
            bcell.kuang.backgroundColor = RGBCOLOR(244, 244, 244);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.05 animations:^{
                bcell.kuang.backgroundColor = [UIColor whiteColor];
            } completion:^(BOOL finished) {
                
            }];
        }];
        
        
        if (index == 5) {//修改密码
            [self.navigationController pushViewController:[[GChangePwViewController alloc]init] animated:YES];
        }else if (index == 1){//我的资料
            [self.navigationController pushViewController:[[GperInfoViewController alloc]init] animated:YES];
            
        }else if (index == 2){//我的车源
            GfindCarViewController *mm = [[GfindCarViewController alloc]init];
            mm.gtype = 2;
            [self.navigationController pushViewController:mm animated:YES];
            
        }else if (index == 3){//我的寻车
            GfindCarViewController *gg = [[GfindCarViewController alloc]init];
            gg.gtype = 3;
            [self.navigationController pushViewController:gg animated:YES];
            
        }else if (index == 4){//我的收藏
            GmarkViewController *gmarkvc = [[GmarkViewController alloc]init];
            gmarkvc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:gmarkvc animated:YES];
            
        }else if (index == 6){//联系我们
            //[self.navigationController pushViewController:[[GlxwmViewController alloc]init] animated:YES];
            //测试
            [self.navigationController pushViewController:[[GyhzyViewController alloc]init] animated:YES];
            
            
        }else if (index == 7){//消息设置
            [self.navigationController pushViewController:[[GMessageSViewController alloc]init]animated:YES];
        }
        
        
    }];
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}








- (void)clickToDetail:(UIButton *)sender
{
    if (sender.tag == 50) {//商圈
        FBFriendsController *friends = [[FBFriendsController alloc]init];
        friends.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:friends animated:YES];
    }else if (sender.tag == 51){//消息
        
    }else if(sender.tag == 52){//通知
        [self.navigationController pushViewController:[[GpersonTZViewController alloc]init] animated:YES];
    }
    
}


@end
