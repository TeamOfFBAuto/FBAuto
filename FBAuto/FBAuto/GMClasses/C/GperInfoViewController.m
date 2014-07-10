//
//  GperInfoViewController.m
//  FBAuto
//
//  Created by gaomeng on 14-7-10.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "GperInfoViewController.h"
#import "GperInfoTableViewCell.h"

@interface GperInfoViewController ()

@end

@implementation GperInfoViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 314) style:UITableViewStylePlain];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.scrollEnabled = NO;
    _tableview.separatorColor = RGBCOLOR(220, 220, 220);
    [self.view addSubview:_tableview];
    
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource && UITableViewDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"identifier";
    GperInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[GperInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    [cell loadViewWithIndexPath:indexPath];
    
    cell.separatorInset = UIEdgeInsetsMake(0, 10, 300, 10);
    cell.selectedBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, 300, 44)];
    if (indexPath.row == 0) {
        cell.selectedBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, 300, 60)];
    }
    cell.selectedBackgroundView.backgroundColor = RGBCOLOR(244, 244, 244);
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
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
