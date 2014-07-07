//
//  FBAreaFriensController.m
//  FBAuto
//
//  Created by lichaowei on 14-7-7.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "FBAreaFriensController.h"
#import "FBAutoAPIHeader.h"
#import "MenuModel.h"
#import "City.h"
#import "Menu_Header.h"
#import "MenuCell.h"

#define KLEFT 0.0
#define KTOP 5.0
#define KBOTTOM 10

@interface FBAreaFriensController ()

@end

@implementation FBAreaFriensController

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
    
    self.titleLabel.text = @"我的好友";
    
    secondTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width - 2 * KLEFT, self.view.height - (iPhone5 ? 20 : 0) - 44) style:UITableViewStylePlain];
    
    secondTable.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    secondTable.delegate = self;
    secondTable.dataSource = self;
    [self.view addSubview:secondTable];
    
    [self loadCityData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - mark 二级、三级table管理

- (void)loadCityData
{
    
    __block typeof (FBAreaFriensController *)weakSelf = self;
    
    NSString * path = [[NSBundle mainBundle] pathForResource:@"city.plist" ofType:nil];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSMutableArray *cityArray = [[NSMutableArray alloc] initWithContentsOfFile:path];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            NSArray *states = [[cityArray objectAtIndex:0]objectForKey:@"states"];
            
            [weakSelf groupCityWithArray:states];
            
        });
    });
}

//城市分组

- (void)groupCityWithArray:(NSArray *)states
{
    cityDic = [NSMutableDictionary dictionary];
    
    for (NSDictionary *aState in states) {
        NSString *stateName = [aState objectForKey:@"state"];
        NSString *firstLetter = [stateName getFirstLetter];
        NSArray *cities = [aState objectForKey:@"cities"];
        City *aCity = [[City alloc]initWithTitle:stateName subCities:cities];
        
        NSMutableArray *cityGroup = [NSMutableArray arrayWithArray:[cityDic objectForKey:firstLetter]];
        [cityGroup addObject:aCity];
        
        [cityDic setObject:cityGroup forKey:firstLetter];
    }
    
    NSArray* arr = [cityDic allKeys];
    arr = [arr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        NSComparisonResult result = [obj1 compare:obj2];
        return result==NSOrderedDescending;
    }];
    
    firstLetterArray = arr;
    
    [self reloadSecondTable];
}

//二级table

- (void)reloadSecondTable
{
    
    if (secondTable == nil) {
        
        secondTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 220, self.view.height - (iPhone5 ? 20 : 0) - 44) style:UITableViewStylePlain];
        secondTable.delegate = self;
        secondTable.dataSource = self;
        [self.view addSubview:secondTable];
        
    }
    
    [secondTable reloadData];
}



//三级table

- (void)reloadThirdTableData:(NSArray *)dataArr
{
    
    if (thirdTable == nil) {
        
        thirdTable = [[UITableView alloc]initWithFrame:CGRectMake(320, 0, 320 - 270/2.0, self.view.height) style:UITableViewStylePlain];
        thirdTable.delegate = self;
        thirdTable.dataSource = self;
        [self.view addSubview:thirdTable];
        
        [UIView animateWithDuration:0.2 animations:^{
            CGRect aFrame = thirdTable.frame;
            aFrame.origin.x -= (320 - 270/2.0);
            thirdTable.frame = aFrame;
        }];
        
    }
    
    thirdArray = dataArr;
    [thirdTable reloadData];
}

#pragma mark-UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == secondTable) {
        return [cityDic allKeys].count + 1;
    }
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == secondTable) {
        if (section == 0) {
            return nil;
        }
        
        NSString *letter = [firstLetterArray objectAtIndex:section - 1];
        UIView *aView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 300, 20)];
        [aView addSubview:titleLabel];
        titleLabel.backgroundColor = [UIColor colorWithHexString:@"dcdcdc"];
//        titleLabel.te
        titleLabel.text = [NSString stringWithFormat:@"  %@",letter];
        
        return aView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 20;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == secondTable) {
        if (section == 0) {
            return 1;
        }
        
        NSString *letter = [firstLetterArray objectAtIndex:section - 1];
        NSArray *arr = [cityDic objectForKey:letter];
        return arr.count;
        
    }else if (tableView == thirdTable)
    {
        return thirdArray.count;
        
    }
    return 0;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *arr = [NSMutableArray arrayWithArray:firstLetterArray];
    [arr insertObject:@"全" atIndex:0];
    
    return arr ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"menuCell";
    
    MenuCell * cell = (MenuCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil)
    {
        //        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MenuCell" owner:self options:nil]objectAtIndex:0];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (tableView == secondTable) {
        
        if (indexPath.section == 0) {
            
            cell.contenLabel.text = @"全国";
            cell.contenLabel.textColor = [UIColor colorWithHexString:@"ff9c00"];
            
        }else
        {
            NSString *letter = [firstLetterArray objectAtIndex:indexPath.section - 1];
            NSArray *arr = [cityDic objectForKey:letter];
            
            City *aCity = [arr objectAtIndex:indexPath.row];
            
            cell.contenLabel.text = aCity.title;
            cell.seg_style = Seg_left;
            
            cell.contenLabel.textColor = [UIColor colorWithHexString:@"666666"];
        }
        return cell;
        
    }else if (tableView == thirdTable)
    {
        cell.contenLabel.text = [thirdArray objectAtIndex:indexPath.row];
        
    }
    cell.contenLabel.textColor = [UIColor colorWithHexString:@"666666"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == secondTable) {
        
        if (indexPath.section == 0) {
            return;
        }
        
        NSString *letter = [firstLetterArray objectAtIndex:indexPath.section - 1];
        NSArray *cities = [cityDic objectForKey:letter];
        City *aCity = [cities objectAtIndex:indexPath.row];
        
        [self reloadThirdTableData:aCity.subCities];
        
    }else if (tableView == thirdTable)
    {
        NSString *cityName = [thirdArray objectAtIndex:indexPath.row];

        
    }
    
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
