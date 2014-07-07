//
//  SendCarParamsController.m
//  FBAuto
//
//  Created by lichaowei on 14-7-2.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "SendCarParamsController.h"
#import "Menu_Header.h"

@interface SendCarParamsController ()

@end

@implementation SendCarParamsController

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
    // Do any additional setup after loading the view.
    
    self.table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.height - 44 - (iPhone5 ? 20 : 0)) style:UITableViewStylePlain];
    _table.delegate = self;
    _table.dataSource = self;
    [self.view addSubview:_table];
    
    NSString *title = nil;
    switch (self.dataStyle) {
        case Data_Car_Model:
        {
            
            title = @"车型";
            self.dataArray = MENU_HIGHT_TITLE;
        }
            break;
        case Data_Standard:
        {
            title = @"规格";
            self.dataArray = MENU_STANDARD;
        }
            break;
        case Data_Timelimit:
        {
            title = @"期限";
            self.dataArray = MENU_TIMELIMIT;
        }
            break;
        case Data_Color_Out:
        {
            title = @"外观颜色";
            self.dataArray = MENU_HIGHT_OUTSIDE_CORLOR;
        }
            break;
        case Data_Color_In:
        {
            title = @"内饰颜色";
            self.dataArray = MENU_HIGHT_INSIDE_CORLOR;
        }
            break;
        case Data_Price:
        {
            title = @"价格";
            self.dataArray = MENU_PRICE;
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
#pragma mark-UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"identifier";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    cell.textLabel.text = [_dataArray objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *select = [_dataArray objectAtIndex:indexPath.row];
    self.selectLabel.text = select;
    [self clickToBack:nil];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

@end
