//
//  Menu_Car.m
//  FBAuto
//
//  Created by lichaowei on 14-7-15.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "Menu_Car.h"
#import "Menu_Button.h"
#import "CarBrand.h"
#import "CarType.h"
#import "CarStyle.h"

#define KLEFT 10.0
#define KTOP 5.0
#define KBOTTOM 10

@implementation Menu_Car

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
        
        sumHeight = self.height - 49 - KTOP - 44 - 20 - 40 - KBOTTOM;
        
        table = [[UITableView alloc]initWithFrame:CGRectMake(KLEFT, arrowImage.bottom, self.width - 2 * KLEFT, sumHeight) style:UITableViewStylePlain];
        
        table.separatorInset = UIEdgeInsetsMake(10, 10, 0, 10);
        table.delegate = self;
        table.dataSource = self;
        [self addSubview:table];
        
        [self reloadFirstTable];
        
    }
    
    return self;
}

- (void)selectBlock:(SelectCarBlock)aBlock
{
    selectBlock = aBlock;
}

#pragma - mark 数据处理

- (void)reloadFirstTable
{
    NSArray *brandArray = [[[LCWTools alloc]init]queryDataClassType:CARSOURCE_BRAND_QUERY pageSize:0 andOffset:0 unique:0];
    
    brandDic = [NSMutableDictionary dictionary];
    
    for (CarBrand *aBrand in brandArray) {
        
        NSMutableArray *brandGroup = [NSMutableArray arrayWithArray:[brandDic objectForKey:aBrand.brandFirstLetter]];
        
        [brandGroup addObject:aBrand];
        
        [brandDic setObject:brandGroup forKey:aBrand.brandFirstLetter];
    }
    
    NSArray* arr = [brandDic allKeys];
    arr = [arr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        NSComparisonResult result = [obj1 compare:obj2];
        return result==NSOrderedDescending;
    }];
    
    firstLetterArray = arr;
    
    [table reloadData];
}

//二级table

- (void)reloadSecondTable:(NSArray *)carTypeArray
{
 
    secondArray = carTypeArray;
    
    if (secondTable == nil) {
        
        secondTable = [[UITableView alloc]initWithFrame:CGRectMake(table.left, table.top, 300, sumHeight) style:UITableViewStylePlain];
        secondTable.delegate = self;
        secondTable.dataSource = self;
        [self addSubview:secondTable];
        
        secondTable.alpha = 0.0f;
        
        [UIView animateWithDuration:0.5 animations:^{
            secondTable.alpha = 1.0f;
        }];
        
    }
    
    [secondTable reloadData];
}


//三级table

- (void)reloadThirdTableData:(NSArray *)dataArr
{
    
    if (thirdTable == nil) {
        
        thirdTable = [[UITableView alloc]initWithFrame:CGRectMake(table.left, table.top, 300, sumHeight) style:UITableViewStylePlain];
        thirdTable.delegate = self;
        thirdTable.dataSource = self;
        [self addSubview:thirdTable];
        
        thirdTable.alpha = 0.0f;
        
        [UIView animateWithDuration:0.2 animations:^{
            thirdTable.alpha = 1.0f;
        }];
        
    }
    
    thirdArray = dataArr;
    [thirdTable reloadData];
}




#pragma - mark 控制视图显示

- (void)showInView:(UIView *)aView
{
    [aView addSubview:self];
    [aView bringSubviewToFront:frontV];
    
    //箭头位置
    CGPoint arrowPoint = arrowImage.center;
    arrowPoint = CGPointMake(self.width / 10 + (self.width / 5) * 0, arrowPoint.y);
    arrowImage.center = arrowPoint;
}

- (void)hidden
{
    Menu_Button *button = (Menu_Button *)[frontV viewWithTag:1000];
    button.selected = NO;
    [self removeFromSuperview];
    NSLog(@"%@ hidden",self);
}

#pragma mark-UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == table) {
        return firstLetterArray.count;
    }
    return 1;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView == table) {
        
        return firstLetterArray;
    }
    
    return nil ;
}

//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    NSString *title = [firstLetterArray objectAtIndex:section];
//    return title;
//}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == table) {
        
        NSString *letter = [firstLetterArray objectAtIndex:section];
        
        UIView *aView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
        [aView addSubview:titleLabel];
        titleLabel.backgroundColor = [UIColor colorWithHexString:@"dcdcdc"];
        titleLabel.text = [NSString stringWithFormat:@"  %@",letter];
        
        return aView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == secondTable || tableView == thirdTable) {
        return 0;
    }
    return 20;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == table) {
        
        NSString *letter = [firstLetterArray objectAtIndex:section];
        
        NSArray *subArr = [brandDic objectForKey:letter];
        
        return subArr.count;
        
    }else if (tableView == secondTable)
    {
        return secondArray.count + 1;

        
    }else if (tableView == thirdTable)
    {
        return thirdArray.count;
    }
    return dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"ceell";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//        cell = [[[NSBundle mainBundle]loadNibNamed:@"MenuCell" owner:self options:nil]objectAtIndex:0];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:14.f];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"666666"];
    
    if (tableView == table) {
        
        NSString *letter = [firstLetterArray objectAtIndex:indexPath.section];
        
        NSArray *subArr = [brandDic objectForKey:letter];
        
        CarBrand *aBrand = [subArr objectAtIndex:indexPath.row];
        
        cell.textLabel.text = aBrand.brandName;
        
        return cell;
        
    }else if (tableView == secondTable)
    {
        
        if (indexPath.row == 0) {
            
            cell.textLabel.text = @"不限";
 
        }else
        {

            CarType *aType = [secondArray objectAtIndex:indexPath.row - 1];
            
            cell.textLabel.text = aType.typeName;
        }
        
        
    }if (tableView == thirdTable)
    {
        
        if (indexPath.row == 0) {
            
            cell.textLabel.text = @"不限";
            
        }else
        {
            
            CarStyle *aStyle = [thirdArray objectAtIndex:indexPath.row - 1];
            
            cell.textLabel.text = aStyle.styleName;
        }
        
        
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == table) {
        
        NSString *letter = [firstLetterArray objectAtIndex:indexPath.section];
        
        NSArray *subCityArr = [brandDic objectForKey:letter];
        
        CarBrand *aBrand = [subCityArr objectAtIndex:indexPath.row];
        
        NSArray *typeArr = [[[LCWTools alloc]init]queryDataClassType:CARSOURCE_TYPE_QUERY pageSize:0 andOffset:0 unique:aBrand.brandId];
        
        brandId = aBrand.brandId;
        
        [self reloadSecondTable:typeArr];
        
    }else if (tableView == secondTable)
    {
        if (indexPath.row == 0) {
            
            [self hidden];
            
            NSString *car = [NSString stringWithFormat:@"%@%@%@",brandId,@"000",@"000"];
            selectBlock(car);
            
        }else
        {
            CarType *aType = [secondArray objectAtIndex:indexPath.row - 1];
            NSArray *styteArr = [[[LCWTools alloc]init]queryDataClassType:CARSOURCE_STYLE_QUERY pageSize:0 andOffset:0 unique:aType.typeId];
            
            typeId = aType.typeId;
            
            [self reloadThirdTableData:styteArr];
        }

        
    }else if(tableView == thirdTable)
    {
        if (indexPath.row == 0) {
            
            NSString *car = [NSString stringWithFormat:@"%@%@%@",brandId,typeId,@"000"];
            selectBlock(car);
        }else
        {
            CarStyle *aStyle = [thirdArray objectAtIndex:indexPath.row - 1];
            NSString *car = [NSString stringWithFormat:@"%@%@%@",brandId,typeId,aStyle.styleId];
            selectBlock(car);
        }
        
        [self hidden];
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (tableView == secondTable || tableView == thirdTable) {
        
        UIView *aView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
        aView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
        
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = CGRectMake(50, 7, 200, 35);
        [backButton setTitle:@"返回" forState:UIControlStateNormal];
        [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [backButton setBackgroundImage:[UIImage imageNamed:@"fanhui_button"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(clickToBack:) forControlEvents:UIControlEventTouchUpInside];
        [aView addSubview:backButton];
        
        if (tableView == secondTable) {
            backButton.tag = 10000;
        }else
        {
            backButton.tag = 10001;
        }
        
        return aView;
    }
    
    return [UIView new];
}

- (void)clickToBack:(UIButton *)sender
{
    if (sender.tag == 10000) {
        [secondTable removeFromSuperview];
        secondTable = nil;
    }else
    {
        [thirdTable removeFromSuperview];
        thirdTable = nil;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (tableView == secondTable || tableView == thirdTable) {
        return 50;
    }
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
