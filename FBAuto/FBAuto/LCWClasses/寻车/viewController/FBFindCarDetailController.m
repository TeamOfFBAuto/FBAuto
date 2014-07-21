//
//  FBFindCarDetailController.m
//  FBAuto
//
//  Created by lichaowei on 14-7-21.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "FBFindCarDetailController.h"
#import "FBChatViewController.h"
#import "GyhzyViewController.h"

@interface FBFindCarDetailController ()

@end

@implementation FBFindCarDetailController

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
    // Do any additional setup after loading the view from its nib.
    
    CGRect thirdFrame = self.bottomBgView.frame;
    thirdFrame.origin.y = self.view.bottom - 75 - 44 - (iPhone5 ? 20 : 0);
    self.bottomBgView.frame = thirdFrame;
    
    [self createViews];
    
    [self getSingleCarInfoWithId:self.infoId];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - mark 网络请求 获取单个寻车信息

- (void)getSingleCarInfoWithId:(NSString *)carId
{
    NSString *url = [NSString stringWithFormat:FBAUTO_FINDCAR_SINGLE,carId];
    
    NSLog(@"单个车源信息 %@",url);
    
    LCWTools *tool = [[LCWTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"单个车源发布 result %@, erro%@",result,[result objectForKey:@"errinfo"]);
        
        NSArray *dataInfo = [result objectForKey:@"datainfo"];
        
        if (dataInfo.count == 0) {
            return ;
        }
        
        NSDictionary *dic = [dataInfo objectAtIndex:0];
        
//        //参数
        [self labelWithTag:108].text = [dic objectForKey:@"car_name"];
        [self labelWithTag:109].text  =[self showForText:[NSString stringWithFormat:@"%@%@",[dic objectForKey:@"province"],[dic objectForKey:@"city"]]] ;
        [self labelWithTag:110].text  = [self showForText:[dic objectForKey:@"carfrom"]];
        [self labelWithTag:111].text  = [self showForText:[dic objectForKey:@"spot_future"]];
        [self labelWithTag:112].text  = [self showForText:[dic objectForKey:@"color_out"]];
        [self labelWithTag:113].text  = [self showForText:[dic objectForKey:@"color_in"]];
        [self labelWithTag:114].text  = [self depositWithText:[dic objectForKey:@"deposit"]];
        [self labelWithTag:115].text  = [[dic objectForKey:@"cardiscrib"] isEqualToString:@""] ? @"无" : [dic objectForKey:@"cardiscrib"];
        
        //商家信息
        
        self.nameLabel.text = [dic objectForKey:@"username"];
        self.saleTypeBtn.titleLabel.text = [dic objectForKey:@"usertype"];//商家类型
        self.phoneNumLabel.text = [dic objectForKey:@"phone"];
        self.addressLabel.text = [NSString stringWithFormat:@"%@%@",[dic objectForKey:@"province"],[dic objectForKey:@"city"]];
        
        [self.headImage sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"headimage"]] placeholderImage:[UIImage imageNamed:@"detail_test"]];
        
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        NSLog(@"failDic %@",failDic);
        [LCWTools showMBProgressWithText:[failDic objectForKey:ERROR_INFO] addToView:self.view];
    }];
}

- (NSString *)showForText:(NSString *)text
{
    if ([text isEqualToString:@""]) {
        
        text = @"不限";
    }
    return text;
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

#pragma - mark 创建详情视图

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

- (void)createViews
{
    NSArray *items = @[@"车       型:",@"地       区:",@"规       格:",@"期       限:",@"外  观 色:",@"内  饰 色:",@"定       金:",@"详细描述:"];
    for (int i = 0; i < items.count; i ++) {
        UILabel *aLabel = [self createLabelFrame:CGRectMake(10, 25 + (20 + 15) * i, 92, 20) text:[items objectAtIndex:i] alignMent:NSTextAlignmentLeft textColor:[UIColor blackColor]];
        aLabel.font = [UIFont boldSystemFontOfSize:14];
        [self.view addSubview:aLabel];
        aLabel.tag = 100 + i;
    }
    for (int i = (int)items.count; i < items.count * 2; i ++) {
        UILabel *aLabel = [self createLabelFrame:CGRectMake(92, 25 + (20 + 15) * (i - items.count), 200, 20) text:@"" alignMent:NSTextAlignmentLeft textColor:[UIColor grayColor]];
        [self.view addSubview:aLabel];
        aLabel.tag = 100 + i;

    }
}

- (UILabel *)labelWithTag:(int)aTag
{
    return (UILabel *)[self.view viewWithTag:aTag];
}

#pragma - mark 点击事件

- (IBAction)clickToDial:(id)sender {
    
    NSString *num = [[NSString alloc] initWithFormat:@"tel://%@",self.phoneNumLabel.text];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]];
}
- (IBAction)clickToChat:(id)sender {
    
    if ([self.phoneNumLabel.text isEqualToString:[[NSUserDefaults standardUserDefaults]stringForKey:XMPP_USERID]]) {
        
        [LCWTools alertText:@"本人发布信息"];
        return;
    }
    
    FBChatViewController *chat = [[FBChatViewController alloc]init];
    chat.chatWithUser = self.phoneNumLabel.text;
    
    [self.navigationController pushViewController:chat animated:YES];
    
}

- (IBAction)clickToPersonal:(id)sender {
    
    GyhzyViewController *personal = [[GyhzyViewController alloc]init];
    personal.title = self.nameLabel.text;
    [self.navigationController pushViewController:personal animated:YES];
}

//收藏
- (void)clickToCollect:(UIButton *)sender
{
    NSLog(@"收藏");
    
    // ‘1’ 车源收藏 ‘2’ 寻车收藏
    NSString *url = [NSString stringWithFormat:FBAUTO_COLLECTION,[GMAPI getAuthkey],self.carId,2,self.infoId];
    
    NSLog(@"添加收藏 %@",url);
    
    LCWTools *tool = [[LCWTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"添加收藏 result %@, erro%@",result,[result objectForKey:@"errinfo"]);
        
        [LCWTools showMBProgressWithText:[result objectForKey:@"errinfo"] addToView:self.view];
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        NSLog(@"failDic %@",failDic);
        [LCWTools showMBProgressWithText:[failDic objectForKey:ERROR_INFO] addToView:self.view];
    }];
    
    
}

//分享
- (void)clickToShare:(UIButton *)sender
{
    NSLog(@"分享");
}


@end
