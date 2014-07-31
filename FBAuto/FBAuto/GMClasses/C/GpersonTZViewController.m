//
//  GpersonTZViewController.m
//  FBAuto
//
//  Created by gaomeng on 14-7-9.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "GpersonTZViewController.h"

#import "GptzTableViewCell.h"

#import "GTimeSwitch.h"//时间处理类


#import "GtzDetailViewController.h"

@interface GpersonTZViewController ()

@end

@implementation GpersonTZViewController

- (void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"%s",__FUNCTION__);
    
    self.view.backgroundColor = [UIColor whiteColor];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 568-64-44) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    self.userId = [GMAPI getUid];
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self prepareNetData];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)prepareNetData{
    
    NSURL *url = [NSURL URLWithString:FBAUTO_PERSONTZLB];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        if (data.length == 0) {
            return;
        }
        NSDictionary *datainfo = [dic objectForKey:@"datainfo"];
        
        NSArray *dataArray = [datainfo objectForKey:@"data"];
        
        _dataArray = dataArray;
        
        [_tableView reloadData];
        
    }];
    
}


#pragma mark - UITableViewDelegate && UITableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"identifier";
    GptzTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[GptzTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.contentLabel.text = [_dataArray[indexPath.row]objectForKey:@"content"];
    NSString *time1 = [_dataArray[indexPath.row]objectForKey:@"dateline"];
    NSString *time2 = [GTimeSwitch testtime:time1];
    
    NSString *str = [time2 substringWithRange:NSMakeRange(0, 4)];//年
    NSString *str1 = [time2 substringWithRange:NSMakeRange(5, 2)];
    NSString *str2 = [time2 substringWithRange:NSMakeRange(8, 2)];
    
    NSString *timeStr = [NSString stringWithFormat:@"%@年%@月%@日",str,str1,str2];
    
    cell.timeLabel.text = timeStr;
    
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GtzDetailViewController *tzd = [[GtzDetailViewController alloc]init];
    tzd.uid = [_dataArray[indexPath.row]objectForKey:@"id"];
    NSLog(@"%@",tzd.uid);
    [self.navigationController pushViewController:tzd animated:YES];
    
    
}


@end
