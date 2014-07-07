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
#import "Statics.h"
#import "UIImageView+WebCache.h"


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
    
    UIButton *rightButton2 =[[UIButton alloc]initWithFrame:CGRectMake(0,8,30,21.5)];
    [rightButton2 addTarget:self action:@selector(clickToBack:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton2 setImage:[UIImage imageNamed:@"tianjia44_44"] forState:UIControlStateNormal];
    UIBarButtonItem *save_item2=[[UIBarButtonItem alloc]initWithCustomView:rightButton2];
    self.navigationItem.rightBarButtonItems = @[save_item,save_item2];
    
    self.table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.height - 44 - (iPhone5 ? 20 : 0) - 50) style:UITableViewStylePlain];
    _table.delegate = self;
    _table.dataSource = self;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_table];
    _table.decelerationRate = 0.8;
    
    messages = [NSMutableArray array];
    labelArr = [NSMutableArray array];
    rowHeights = [NSMutableArray array];
    
    [self testData];//测试数据
    
//    [self creatLabelArr];
    
    [self.table reloadData];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:messages.count - 1 inSection:0];;
    [self.table scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    
    [self createInputView];
}

- (void)testData
{
    NSDictionary *dic = @{MESSAGE_SENDER: @"张三",MESSAGE_MSG:@"发送的[大笑]消息有多长呢",MESSAGE_TIME:@"2014-07-04"};
    NSDictionary *dic1 = @{MESSAGE_SENDER: @"you",MESSAGE_MSG:@"发送的[抓狂]消息[抓狂]有多长呢",MESSAGE_TIME:@"2014-07-04"};
    NSDictionary *dic2 = @{MESSAGE_SENDER: @"张三",MESSAGE_MSG:@"发送呢",MESSAGE_TIME:@"2014-07-04"};
    NSDictionary *dic3 = @{MESSAGE_SENDER: @"you",MESSAGE_MSG:@"发送[bed凌乱][bed凌乱][bed凌乱][的消息有多长呢",MESSAGE_TIME:@"2014-07-04"};
    NSDictionary *dic4 = @{MESSAGE_SENDER: @"张三",MESSAGE_MSG:@"发送的的消的消息有的消息有的消息有的发送的消的消息有的消息有的消息有的消息有息有多长呢发送的消的消息有的消息有[抓狂]的消息有的消[大笑][大笑][多长呢发送的消的消息有的消息有的消息有的消息有息有多长呢发送的消的消息有的消息有的消息有的消息有息有多长呢发送的消的消多长呢",MESSAGE_TIME:@"2014-07-04"};
    
     NSString *test = @"<img height=\"195\" width=\"325\" src=\"http://www0.autoimg.cn/newspic/2013/12/22/620x0_0_2013122223315823282.jpg\"/>>";
    NSDictionary *dic5 = @{MESSAGE_SENDER: @"张三",MESSAGE_MSG:test,MESSAGE_TIME:@"2014-07-04"};
    
    NSDictionary *dic6 = @{MESSAGE_SENDER: @"you",MESSAGE_MSG:@"发送的消息有多长呢",MESSAGE_TIME:@"2014-07-04"};
    NSDictionary *dic7 = @{MESSAGE_SENDER: @"you",MESSAGE_MSG:@"发送的消的消息有的消息有的消息有的发送的消的消息有的消息有的消息有的消息有息有多长呢发送的消的消息有[抓狂]的消息有的消息有的消息有息有多长呢[抓狂]发送的消的消息有的消息有的消息有的消息有息有多长呢发送的消的消息有的消息有的消息有的消息有息有多长呢发送的消的消息有的消息有的消息有的消息有息有多长呢消息有息有多长呢",MESSAGE_TIME:@"2014-07-04"};
    
    
   NSString *test1 = @"<img height=\"195\" width=\"325\" src=\"http://c.hiphotos.baidu.com/image/pic/item/32fa828ba61ea8d3ef5adf65950a304e251f5852.jpg\"/>>";
    
    NSDictionary *dic8 = @{MESSAGE_SENDER: @"张三",MESSAGE_MSG:test1,MESSAGE_TIME:@"2014-07-04"};
    
    NSDictionary *dic9 = @{MESSAGE_SENDER: @"张三",MESSAGE_MSG:@"发送[抓狂]的消的消息有息有多长呢",MESSAGE_TIME:@"2014-07-04"};
    
    
    [messages addObjectsFromArray:@[dic,dic1,dic2,dic3,dic4,dic5,dic6,dic7,dic8,dic9]];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - mark 创建richLabel


/**
 *  根据发送的内容返回一个富文本label,并将label加入到label数组中
 *
 *  @param dic 消息字典
 *
 *  @return label
 */
- (CGFloat)createRichLabelWithMessage:(NSDictionary *)dic
{
//    MESSAGE_TYPE type = [[dic objectForKey:@"type"]integerValue];
    
    
    //本地发送 图片
    
    BOOL isLocal = [[dic objectForKey:MESSAGE_MESSAGE_LOCAL]boolValue];
    if (isLocal) { //图片
        
        UIImage *aImage = [dic objectForKey:MESSAGE_MSG];
        UIImageView *aImageView = [[UIImageView alloc]init];
        aImageView.image = aImage;
        [labelArr addObject:aImageView];
        
        //最多高度 200,最大宽度 200
        [Statics updateFrameForImageView:aImageView originalWidth:aImage.size.width originalHeight:aImage.size.height];
        
        NSNumber *heightNum = [[NSNumber alloc] initWithFloat:aImageView.height];
        [rowHeights addObject:heightNum];
        return [heightNum floatValue];
    }

    //网络获取 图片
    
    NSString *msg = [dic objectForKey:MESSAGE_MSG];
    
    NSString *url = [Statics imageUrl:msg] ;
    if (![url isEqualToString:@""]) {
        //是图片
        CGFloat width = [Statics imageValue:msg for:@"width"];
        CGFloat height = [Statics imageValue:msg for:@"height"];
        
        
        UIImageView *aImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
        [labelArr addObject:aImageView];
        
        [aImageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
        
        //最多高度 200,最大宽度 200
        [Statics updateFrameForImageView:aImageView originalWidth:width originalHeight:height];
        
        NSNumber *heightNum = [[NSNumber alloc] initWithFloat:aImageView.height];
        [rowHeights addObject:heightNum];
        return [heightNum floatValue];
        
    }
    
    
    OHAttributedLabel *label = [[OHAttributedLabel alloc] initWithFrame:CGRectZero];
    NSString *text = [dic objectForKey:MESSAGE_MSG];
    [self creatAttributedLabel:text Label:label];
    
    NSNumber *heightNum = [[NSNumber alloc] initWithFloat:label.frame.size.height];
    [labelArr addObject:label];
    [self drawImage:label];
    [rowHeights addObject:heightNum];
    
    return [heightNum floatValue];
}

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
    
    
    __block typeof(FBChatViewController *)weakSelf = self;
    [inputBar setToolBlock:^(int aTag) {
        
        switch (aTag) {
            case 0:
            {
                NSLog(@"打电话");
                
                NSString *num = [[NSString alloc] initWithFormat:@"tel://%@",@"18612389982"];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]];
                
            }
                break;
            case 1:
            {
                NSLog(@"拍照");
                [weakSelf clickToCamera:nil];
            }
                break;
            case 2:
            {
                NSLog(@"相册");
                [weakSelf clickToAlbum:nil];
                
            }
                break;
                
            default:
                break;
        }
        
    }];
    
    [self.view addSubview:inputBar];
    
    NSLog(@"-->%f",self.view.height);
}

#pragma - mark 本地发送信息处理

- (void)localSendMessage:(NSString *)message MessageType:(MESSAGE_TYPE)type image:(UIImage *)aImage
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    if (message) {
        [dictionary setObject:message forKey:@"msg"];
    }
    
    [dictionary setObject:@"you" forKey:@"sender"];
    //加入发送时间
    [dictionary setObject:[Statics getCurrentTime] forKey:@"time"];
    [dictionary setObject:[NSString stringWithFormat:@"%d",type] forKey:@"type"];
    
    if (aImage) {
        [dictionary setObject:aImage forKey:MESSAGE_MSG];
        [dictionary setObject:[NSNumber numberWithBool:YES] forKey:MESSAGE_MESSAGE_LOCAL];
    }
    
    [messages addObject:dictionary];
    
    //重新刷新tableView
    [self.table reloadData];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:messages.count - 1 inSection:0];;
    [self.table scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSMutableDictionary *dict = [messages objectAtIndex:indexPath.row];
    if (labelArr.count > indexPath.row && [labelArr objectAtIndex:indexPath.row]) {

    }else
    {
        //否则没有,需要新创建
        [self createRichLabelWithMessage:dict];
        
    }
    
    UIView *label = (UIView *)[labelArr objectAtIndex:indexPath.row];
    
    CGFloat labelHeight = [[rowHeights objectAtIndex:indexPath.row] floatValue];
    [cell loadDataWithDic:dict labelHeight:labelHeight OHLabel:label];
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath NS_AVAILABLE_IOS(6_0)
{
    KKMessageCell *aCell =(KKMessageCell *)cell;
    if (aCell.OHLabel) {
        [aCell.OHLabel removeFromSuperview];//防止重绘
    }
}

//每一行的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableDictionary *dict = [messages objectAtIndex:indexPath.row];
    if (rowHeights.count > indexPath.row && [rowHeights objectAtIndex:indexPath.row]) {
        
    }else
    {
        [self createRichLabelWithMessage:dict];
    }
    
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
    if (text) {
        [self localSendMessage:text MessageType:Message_Normal image:Nil];
    }
}

#pragma - mark 发送图片

//打开相册

- (IBAction)clickToAlbum:(id)sender {
    
    BOOL is =  [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
    if (is) {
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:^{
    }];
    }else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"不支持相册" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

//打开相机

- (IBAction)clickToCamera:(id)sender {
    
    BOOL is =  [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    if (is) {
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker animated:YES completion:^{
            
        }];
    }else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"不支持相机" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}
#pragma - mark imagePicker 代理

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:@"public.image"]) {
        
        //压缩图片 不展示原图
        UIImage *originImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        UIImage *scaleImage = [self scaleImage:originImage toScale:0.5];
        
        NSData *data;
        
        //以下这两步都是比较耗时的操作，最好开一个HUD提示用户，这样体验会好些，不至于阻塞界面
        if (UIImagePNGRepresentation(scaleImage) == nil) {
            //将图片转换为JPG格式的二进制数据
            data = UIImageJPEGRepresentation(scaleImage, 1);
        } else {
            //将图片转换为PNG格式的二进制数据
            data = UIImagePNGRepresentation(scaleImage);
        }
        
        //将二进制数据生成UIImage
        UIImage *image = [UIImage imageWithData:data];
        
        [self localSendMessage:Nil MessageType:Message_Image image:image];
        
        [picker dismissViewControllerAnimated:NO completion:^{
            
            
        }];
        
    }
}

#pragma - mark QBImagePicker 代理

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)aImagePickerController
{
    [aImagePickerController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark- 缩放图片

-(UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height *scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

@end
