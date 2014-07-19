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

@interface FindCarPublishController ()
{
    UIScrollView *bigBgScroll;//背景scroll
    UIButton *publish;
    
    //车源列表参数
    NSString *_car;//  车型id
    NSString *_price;// 价格
    int _spot_future;// 现货或者期货id
    int _color_out;// 外观颜色id
    int _color_in;// 内饰颜色id
    int _carfrom;// 汽车规格id（美规，中规）
    NSString *_cardiscrib;// 车源描述
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
    
    self.titleLabel.text = @"发布寻车";
    
    bigBgScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.height - 44 - 20)];
    bigBgScroll.backgroundColor = [UIColor whiteColor];
    bigBgScroll.showsHorizontalScrollIndicator = NO;
    bigBgScroll.showsVerticalScrollIndicator = NO;
//    bigBgScroll.delegate = self;
    [self.view addSubview:bigBgScroll];
    
    [self createSection];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - mark 条件选择部分

- (void)createSection
{
    UILabel *firstLabel = [self createLabelFrame:CGRectMake(10, 25, 300, 45) text:@"必填" alignMent:NSTextAlignmentLeft textColor:[UIColor colorWithHexString:@"818181"]];
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
    
    NSArray *titles = @[@"车型",@"规格",@"期现",@"外观颜色",@"内饰颜色"];
    for (int i = 0; i < 5; i ++) {
        Section_Button *btn = [[Section_Button alloc]initWithFrame:CGRectMake(0, 45 * i, secondBgView.width, 45) title:[titles objectAtIndex:i] target:self action:@selector(clickToParams:) sectionStyle:Section_Normal image:nil];
        btn.tag = 100 + i;
        [secondBgView addSubview:btn];
    }
    
//    //价格特殊处理，需要输入
//    
//    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 45*5, 300, 0.5)];
//    line1.backgroundColor = [UIColor colorWithHexString:@"b4b4b4"];
//    [secondBgView addSubview:line1];
//    
//    [secondBgView addSubview:[self createLabelFrame:CGRectMake(10, 45*5, 100, 45.f) text:@"价格" alignMent:NSTextAlignmentLeft textColor:[UIColor blackColor]]];
//    
//    priceTF = [[UITextField alloc]initWithFrame:CGRectMake(80 - 10, 45 * 5, 175, 45)];
//    priceTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
//    priceTF.delegate = self;
//    priceTF.backgroundColor = [UIColor clearColor];
//    [secondBgView addSubview:priceTF];
//    
//    [secondBgView addSubview:[self createLabelFrame:CGRectMake(300 - 35 - 10, 45 * 5, 35, 45.f) text:@"万元" alignMent:NSTextAlignmentRight textColor:[UIColor colorWithHexString:@"c7c7cc"]]];
//    
//    //车源描述，需要输入
//    
//    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 45*6, 300, 1)];
//    line2.backgroundColor = [UIColor colorWithHexString:@"b4b4b4"];
//    [secondBgView addSubview:line2];
//    
//    [secondBgView addSubview:[self createLabelFrame:CGRectMake(10, 45*6, 100, 45.f) text:@"车源描述" alignMent:NSTextAlignmentLeft textColor:[UIColor blackColor]]];
//    
//    descriptionTF = [[UITextField alloc]initWithFrame:CGRectMake(80 - 10, 45 * 6, 175, 45)];
//    descriptionTF.delegate = self;
//    descriptionTF.backgroundColor = [UIColor clearColor];
//    [secondBgView addSubview:descriptionTF];
    
    
    //发布按钮
    
    publish = [UIButton buttonWithType:UIButtonTypeCustom];
    publish.frame = CGRectMake(10, secondBgView.bottom + 16, 300, 50);
    [publish setTitle:@"发布" forState:UIControlStateNormal];
    [publish setBackgroundImage:[UIImage imageNamed:@"huquyanzhengma_kedianji600_100"] forState:UIControlStateNormal];
    [publish addTarget:self action:@selector(clickToPublish:) forControlEvents:UIControlEventTouchUpInside];
    [bigBgScroll addSubview:publish];
    
    bigBgScroll.contentSize = CGSizeMake(320, firstBgView.height + secondBgView.height + 16 + publish.height + 10);
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



#pragma - mark 进入发布车源参数页面

- (void)clickToParams:(Section_Button *)btn
{
    DATASTYLE aStyle = 0;
    NSString *title = @"";
    
    switch (btn.tag) {
        case 100:
        {
            aStyle = Data_Car_Brand;
            title = @"车型";
        }
            break;
        case 101:
        {
            aStyle = Data_Standard;
            title = @"规格";
        }
            break;
        case 102:
        {
            aStyle = Data_Timelimit;
            title = @"期限";
        }
            break;
        case 103:
        {
            aStyle = Data_Color_Out;
            title = @"外观颜色";
        }
            break;
        case 104:
        {
            aStyle = Data_Color_In;
            title = @"内饰颜色";
        }
            break;
        case 105:
        {
            aStyle = Data_Price;
            title = @"价格";
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
                
            default:
                break;
        }
        
        
    }];
    
    [self.navigationController pushViewController:base animated:YES];
}

#pragma - mark 发布车源

- (void)clickToPublish:(UIButton *)btn
{
//    if (photosArray.count <= 0)
//    {
//        [self alertText:@"图片不能为空"];
//        
//        return;
//    }
//    
//    Section_Button *btn1 = (Section_Button *)[secondBgView viewWithTag:100];
//    
//    if (btn1.contentLabel.text == nil || [btn1.contentLabel.text isEqualToString:@""])
//    {
//        [self alertText:@"请选择车型"];
//        
//        return;
//    }
//    
//    for (int i = 0; i < 5; i ++) {
//        
//        Section_Button *btn1 = (Section_Button *)[secondBgView viewWithTag:100 + i];
//        
//        if (btn1.contentLabel.text == nil || [btn1.contentLabel.text isEqualToString:@""])
//        {
//            if (i == 0) {
//                
//                [self alertText:@"请选择车型"];
//                
//            }else if (i == 1)
//            {
//                [self alertText:@"请选择规格"];
//                
//            }else if (i == 2)
//            {
//                [self alertText:@"请选择期限"];
//                
//            }else if (i == 3)
//            {
//                [self alertText:@"请选择外观颜色"];
//                
//            }else if (i == 4)
//            {
//                [self alertText:@"请选择内饰颜色"];
//            }
//            
//            return;
//        }
//    }
    
}


- (void)alertText:(NSString *)text
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:text delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

@end
