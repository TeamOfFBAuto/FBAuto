//
//  FBChatViewController.m
//  FBAuto
//
//  Created by lichaowei on 14-7-4.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "FBChatViewController.h"
#import "CWInputView.h"
#import "KKMessageCell.h"

#import "FBChatHeader.h"

#import "NSAttributedString+Attributes.h"
#import "FBHelper.h"
#import "MarkupParser.h"
#import "OHAttributedLabel.h"
#import "SCGIFImageView.h"


@interface FBChatViewController ()<CWInputDelegate,OHAttributedLabelDelegate>
{
    CWInputView *inputBar;
    
    OHAttributedLabel *currentLabel;
    
    NSMutableArray *messages;//文本
    NSMutableArray *rowHeights;//所有高度
    NSDictionary *emojiDic;//所有表情
    NSMutableArray *labelArr;//所有label
}

@end


@implementation FBChatViewController

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
    self.titleLabel.text = @"somebody";
    
    UIButton *rightButton =[[UIButton alloc]initWithFrame:CGRectMake(0,8,30,21.5)];
    [rightButton addTarget:self action:@selector(clickToBack:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setImage:[UIImage imageNamed:@"shouye48_44"] forState:UIControlStateNormal];
    UIBarButtonItem *save_item=[[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = save_item;
    
    self.table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.height - 44 - (iPhone5 ? 20 : 0) - 50) style:UITableViewStylePlain];
    _table.delegate = self;
    _table.dataSource = self;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_table];
    
    messages = [NSMutableArray array];
    labelArr = [NSMutableArray array];
    rowHeights = [NSMutableArray array];
    
    NSDictionary *dic = @{MESSAGE_SENDER: @"张三",MESSAGE_MSG:@"发送的[大笑]消息有多长呢",MESSAGE_TIME:@"2014-07-04"};
    NSDictionary *dic1 = @{MESSAGE_SENDER: @"you",MESSAGE_MSG:@"发送的[抓狂]消息[抓狂]有多长呢",MESSAGE_TIME:@"2014-07-04"};
    NSDictionary *dic2 = @{MESSAGE_SENDER: @"张三",MESSAGE_MSG:@"发送呢",MESSAGE_TIME:@"2014-07-04"};
    NSDictionary *dic3 = @{MESSAGE_SENDER: @"you",MESSAGE_MSG:@"发送[bed凌乱][bed凌乱][bed凌乱][的消息有多长呢",MESSAGE_TIME:@"2014-07-04"};
    NSDictionary *dic4 = @{MESSAGE_SENDER: @"张三",MESSAGE_MSG:@"发送的的消的消息有的消息有的消息有的发送的消的消息有的消息有的消息有的消息有息有多长呢发送的消的消息有的消息有[抓狂]的消息有的消息有息有[bed凌乱][bed凌乱][bed凌乱][多长呢发送的消的消息有的消息有的消息有的消息有息有多长呢发送的消的消息有的消息有的消息有的消息有息有多长呢发送的消的消多长呢",MESSAGE_TIME:@"2014-07-04"};
    NSDictionary *dic5 = @{MESSAGE_SENDER: @"张三",MESSAGE_MSG:@"发送的消息有多长呢",MESSAGE_TIME:@"2014-07-04"};
    NSDictionary *dic6 = @{MESSAGE_SENDER: @"you",MESSAGE_MSG:@"发送的消息有多长呢",MESSAGE_TIME:@"2014-07-04"};
    NSDictionary *dic7 = @{MESSAGE_SENDER: @"you",MESSAGE_MSG:@"发送的消的消息有的消息有的消息有的发送的消的消息有的消息有的消息有的消息有息有多长呢发送的消的消息有[抓狂]的消息有的消息有的消息有息有多长呢[抓狂]发送的消的消息有的消息有的消息有的消息有息有多长呢发送的消的消息有的消息有的消息有的消息有息有多长呢发送的消的消息有的消息有的消息有的消息有息有多长呢消息有息有多长呢",MESSAGE_TIME:@"2014-07-04"};
    NSDictionary *dic8 = @{MESSAGE_SENDER: @"张三",MESSAGE_MSG:@"发送[抓狂]的消的消息有息有多长呢",MESSAGE_TIME:@"2014-07-04"};
    
    [messages addObjectsFromArray:@[dic,dic1,dic2,dic3,dic4,dic5,dic6,dic7,dic8]];
    
    [self creatLabelArr];
    
    [self.table reloadData];
    
    [self createInputView];
}

#pragma - mark 创建richLabel

- (void)creatLabelArr
{
    for (int i = 0; i < [messages count]; i++) {
        OHAttributedLabel *label = [[OHAttributedLabel alloc] initWithFrame:CGRectZero];
        NSString *text = [[messages objectAtIndex:i]objectForKey:MESSAGE_MSG];
        [self creatAttributedLabel:text Label:label];
        NSNumber *heightNum = [[NSNumber alloc] initWithFloat:label.frame.size.height];
        [labelArr addObject:label];
        [self drawImage:label];
        [rowHeights addObject:heightNum];
    }
}

- (void)creatAttributedLabel:(NSString *)o_text Label:(OHAttributedLabel *)label
{
    [label setNeedsDisplay];
    NSMutableArray *httpArr = [FBHelper addHttpArr:o_text];
    NSMutableArray *phoneNumArr = [FBHelper addPhoneNumArr:o_text];
    
    NSString *text = [FBHelper transformString:o_text];
    text = [NSString stringWithFormat:@"<font color='black' strokeColor='gray' face='Palatino-Roman'>%@",text];
    
    MarkupParser* p = [[MarkupParser alloc] init];
    NSMutableAttributedString* attString = [p attrStringFromMarkup: text];
    [attString setFont:[UIFont systemFontOfSize:16]];
    label.backgroundColor = [UIColor clearColor];
    [label setAttString:attString withImages:p.images];
    
    NSString *string = attString.string;
    
    if ([phoneNumArr count]) {
        for (NSString *phoneNum in phoneNumArr) {
            [label addCustomLink:[NSURL URLWithString:phoneNum] inRange:[string rangeOfString:phoneNum]];
        }
    }
    
    if ([httpArr count]) {
        for (NSString *httpStr in httpArr) {
            [label addCustomLink:[NSURL URLWithString:httpStr] inRange:[string rangeOfString:httpStr]];
        }
    }
    
    label.delegate = self;
    CGRect labelRect = label.frame;
    labelRect.size.width = [label sizeThatFits:CGSizeMake(200, CGFLOAT_MAX)].width;
    labelRect.size.height = [label sizeThatFits:CGSizeMake(200, CGFLOAT_MAX)].height;
    label.frame = labelRect;
    //    label.onlyCatchTouchesOnLinks = NO;
    label.underlineLinks = YES;//链接是否带下划线
    [label.layer display];
    // 调用这个方法立即触发label的|drawTextInRect:|方法，
    // |setNeedsDisplay|方法有滞后，因为这个需要画面稳定后才调用|drawTextInRect:|方法
    // 这里我们创建的时候就需要调用|drawTextInRect:|方法，所以用|display|方法，这个我找了很久才发现的
}

- (void)drawImage:(OHAttributedLabel *)label
{
    for (NSArray *info in label.imageInfoArr) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:[info objectAtIndex:0] ofType:nil];
        NSData *data = [[NSData alloc] initWithContentsOfFile:filePath];
        SCGIFImageView *imageView = [[SCGIFImageView alloc] initWithGIFData:data];
        imageView.frame = CGRectFromString([info objectAtIndex:2]);
        [label addSubview:imageView];//label内添加图片层
        [label bringSubviewToFront:imageView];
    }
}

#pragma - mark OHAttributedLabelDelegate

-(BOOL)attributedLabel:(OHAttributedLabel*)attributedLabel shouldFollowLink:(NSTextCheckingResult*)linkInfo
{
    NSString *requestString = [linkInfo.URL absoluteString];
    NSLog(@"%@",requestString);
    if ([[UIApplication sharedApplication]canOpenURL:linkInfo.URL]) {
        [[UIApplication sharedApplication]openURL:linkInfo.URL];
    }
    return NO;
}


#pragma - mark 创建输入框

- (void)createInputView
{
    //键盘
    inputBar = [[CWInputView alloc]initWithFrame:CGRectMake(0, self.view.height - 50 - (iPhone5 ? 20 : 0) - 44, 320, 50)];
    inputBar.delegate = self;
    inputBar.clearInputWhenSend = YES;
    inputBar.resignFirstResponderWhenSend = YES;
    
    [self.view addSubview:inputBar];
    
    NSLog(@"-->%f",self.view.height);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - mark UITableView 代理

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [messages count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"msgCell";
    
    KKMessageCell *cell =(KKMessageCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[KKMessageCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    
    
    [cell.OHLabel removeFromSuperview];//防止重绘
    
    NSMutableDictionary *dict = [messages objectAtIndex:indexPath.row];
    
    CGFloat labelHeight = [[rowHeights objectAtIndex:indexPath.row] floatValue];
    
    OHAttributedLabel *label = (OHAttributedLabel *)[labelArr objectAtIndex:indexPath.row];
    
    [cell loadDataWithDic:dict labelHeight:labelHeight OHLabel:label];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

//每一行的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat labelHeight = [[rowHeights objectAtIndex:indexPath.row] floatValue] + 20 + 20 + 20;
    
    return labelHeight;
    
}

#pragma - mark UIScrollView 代理 (控制gif动画)

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    NSNotification *notification = [NSNotification notificationWithName:@"ChangeStart" object:[NSNumber numberWithBool:NO]];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSNotification *notification = [NSNotification notificationWithName:@"ChangeStart" object:[NSNumber numberWithBool:YES]];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

#pragma - mark CWInputDelegate

- (void)inputView:(CWInputView *)inputView sendBtn:(UIButton*)sendBtn inputText:(NSString*)text
{
    NSLog(@"text %@",text);
    
//    //本地输入框中的信息
//    NSString *message = inputBar.textView.text;
//    
//    if (message.length > 0) {
//        
//        [self sendMessage:message isGroup:chatStyle];
//        
//        [self localSendMessage:message];
//    }
}

@end
