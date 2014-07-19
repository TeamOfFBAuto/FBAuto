//
//  SendCarParamsController.m
//  FBAuto
//
//  Created by lichaowei on 14-7-2.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "SendCarParamsController.h"
#import "Menu_Header.h"
#import "CarBrand.h"
#import "CarType.h"
#import "CarStyle.h"

@interface SendCarParamsController ()
{
    NSMutableDictionary *brandDic;//存储分组brand
    NSArray *firstLetterArray;//分组首字母数据brand

}

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
        case Data_Car_Brand:
        {
            
            title = @"车型";
            [self getCarsource];
        }
            break;
        case Data_Standard:
        {
            title = @"规格";
            self.dataArray = self.haveLimit ? MENU_SOURCE : MENU_SOURCE_2;
        }
            break;
        case Data_Timelimit:
        {
            title = @"期限";
            self.dataArray = self.haveLimit ? MENU_TIMELIMIT : MENU_TIMELIMIT_2;
        }
            break;
        case Data_Color_Out:
        {
            title = @"外观颜色";
            self.dataArray = self.haveLimit ? MENU_HIGHT_OUTSIDE_CORLOR : MENU_HIGHT_OUTSIDE_CORLOR_2;
        }
            break;
        case Data_Color_In:
        {
            title = @"内饰颜色";
            self.dataArray = self.haveLimit ? MENU_HIGHT_INSIDE_CORLOR : MENU_HIGHT_INSIDE_CORLOR_2;
        }
            break;
        case Data_Car_Type:
        {
            NSArray *typeArr = [[[LCWTools alloc]init]queryDataClassType:CARSOURCE_TYPE_QUERY pageSize:0 andOffset:0 unique:self.brandId];
            
            self.dataArray = typeArr;
            
        }
            break;
        case Data_Car_Style:
        {
            NSArray *styteArr = [[[LCWTools alloc]init]queryDataClassType:CARSOURCE_STYLE_QUERY pageSize:0 andOffset:0 unique:self.typeId];
            
            self.dataArray = styteArr;
        }
            break;
        case Data_Area:
        {

        }
            break;
        case Data_Money:
        {
            self.dataArray = self.haveLimit ? MENU_MONEY : MENU_MONEY_2;
        }
            break;
            
        default:
            break;
    }
    
    [self.table reloadData];

}

- (void)selectParamBlock:(SelectParamsBlock)aBlock
{
    selectBlock = aBlock;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - mark 获取车品牌

- (void)getCarsource
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
    
    [self.table reloadData];
}

#pragma mark-UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.dataStyle == Data_Car_Brand) {
        return firstLetterArray.count;
    }
    return 1;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (self.dataStyle == Data_Car_Brand) {
        
        return firstLetterArray;
    }
    
    return nil ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.dataStyle == Data_Car_Brand) {
        return 20;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.dataStyle == Data_Car_Brand) {
        
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


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataStyle == Data_Car_Brand) {
        
        NSString *letter = [firstLetterArray objectAtIndex:section];
        
        NSArray *subArr = [brandDic objectForKey:letter];
        
        return subArr.count;
        
    }
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
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:14.f];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"666666"];
    
    if (self.dataStyle == Data_Car_Brand) {
        
        NSString *letter = [firstLetterArray objectAtIndex:indexPath.section];
        
        NSArray *subArr = [brandDic objectForKey:letter];
        
        CarBrand *aBrand = [subArr objectAtIndex:indexPath.row];
        
        cell.textLabel.text = aBrand.brandName;
        
        return cell;
        
    }else if (self.dataStyle == Data_Car_Type)
    {
        if (indexPath.row == 0) {
           cell.textLabel.text = @"不限";
        }else
        {
            CarType *aType = [self.dataArray objectAtIndex:indexPath.row - 1];
            
            cell.textLabel.text = aType.typeName;

        }
    }else if (self.dataStyle == Data_Car_Style)
    {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"不限";
        }else
        {
            CarStyle *aStyle = [self.dataArray objectAtIndex:indexPath.row - 1];
            
            cell.textLabel.text = aStyle.styleName;
            
        }
    }else
    {
        cell.textLabel.text = [self.dataArray objectAtIndex:indexPath.row];
    }
    
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataStyle == Data_Car_Brand) {
        
        NSString *letter = [firstLetterArray objectAtIndex:indexPath.section];
        
        NSArray *subArr = [brandDic objectForKey:letter];
        
        CarBrand *aBrand = [subArr objectAtIndex:indexPath.row];
        
        
        SendCarParamsController *base = [[SendCarParamsController alloc]init];
        base.hidesBottomBarWhenPushed = YES;
        base.navigationTitle = aBrand.brandName;
        base.dataStyle = Data_Car_Type;
        base.selectLabel = self.selectLabel;
        
        base.brandId = aBrand.brandId;
        
        base.rootVC = self.rootVC;
        
        [base selectParamBlock:^(DATASTYLE style, NSString *paramName, NSString *paramId) {
            
            selectBlock(style,paramName,paramId);
            
        }];
        
        [self.navigationController pushViewController:base animated:YES];
        
        
        
        return;
        
    }else if (self.dataStyle == Data_Car_Type) {
        
        if (indexPath.row == 0) {
            
            
            NSString *car = [NSString stringWithFormat:@"%@%@%@",self.brandId,@"000",@"000"];
            selectBlock(self.dataStyle,@"不限",car);
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }else
        {
            CarType *aType = [self.dataArray objectAtIndex:indexPath.row - 1];
            
            SendCarParamsController *base = [[SendCarParamsController alloc]init];
            base.hidesBottomBarWhenPushed = YES;
            base.navigationTitle = aType.typeName;
            base.dataStyle = Data_Car_Style;
            base.selectLabel = self.selectLabel;
            base.brandId = self.brandId;
            base.typeId = aType.typeId;
            base.rootVC = self.rootVC;
            
            [base selectParamBlock:^(DATASTYLE style, NSString *paramName, NSString *paramId) {
                
                selectBlock(style,paramName,paramId);
                
            }];
            
            [self.navigationController pushViewController:base animated:YES];
            
        }
        
        return;
        
    }else if (self.dataStyle == Data_Car_Style) {
        
        if (indexPath.row == 0) {
            
            
            NSString *car = [NSString stringWithFormat:@"%@%@%@",self.brandId,self.typeId,@"000"];
            selectBlock(self.dataStyle,@"不限",car);
            
        }else
        {
            CarStyle *aStyle = [self.dataArray objectAtIndex:indexPath.row - 1];
            
            NSString *car = [NSString stringWithFormat:@"%@%@%@",self.brandId,self.typeId,aStyle.styleId];
            selectBlock(self.dataStyle,aStyle.styleName,car);
        }
        
        if (self.rootVC) {
            [self.navigationController popToViewController:self.rootVC animated:YES];
        }else
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
        return;
        
    }
    
    NSString *select = [_dataArray objectAtIndex:indexPath.row];
    
    
    int row = self.haveLimit ? indexPath.row : indexPath.row + 1;
    
    selectBlock(self.dataStyle,select,[NSString stringWithFormat:@"%d",row]);
    
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
