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

- (void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"%s",__FUNCTION__);
    
    self.flagIndexPath = [NSIndexPath indexPathForRow:10000 inSection:10000];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _tableiView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 568-64)];
    _tableiView.delegate = self;
    _tableiView.dataSource = self;
    
    _tableiView.separatorColor = [UIColor whiteColor];
    
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
    __weak typeof (cell)bcell = cell;
    
    [cell setAddviewBlock:^{
        
        NSLog(@"11%@",bself.flagIndexPath);
        bself.flagIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
        
        if (bcell.isGreen == 120) {
            bself.flagIndexPath = [NSIndexPath indexPathForRow:1 inSection:1];
            bcell.isGreen =60;
        }
        
        
        [btableview reloadData];
        
    }];
    
    
    [cell loadView:indexPath];
    
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.separatorInset = UIEdgeInsetsZero;
    
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0;
    if (_tmpCell) {
        height = [_tmpCell loadView:indexPath];
    }else{
        _tmpCell = [[GfindCarTableViewCell alloc]init];
        _tmpCell.delegate = self;
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
