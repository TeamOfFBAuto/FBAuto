//
//  FindCarPublishController.m
//  FBAuto
//
//  Created by lichaowei on 14-7-19.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "FindCarPublishController.h"
#import "SendCarParamsController.h"
#import "Section_Button.h"
#import "Menu_Header.h"
#import "FBCityData.h"
#import "FBFindCarDetailController.h"
#import "DXAlertView.h"

@interface FindCarPublishController ()<UITextFieldDelegate>
{
    MBProgressHUD *loadingHub;
    UIScrollView *bigBgScroll;//背景scroll
    UIButton *publish;
    
    //车源列表参数
    NSString *_car;//  车型id
    NSString *_price;// 价格
    int _spot_future;// 现货或者期货id
    int _color_out;// 外观颜色id
    int _color_in;// 内饰颜色id
    int _carfrom;// 汽车规格id（美规，中规）
    int _deposit;//定金
    int _province;
    int _city;
    NSString *_cardiscrib;// 车源描述
    UITextField *descriptionTF;
}

@end

@implementation FindCarPublishController

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
    
    bigBgScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.height - 44 - 20)];
    bigBgScroll.backgroundColor = [UIColor whiteColor];
    bigBgScroll.showsHorizontalScrollIndicator = NO;
    bigBgScroll.showsVerticalScrollIndicator = NO;
    [self.view addSubview:bigBgScroll];
    
    [self createSection];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickToHideKeyboard)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    
    loadingHub = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:loadingHub];
	loadingHub.labelText = @"发布中...";
    
    _spot_future = 0;// 现货或者期货id
    _color_out = 0;// 外观颜色id
    _color_in = 0;// 内饰颜色id
    _carfrom = 0;// 汽车规格id（美规，中规）
    _deposit = 0;//定金
    
    if (self.actionStyle == Find_Action_Add) {
        self.titleLabel.text = @"发布寻车";
    }else if (self.actionStyle == Find_Action_Edit){
        self.titleLabel.text = @"修改寻车";
        
        [self getSingleCarInfoWithId:self.infoId];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - mark 条件选择部分

- (void)createSection
{
    UILabel *firstLabel = [self createLabelFrame:CGRectMake(10, 0, 300, 45) text:@"必填" alignMent:NSTextAlignmentLeft textColor:[UIColor colorWithHexString:@"818181"]];
    [bigBgScroll addSubview:firstLabel];
    
    UIView *firstBgView = [[UIView alloc]initWithFrame:CGRectMake(10, firstLabel.bottom, 320 - 20, 45 * 2)];
    firstBgView.backgroundColor = [UIColor clearColor];
    firstBgView.layer.borderWidth = 1.0;
    firstBgView.layer.borderColor = [UIColor colorWithHexString:@"b4b4b4"].CGColor;
    [bigBgScroll addSubview:firstBgView];
    
    UILabel *secondLabel = [self createLabelFrame:CGRectMake(10, firstBgView.bottom, 300, 45) text:@"选填" alignMent:NSTextAlignmentLeft textColor:[UIColor colorWithHexString:@"818181"]];
    [bigBgScroll addSubview:secondLabel];
    
    UIView *secondBgView = [[UIView alloc]initWithFrame:CGRectMake(10, secondLabel.bottom, 320 - 20, 45 * 6)];
    secondBgView.backgroundColor = [UIColor clearColor];
    secondBgView.layer.borderWidth = 1.0;
    secondBgView.layer.borderColor = [UIColor colorWithHexString:@"b4b4b4"].CGColor;
    [bigBgScroll addSubview:secondBgView];
    
    NSArray *titles1 = @[@"地区",@"车型"];
    for (int i = 0; i < titles1.count; i ++) {
        Section_Button *btn = [[Section_Button alloc]initWithFrame:CGRectMake(0, 45 * i, secondBgView.width, 45) title:[titles1 objectAtIndex:i] target:self action:@selector(clickToParams:) sectionStyle:Section_Normal image:nil];
        btn.tag = 100 + i;
        [firstBgView addSubview:btn];
    }
    
    NSArray *titles2 = @[@"规格",@"期现",@"外观色",@"内饰色",@"定金"];
    for (int i = 0; i < titles2.count; i ++) {
        Section_Button *btn = [[Section_Button alloc]initWithFrame:CGRectMake(0, 45 * i, secondBgView.width, 45) title:[titles2 objectAtIndex:i] target:self action:@selector(clickToParams:) sectionStyle:Section_Normal image:nil];
        btn.tag = 100 + i + 2;
        btn.contentLabel.text = @"不限";
        [secondBgView addSubview:btn];
    }
    
    //车源描述，需要输入
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 45*5, 300, 0.5)];
    line2.backgroundColor = [UIColor colorWithHexString:@"b4b4b4"];
    [secondBgView addSubview:line2];
    
    [secondBgView addSubview:[self createLabelFrame:CGRectMake(10, 45*5, 100, 45.f) text:@"寻车描述" alignMent:NSTextAlignmentLeft textColor:[UIColor blackColor]]];
    
    descriptionTF = [[UITextField alloc]initWithFrame:CGRectMake(80 - 10, 45 * 5, 175, 45)];
    descriptionTF.delegate = self;
    descriptionTF.backgroundColor = [UIColor clearColor];
    [secondBgView addSubview:descriptionTF];
    
    
    //发布按钮
    
    publish = [UIButton buttonWithType:UIButtonTypeCustom];
    publish.frame = CGRectMake(10, secondBgView.bottom + 16, 300, 50);
    [publish setTitle:@"发布" forState:UIControlStateNormal];
    [publish setBackgroundImage:[UIImage imageNamed:@"huquyanzhengma_kedianji600_100"] forState:UIControlStateNormal];
    [publish addTarget:self action:@selector(clickToPublish:) forControlEvents:UIControlEventTouchUpInside];
    [bigBgScroll addSubview:publish];
    
    bigBgScroll.contentSize = CGSizeMake(320, firstBgView.height + secondBgView.height + publish.height + 400);
}

- (UILabel *)createLabelFrame:(CGRect)aFrame text:(NSString *)text alignMent:(NSTextAlignment)align textColor:(UIColor *)color
{
    UILabel *priceLabel = [[UILabel alloc]initWithFrame:aFrame];
    priceLabel.backgroundColor = [UIColor clearColor];
    priceLabel.text = text;
    priceLabel.textAlignment = align;
    priceLabel.font = [UIFont systemFontOfSize:14];
    priceLabel.textColor = color;
    return priceLabel;
}


#pragma - mark 价格输入框

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    [UIView animateWithDuration:0.5 animations:^{
        
        bigBgScroll.contentOffset = CGPointMake(0, iPhone5 ? 251 : 400);
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.5 animations:^{
        
        bigBgScroll.contentOffset = CGPointMake(0, 0);
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [descriptionTF resignFirstResponder];
    return YES;
}

- (void)clickToHideKeyboard
{
    [descriptionTF resignFirstResponder];
}


#pragma - mark 进入发布车源参数页面

- (void)clickToParams:(Section_Button *)btn
{
    DATASTYLE aStyle = 0;
    NSString *title = @"";
    
    switch (btn.tag) {
        case 100:
        {
            aStyle = Data_Area;
            title = @"地区";
        }
            break;
        case 101:
        {
            aStyle = Data_Car_Brand;
            title = @"车型";
        }
            break;
        case 102:
        {
            aStyle = Data_Standard;
            title = @"规格";
        }
            break;
        case 103:
        {
            aStyle = Data_Timelimit;
            title = @"期限";
        }
            break;
        case 104:
        {
            aStyle = Data_Color_Out;
            title = @"外观颜色";
        }
            break;
        case 105:
        {
            aStyle = Data_Color_In;
            title = @"内饰颜色";
        }
            break;
        case 106:
        {
            aStyle = Data_Money;
            title = @"定金";
        }
            break;
            
        default:
            break;
    }
    
    SendCarParamsController *base = [[SendCarParamsController alloc]init];
    base.hidesBottomBarWhenPushed = YES;
    base.navigationTitle = title;
    base.dataStyle = aStyle;
    base.selectLabel = btn.contentLabel;
    base.rootVC = self;
    base.haveLimit = YES;
    
    [base selectParamBlock:^(DATASTYLE style, NSString *paramName, NSString *paramId) {
        NSLog(@"paramName %@ %@",paramName,paramId);
        
        btn.contentLabel.text = paramName;
        
        switch (style) {
            case Data_Car_Brand:
            case Data_Car_Type:
            case Data_Car_Style:
            {
                _car = paramId;
            }
                break;
            case Data_Standard:
            {
                _carfrom = [paramId intValue];
            }
                break;
            case Data_Timelimit:
            {
                _spot_future = [paramId intValue];
            }
                break;
            case Data_Color_Out:
            {
                _color_out = [paramId intValue];
            }
                break;
            case Data_Color_In:
            {
                _color_in = [paramId intValue];
            }
                break;
            case Data_Area:
            case Data_Area_City:
            {
                NSArray *params = [paramId componentsSeparatedByString:@","];
                
                _province = [[params objectAtIndex:0]intValue];
                _city = [[params objectAtIndex:1]intValue];
            }
                break;
            case Data_Money:
            {
                _deposit = [paramId intValue];
            }
                break;
            default:
                break;
        }
        
        
    }];
    
    [self.navigationController pushViewController:base animated:YES];
}

/**
 *  寻车信息页
 */
- (void)clickToDetail:(NSString *)info
{
    FBFindCarDetailController *detail = [[FBFindCarDetailController alloc]init];
    detail.style = Navigation_Special;
    detail.navigationTitle = @"详情";
    detail.infoId = info;
    detail.carId = _car;
    detail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma - mark 发布车源

- (void)clickToPublish:(UIButton *)btn
{
    Section_Button *btn1 = (Section_Button *)[bigBgScroll viewWithTag:100];
    if (btn1.contentLabel.text == nil || [btn1.contentLabel.text isEqualToString:@""]) {
        [self alertText:@"请选择地区"];
        return;
    }
    
    Section_Button *btn2 = (Section_Button *)[bigBgScroll viewWithTag:101];
    if (btn2.contentLabel.text == nil || [btn2.contentLabel.text isEqualToString:@""]) {
        [self alertText:@"请选择车型"];
        return;
    }
    
    [self publishCarSource];
        
}

- (void)alertText:(NSString *)text
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:text delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

#pragma - mark 网络请求--发布寻车信息

#pragma - mark 发布车源

- (void)publishCarSource
{
    
    NSString *descrip = descriptionTF.text;
    descrip = descrip ? descrip : @"无";
    NSString *url = @"";
    
    NSLog(@"发布列表 %@",url);
    
    if (self.actionStyle == Find_Action_Add) {
        
        url = [NSString stringWithFormat:
               @"%@&authkey=%@&province=%d&city=%d&car=%@&spot_future=%d&color_out=%d&color_in=%d&deposit=%d&carfrom=%d&cardiscrib=%@",FBAUTO_FINDCAR_PUBLISH,[GMAPI getAuthkey],_province,_city,_car,_spot_future,_color_out,_color_in,_deposit,_carfrom,descrip];
        
    }else if (self.actionStyle == Find_Action_Edit) {
        
        url = [NSString stringWithFormat:
               @"%@&authkey=%@&xid=%@&province=%d&city=%d&car=%@&spot_future=%d&color_out=%d&color_in=%d&deposit=%d&carfrom=%d&cardiscrib=%@",FBAUTO_FINDCAR_EDIT,[GMAPI getAuthkey],self.infoId,_province,_city,_car,_spot_future,_color_out,_color_in,_deposit,_carfrom,descrip];
    }
    
    __weak typeof(self)weakSelf = self;
    
    LCWTools *tool = [[LCWTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"寻车发布 result %@, erro%@",result,[result objectForKey:@"errinfo"]);
        
        [loadingHub hide:NO];
        
//        [LCWTools showMBProgressWithText:[result objectForKey:@"errinfo"] addToView:weakSelf.view];
        [weakSelf refreshUI];
        
        
        DXAlertView *alert = [[DXAlertView alloc]initWithTitle:@"寻车发布成功" contentText:nil leftButtonTitle:nil rightButtonTitle:@"确定" isInput:NO];
        [alert show];
        
        alert.rightBlock = ^(){
            NSLog(@"取消");
            
            int infoId = [[result objectForKey:@"datainfo"]integerValue];
            
            [weakSelf clickToDetail:[NSString stringWithFormat:@"%d",infoId]];
            
        };
        
        
    }failBlock:^(NSDictionary *failDic, NSError *erro) {
        [LCWTools showMBProgressWithText:[failDic objectForKey:ERROR_INFO] addToView:weakSelf.view];
    }];
    
}


#pragma - mark 网络请求 获取单个寻车信息

- (void)getSingleCarInfoWithId:(NSString *)carId
{
    NSString *url = [NSString stringWithFormat:FBAUTO_FINDCAR_SINGLE,carId];
    
    NSLog(@"单个寻车信息 %@",url);
    
    LCWTools *tool = [[LCWTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"单个寻车 result %@, erro%@",result,[result objectForKey:@"errinfo"]);
        
        NSArray *dataInfo = [result objectForKey:@"datainfo"];
        
        if (dataInfo.count == 0) {
            return ;
        }
        
        NSDictionary *dic = [dataInfo objectAtIndex:0];
        
        //        //参数
        [self labelWithTag:101].text = [dic objectForKey:@"car_name"];
        
        _car = [dic objectForKey:@"car"];
        
        [self labelWithTag:100].text  =[self showForText:[NSString stringWithFormat:@"%@%@",[dic objectForKey:@"province"],[dic objectForKey:@"city"]]] ;
        
        _province = [FBCityData cityIdForName:[dic objectForKey:@"province"]];
        _city = [FBCityData cityIdForName:[dic objectForKey:@"city"]];
        
        
        [self labelWithTag:100 + 2].text  = [self showForText:[dic objectForKey:@"carfrom"]];
        _carfrom = (int)[MENU_STANDARD indexOfObject:[dic objectForKey:@"carfrom"]];
        
        [self labelWithTag:101 + 2].text  = [self showForText:[dic objectForKey:@"spot_future"]];
        _spot_future = (int)[MENU_TIMELIMIT indexOfObject:[dic objectForKey:@"spot_future"]];
        
        [self labelWithTag:102 + 2].text  = [self showForText:[dic objectForKey:@"color_out"]];
        _color_out = (int)[MENU_HIGHT_OUTSIDE_CORLOR indexOfObject:[dic objectForKey:@"color_out"]];
        
        [self labelWithTag:103 + 2].text  = [self showForText:[dic objectForKey:@"color_in"]];
        _color_in = (int)[MENU_HIGHT_INSIDE_CORLOR indexOfObject:[dic objectForKey:@"color_in"]];
        
        [self labelWithTag:104 + 2].text  = [self depositWithText:[dic objectForKey:@"deposit"]];
        _deposit = [[dic objectForKey:@"deposit"]intValue];
        
        descriptionTF.text = [[dic objectForKey:@"cardiscrib"] isEqualToString:@""] ? @"无" : [dic objectForKey:@"cardiscrib"];
        
        descriptionTF.text = [dic objectForKey:@"cardiscrib"];
        
        
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        NSLog(@"failDic %@",failDic);
        [LCWTools showMBProgressWithText:[failDic objectForKey:ERROR_INFO] addToView:self.view];
    }];
}

- (void)refreshUI
{
    for (int i = 0; i < 5; i ++) {
        Section_Button *btn = (Section_Button *)[bigBgScroll viewWithTag:100 + i + 2];
        btn.contentLabel.text = @"不限";
    }
}


- (NSString *)showForText:(NSString *)text
{
    if ([text isEqualToString:@""]) {
        
        text = @"不限";
    }
    return text;
}

- (UILabel *)labelWithTag:(int)aTag
{
    Section_Button *btn = (Section_Button *)[self.view viewWithTag:aTag];
    return btn.contentLabel;
}

- (NSString *)depositWithText:(NSString *)text
{
    if ([text isEqualToString:@"1"]) {
        text = @"定金已付";
    }else if ([text isEqualToString:@"2"])
    {
        text = @"定金未支付";
    }else if ([text isEqualToString:@"0"] || [text isEqualToString:@""])
    {
        text = @"定金不限";
    }
    return text;
}

@end
