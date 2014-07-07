//
//  Menu_Advanced.m
//  FBAuto
//
//  Created by lichaowei on 14-6-30.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "Menu_Advanced.h"
#import "FBAutoAPIHeader.h"
#import "MenuModel.h"
#import "City.h"
#import "Menu_Header.h"
#import "MenuCell.h"

#define KLEFT 0.0
#define KTOP 5.0
#define KBOTTOM 10


@implementation Menu_Advanced

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrontView:(UIView *)frontView
{
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        
        self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        
        arrowImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, frontView.bottom, 11, KTOP)];
        arrowImage.backgroundColor = [UIColor clearColor];
        arrowImage.image = [UIImage imageNamed:@"zhankaijiantou22_10"];
        [self addSubview:arrowImage];
        
        frontV = frontView;
        
        sumHeight = self.height - 49 - frontView.bottom - KTOP;
        
        table = [[UITableView alloc]initWithFrame:CGRectMake(KLEFT, arrowImage.bottom, self.width - 2 * KLEFT, sumHeight) style:UITableViewStylePlain];
        
        table.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        table.delegate = self;
        table.dataSource = self;
        [self addSubview:table];
        
        dataArray = MENU_HIGHT_TITLE;
        [table reloadData];
        
        CGRect aFrame = table.frame;
        aFrame.size.height = 40 * dataArray.count;
        table.frame = aFrame;
        
    }
    
    return self;
}

- (void)selectBlock:(SelectBlock)aBlock
{
    selectBlock = aBlock;
}

#pragma - mark 二级、三级table管理

- (void)loadCityData
{
    if (colorTable) {
        [self insertSubview:colorTable belowSubview:secondTable];
    }
    
    __block typeof (Menu_Advanced *)weakSelf = self;
    
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
        
        secondTable = [[UITableView alloc]initWithFrame:CGRectMake(320, table.top, 220, sumHeight) style:UITableViewStylePlain];
        secondTable.delegate = self;
        secondTable.dataSource = self;
        [self addSubview:secondTable];
        
        [UIView animateWithDuration:0.2 animations:^{
            CGRect aFrame = secondTable.frame;
            aFrame.origin.x -= 220;
            secondTable.frame = aFrame;
        }];
        
    }
    
    [secondTable reloadData];
}



//三级table

- (void)reloadThirdTableData:(NSArray *)dataArr
{
    
    if (thirdTable == nil) {
        
        thirdTable = [[UITableView alloc]initWithFrame:CGRectMake(320, table.top, 220, sumHeight) style:UITableViewStylePlain];
        thirdTable.delegate = self;
        thirdTable.dataSource = self;
        [self addSubview:thirdTable];
        
        [UIView animateWithDuration:0.2 animations:^{
            CGRect aFrame = thirdTable.frame;
            aFrame.origin.x -= 120;
            thirdTable.frame = aFrame;
        }];
        
    }
    
    thirdArray = dataArr;
    [thirdTable reloadData];
}

#pragma - mark 控制颜色相关table

- (void)reloadColorTableWithArray:(NSArray *)colorArr
{
    if (colorTable == nil) {
        
        colorTable = [[UITableView alloc]initWithFrame:CGRectMake(320, table.top, 220, sumHeight) style:UITableViewStylePlain];
        colorTable.delegate = self;
        colorTable.dataSource = self;
        [self addSubview:colorTable];
        
        [UIView animateWithDuration:0.2 animations:^{
            CGRect aFrame = colorTable.frame;
            aFrame.origin.x -= 220;
            colorTable.frame = aFrame;
        }];
    }
    
    [self bringSubviewToFront:colorTable];
    colorArray = colorArr;
    [colorTable reloadData];
}


#pragma - mark 控制视图显示

- (void)showInView:(UIView *)aView
{
    [aView addSubview:self];
    [aView bringSubviewToFront:frontV];
    
    //箭头位置
    CGPoint arrowPoint = arrowImage.center;
    arrowPoint = CGPointMake(self.width / 10 + (self.width / 5) * self.itemIndex, arrowPoint.y);
    arrowImage.center = arrowPoint;
}

- (void)hidden
{
    Menu_Button *button = (Menu_Button *)[frontV viewWithTag:100 + _itemIndex];
    button.selected = NO;
    [self removeFromSuperview];
}

#pragma mark-UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == secondTable) {
        return [cityDic allKeys].count;
    }
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == secondTable) {
        NSString *letter = [firstLetterArray objectAtIndex:section];
        return letter;
    }
    return nil;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == secondTable) {
        
        NSString *letter = [firstLetterArray objectAtIndex:section];
        NSArray *arr = [cityDic objectForKey:letter];
        return arr.count;
        
    }else if (tableView == thirdTable)
    {
        return thirdArray.count;
        
    }else if (tableView == colorTable)
    {
        return colorArray.count;
    }
    return dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
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
        
        NSString *letter = [firstLetterArray objectAtIndex:indexPath.section];
        NSArray *arr = [cityDic objectForKey:letter];
        
        City *aCity = [arr objectAtIndex:indexPath.row];
        
        cell.contenLabel.text = aCity.title;
        cell.seg_style = Seg_left;
        
    }else if (tableView == thirdTable)
    {
        cell.contenLabel.text = [thirdArray objectAtIndex:indexPath.row];
        
    }else if (tableView == colorTable)
    {
        cell.contenLabel.text = [colorArray objectAtIndex:indexPath.row];
        
    }else
    {
        cell.contenLabel.text = [dataArray objectAtIndex:indexPath.row];
        cell.seg_style = Seg_right;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == secondTable) {
        
        NSString *letter = [firstLetterArray objectAtIndex:indexPath.section];
        NSArray *cities = [cityDic objectForKey:letter];
        City *aCity = [cities objectAtIndex:indexPath.row];
        
        [self reloadThirdTableData:aCity.subCities];
        
    }else if (tableView == thirdTable)
    {
        NSString *cityName = [thirdArray objectAtIndex:indexPath.row];
        selectBlock(blockStyle,cityName);
        [self hidden];
        
    }else if (tableView == colorTable)
    {
        NSString *colorName = [colorArray objectAtIndex:indexPath.row];
        selectBlock(blockStyle,colorName);
        [self hidden];
    }else
    {
        if (indexPath.row == 2) {
            
            [self loadCityData];
            
            blockStyle = Select_Area;
        }
        
        if (indexPath.row == 0) {
            NSLog(@"外观颜色");
            
            [self reloadColorTableWithArray:MENU_HIGHT_OUTSIDE_CORLOR];
            blockStyle = Select_Out_Color;
        }
        
        if (indexPath.row == 1) {
            NSLog(@"内饰颜色");
            [self reloadColorTableWithArray:MENU_HIGHT_INSIDE_CORLOR];
            blockStyle = Select_In_Color;
        }
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


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hidden];
}

@end
