//
//  GperInfoViewController.m
//  FBAuto
//
//  Created by gaomeng on 14-7-10.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "GperInfoViewController.h"
#import "GperInfoTableViewCell.h"


#import "SzkLoadData.h"//网络请求类


@interface GperInfoViewController ()

@end

@implementation GperInfoViewController

- (void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //主tableview
    _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 315) style:UITableViewStylePlain];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.scrollEnabled = NO;
    _tableview.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:_tableview];
    
    
    //请求网络数据
    [self prepareNetData];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)prepareNetData{
    SzkLoadData *aaa = [[SzkLoadData alloc]init];
    //请求地址str
    NSString *str = [NSString stringWithFormat:FBAUTO_GET_USER_INFORMATION,[GMAPI getUid]];
    NSLog(@"请求用户信息接口 %@",str);
    [aaa SeturlStr:str block:^(NSArray *arrayinfo, NSString *errorindo, NSInteger errcode) {
        if ([errorindo isEqualToString:@"noerror"]) {
            
        }
    }];
}



#pragma mark - UITableViewDataSource && UITableViewDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"identifier";
    GperInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[GperInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.delegate = self;
    [cell loadViewWithIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger num = 0;
    if (section == 0) {
        num = 1;
    }else if (section == 1){
        num = 5;
    }
    return num;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat height = 0;
    
    if (_tmpCell) {
        height = [_tmpCell loadViewWithIndexPath:indexPath];
    }else{
        _tmpCell = [[GperInfoTableViewCell alloc]init];
        height = [_tmpCell loadViewWithIndexPath:indexPath];
    }
    
    return height;
}


@end
