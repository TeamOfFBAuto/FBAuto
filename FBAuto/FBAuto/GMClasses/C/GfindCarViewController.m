//
//  GfindCarViewController.m
//  FBAuto
//
//  Created by gaomeng on 14-7-8.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "GfindCarViewController.h"
#import "GfindCarTableViewCell.h"

@interface GfindCarViewController ()

@end

@implementation GfindCarViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.flagIndexPath = [NSIndexPath indexPathForRow:10000 inSection:10000];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _tableiView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 568-64)];
    _tableiView.delegate = self;
    _tableiView.dataSource = self;
    
    [self.view addSubview:_tableiView];
    
    
    
}




#pragma mark - UITableiViewDelegate && UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
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
    
    
    
    
    
//    NSLog(@"---- %@",self.flagIndexPath);
    
    __weak typeof (self)bself = self;
    __weak typeof (_tableiView)btableview = _tableiView;
    
    [cell setAddviewBlock:^{
        
        bself.flagIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
        
        NSLog(@"11%@",bself.flagIndexPath);
        
        [btableview reloadData];
        
    }];
    
    
    [cell loadView:indexPath];
    
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0;
    if (_tmpCell) {
        _tmpCell.delegate = self;
        height = [_tmpCell loadView:indexPath];
    }else{
        _tmpCell.delegate = self;
        _tmpCell = [[GfindCarTableViewCell alloc]init];
        height = [_tmpCell loadView:indexPath];
    }
    

    
    return height;
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
