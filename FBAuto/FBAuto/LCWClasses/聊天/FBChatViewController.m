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
#import "XMPPStatics.h"
#import "UIImageView+WebCache.h"
#import "FBAddFriendsController.h"

#import "XMPPServer.h"
#import "SJAvatarBrowser.h"
#import "FBChatImage.h"

#define MESSAGE_PAGE_SIZE 10


@interface FBChatViewController ()<CWInputDelegate,OHAttributedLabelDelegate,chatDelegate,messageDelegate,UIGestureRecognizerDelegate,EGORefreshTableDelegate,UIScrollViewDelegate>
{
    CWInputView *inputBar;
    
    OHAttributedLabel *currentLabel;
    
    NSMutableArray *messages;//文本
    NSMutableArray *rowHeights;//所有高度
    NSDictionary *emojiDic;//所有表情
    NSMutableArray *labelArr;//所有label
    
    XMPPServer *xmppServer;//xmpp 中心
    
    int currentPage;
}

@property (nonatomic,assign)BOOL                        reloading;         //是否正在loading
@property (nonatomic,assign)BOOL                        isLoadMoreData;    //是否是载入更多
@property (nonatomic,assign)BOOL                        isHaveMoreData;    //是否还有更多数据,决定是否有更多view

@property (nonatomic,retain)EGORefreshTableHeaderView * refreshHeaderView;

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
    
    
    self.titleLabel.text = self.chatWithUser;
    
    UIButton *rightButton =[[UIButton alloc]initWithFrame:CGRectMake(0,8,30,21.5)];
    [rightButton addTarget:self action:@selector(clickToHome:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setImage:[UIImage imageNamed:@"shouye48_44"] forState:UIControlStateNormal];
    UIBarButtonItem *save_item=[[UIBarButtonItem alloc]initWithCustomView:rightButton];
    
    UIButton *rightButton2 =[[UIButton alloc]initWithFrame:CGRectMake(0,8,30,21.5)];
    [rightButton2 addTarget:self action:@selector(clickToAdd:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton2 setImage:[UIImage imageNamed:@"tianjia44_44"] forState:UIControlStateNormal];
    UIBarButtonItem *save_item2=[[UIBarButtonItem alloc]initWithCustomView:rightButton2];
    self.navigationItem.rightBarButtonItems = @[save_item,save_item2];
    
    self.table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.height - 44 - (iPhone5 ? 20 : 0) - 50) style:UITableViewStylePlain];
    _table.delegate = self;
    _table.dataSource = self;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_table];
    _table.decelerationRate = 0.8;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickToHideKeyboard)];
    tap.cancelsTouchesInView = NO;
    [_table addGestureRecognizer:tap];
    
    
    xmppServer = [XMPPServer shareInstance];
    
    xmppServer.chatDelegate = self;
    xmppServer.messageDelegate = self;
    
    if (![xmppServer.xmppStream isAuthenticated])
    {
        NSLog(@"未认证");
        
        if (![xmppServer.xmppStream isConnected]) {
            
            NSLog(@"未连接");
            [xmppServer connect];
        }else
        {
            NSError *error;
            [xmppServer.xmppStream authenticate:xmppServer.xmppPlainAutentication error:&error];
            NSLog(@"kk erro %@",error);
        }
    }
    
    
    messages = [NSMutableArray array];
    labelArr = [NSMutableArray array];
    rowHeights = [NSMutableArray array];
    
//    [self testData];//测试数据
    
    [self createInputView];
    
    currentPage = 0;
    
    [self loadarchivemsg:currentPage];
    [self createHeaderView];
}

#pragma - mark 聊天历史记录

- (void)loadarchivemsg:(int)offset
{
    XMPPMessageArchivingCoreDataStorage *storage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
    NSManagedObjectContext *moc = [storage mainThreadManagedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Message_CoreDataObject"
                                                         inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    
    [request setFetchLimit:MESSAGE_PAGE_SIZE];
    [request setFetchOffset:offset];
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:NO];
    [request setSortDescriptors:@[sort]];
    
    NSLog(@"offset %d",offset);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userName = [defaults objectForKey:XMPP_USERID];
    NSString *server = [defaults objectForKey:XMPP_SERVER];
    
    NSString *chatWithJid = [NSString stringWithFormat:@"%@@%@",self.chatWithUser,server];
    NSString *currentJid = [NSString stringWithFormat:@"%@@%@",userName,server];

    //bareJidStr 代表与谁聊天
    //body 内容
    //streamBareJidStr 当前用户
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(bareJidStr like[cd] %@ )&& (streamBareJidStr like[cd] %@)",chatWithJid,currentJid];
    
    [request setPredicate:predicate];

    [request setEntity:entityDescription];
    NSError *error;
    NSArray *messages_arc = [moc executeFetchRequest:request error:&error];
    
    [self print:[[NSMutableArray alloc]initWithArray:messages_arc]];
}

- (void)print:(NSMutableArray*)messages_arc{
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    NSLog(@"path %@",path);
    
    if (messages_arc.count == 0) {
        
        
        self.isHaveMoreData = NO;
        [self performSelector:@selector(finishReloadigData) withObject:nil afterDelay:1];
        
        return;
    }
    
    @autoreleasepool {
        
        for (XMPPMessageArchiving_Message_CoreDataObject *message in messages_arc) {
            
            XMPPMessage *message12=[[XMPPMessage alloc]init];
            message12 = [message message];
            
            NSLog(@" kakakka--->message %@ %@",message.timestamp,message.body);
            
            NSString *msg = [[message12 elementForName:@"body"] stringValue];
            NSString *from = [[message12 attributeForName:@"from"] stringValue];
            
            NSDateFormatter *format = [[NSDateFormatter alloc] init];
            [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *time = [format stringFromDate:message.timestamp];
            
            if(msg)
            {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:msg forKey:@"msg"];
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                NSString *userName = [defaults objectForKey:XMPP_USERID];

                if ([from hasPrefix:userName]) {
                    from = @"you";
                }
                [dict setObject:from forKey:@"sender"];
                
                //消息接收到的时间
                [dict setObject:(time ? time : @"") forKey:@"time"];
                
                [messages insertObject:dict atIndex:0];
                
                NSLog(@"messages %@",messages);
                
                [self createRichLabelWithMessage:dict isInsert:YES];
                
            }
        }
        
        
        
        //重新刷新tableView
//        [self.table reloadData];
        
//        if (messages_arc.count >= 5) {
//            
//            self.isHaveMoreData = YES;
//        }else
//        {
//            self.isHaveMoreData = NO;
//        }
        
        self.isHaveMoreData = YES;
        
        [self performSelector:@selector(finishReloadigData) withObject:nil afterDelay:1];
        
//        [self finishReloadigData];
        
        if (_reloading) {
            return;
        }
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:messages.count - 1 inSection:0];;
        [self.table scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer.view isKindOfClass:[FBChatImage class]]) {
        
        return NO;
    }
    
    return YES;
}

#pragma - mark  click事件

- (void)clickToHideKeyboard
{
    [inputBar resignFirstResponder];
}

- (void)clickToAdd:(UIButton *)btn
{
    FBAddFriendsController *add = [[FBAddFriendsController alloc]init];
    [self.navigationController pushViewController:add animated:YES];
}

- (void)clickToHome:(UIButton *)btn
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)testData
{
    NSDictionary *dic = @{MESSAGE_SENDER: @"张三",MESSAGE_MSG:@"发送的[哈哈]消息有多长呢",MESSAGE_TIME:@"2014-07-04"};
    NSDictionary *dic1 = @{MESSAGE_SENDER: @"you",MESSAGE_MSG:@"发送的[抓狂]消息[抓狂]有多长呢",MESSAGE_TIME:@"2014-07-04"};
    NSDictionary *dic2 = @{MESSAGE_SENDER: @"张三",MESSAGE_MSG:@"诺诺你好我最爱的漂亮金毛姑娘刚离别小半天，我想你了，好想好像你希望你在另一个美丽的世界中依然还是那样的聪明，顽皮……2013年7月6日星期六，中午接到姐的电话，听说你吃到了不干净的东西现在呕吐，吐出的是黑色的血，现在在宠物医[熊猫]看着你努力的抬头望着这个多彩的世界当，看着你努力的环视着llllll",MESSAGE_TIME:@"2014-07-04"};
    NSDictionary *dic3 = @{MESSAGE_SENDER: @"you",MESSAGE_MSG:@"诺诺你好我最爱的漂亮金毛姑娘刚离别小半天，我想你了，好想好像你希望你在另一个美丽的世界中依然还[熊猫]褐色的皮毛是那样的光滑柔顺当，看着你努力的抬头望着这个多彩的世界当，看着你努力的环视着[熊猫]发送[bed凌乱][bed凌乱][bed凌乱][的消息有多长呢",MESSAGE_TIME:@"2014-07-04"};
    NSDictionary *dic4 = @{MESSAGE_SENDER: @"张三",MESSAGE_MSG:@"发送的的消的消息有的消息有的消息有的发送的消的消息有的消息有的消息有的消息[懒得理你]有息有多长呢发送的消的消息有的消息有[抓狂]的消息有的消[大笑][大笑][多长呢发送的消的消息有的消息有的消息有的消[懒得理你]息有息有多长呢发送的消的消息有的消息有的消息有的消息有息有多长呢发送的消的消多长呢",MESSAGE_TIME:@"2014-07-04"};
    
     NSString *test = @"<img height=\"195\" width=\"325\" src=\"http://www0.autoimg.cn/newspic/2013/12/22/620x0_0_2013122223315823282.jpg\"/>>";
    NSDictionary *dic5 = @{MESSAGE_SENDER: @"张三",MESSAGE_MSG:test,MESSAGE_TIME:@"2014-07-04"};
    
    NSDictionary *dic6 = @{MESSAGE_SENDER: @"you",MESSAGE_MSG:@"发送的消息有多长呢",MESSAGE_TIME:@"2014-07-04"};
    NSDictionary *dic7 = @{MESSAGE_SENDER: @"you",MESSAGE_MSG:@"发送的消的消息有的消息有的消息有的发送的消的消息有的消息有的消息有的消息有息有[懒得理你]多长呢[熊猫]想念我不停的祈祷，我不停的对自己说，没事没事一切都会好起来的现在在宠物医院急救着我的头脑嗡嗡的响，怎么会这样，怎么有多长呢",MESSAGE_TIME:@"2014-07-04"};
    
    
   NSString *test1 = @"<img height=\"195\" width=\"325\" src=\"http://c.hiphotos.baidu.com/image/pic/item/32fa828ba61ea8d3ef5adf65950a304e251f5852.jpg\"/>>";
    
    NSDictionary *dic8 = @{MESSAGE_SENDER: @"张三",MESSAGE_MSG:test1,MESSAGE_TIME:@"2014-07-04"};
    
    NSDictionary *dic9 = @{MESSAGE_SENDER: @"张三",MESSAGE_MSG:@"发送[抓狂]的消的消息有息有多长呢",MESSAGE_TIME:@"2014-07-04"};
    
    
    [messages addObjectsFromArray:@[dic,dic1,dic2,dic3,dic4,dic5,dic6,dic7,dic8,dic9]];
    
    
    [self.table reloadData];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - mark 创建 richLabel 和 imageView


/**
 *  根据发送的内容返回一个富文本label,并将label加入到label数组中
 *
 *  @param dic 消息字典
 *
 *  @return label
 */
- (CGFloat)createRichLabelWithMessage:(NSDictionary *)dic isInsert:(BOOL)isInsert
{
//    MESSAGE_TYPE type = [[dic objectForKey:@"type"]integerValue];
    
    
    //本地发送 图片
    
    BOOL isLocal = [[dic objectForKey:MESSAGE_MESSAGE_LOCAL]boolValue];
    if (isLocal) { //图片
        
        UIImage *aImage = [dic objectForKey:MESSAGE_MSG];
        FBChatImage *aImageView = [[FBChatImage alloc]init];
        aImageView.image = aImage;
        aImageView.userInteractionEnabled = YES;
        
        
        if (isInsert) {
            [labelArr insertObject:aImageView atIndex:0];
        }else
        {
           [labelArr addObject:aImageView];
        }
        
        [aImageView showBigImage:^(UIImageView *imageView) {
            
            [SJAvatarBrowser showImage:imageView];

        }];
        
        //最多高度 200,最大宽度 200
        [XMPPStatics updateFrameForImageView:aImageView originalWidth:aImage.size.width originalHeight:aImage.size.height];
        
        NSNumber *heightNum = [[NSNumber alloc] initWithFloat:aImageView.height];
        
        if (isInsert) {
            [rowHeights insertObject:heightNum atIndex:0];
        }else
        {
            [rowHeights addObject:heightNum];
        
        }
        
        
        return [heightNum floatValue];
    }

    //网络获取 图片
    
    NSString *msg = [dic objectForKey:MESSAGE_MSG];
    
    NSString *url = [XMPPStatics imageUrl:msg] ;
    if (![url isEqualToString:@""]) {
        //是图片
        CGFloat width = [XMPPStatics imageValue:msg for:@"width"];
        CGFloat height = [XMPPStatics imageValue:msg for:@"height"];
        
        
        FBChatImage *aImageView = [[FBChatImage alloc]initWithFrame:CGRectMake(0, 0, width, height)];
        
        
        if (isInsert) {
            [labelArr insertObject:aImageView atIndex:0];
        }else
        {
            [labelArr addObject:aImageView];
            
        }
        
        
        aImageView.userInteractionEnabled = YES;
        
        [aImageView showBigImage:^(UIImageView *imageView) {
            
            [SJAvatarBrowser showImage:imageView];
            
        }];
        
        [aImageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
        
        //最多高度 200,最大宽度 200
        [XMPPStatics updateFrameForImageView:aImageView originalWidth:width originalHeight:height];
        
        NSNumber *heightNum = [[NSNumber alloc] initWithFloat:aImageView.height];
        
        if (isInsert) {
            [rowHeights insertObject:heightNum atIndex:0];
        }else
        {
            [rowHeights addObject:heightNum];
            
        }
        
        
        return [heightNum floatValue];
        
    }
    
    
    OHAttributedLabel *label = [[OHAttributedLabel alloc] initWithFrame:CGRectZero];
    NSString *text = [dic objectForKey:MESSAGE_MSG];
    [self creatAttributedLabel:text Label:label];
    
    NSNumber *heightNum = [[NSNumber alloc] initWithFloat:label.frame.size.height];
    
    
    if (isInsert) {
        [labelArr insertObject:label atIndex:0];
    }else
    {
        [labelArr addObject:label];
        
    }
    
    [self drawImage:label];
//    [rowHeights addObject:heightNum];
    
    if (isInsert) {
        [rowHeights insertObject:heightNum atIndex:0];
    }else
    {
        [rowHeights addObject:heightNum];
        
    }

    
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
    [dictionary setObject:[XMPPStatics getCurrentTime] forKey:@"time"];
    [dictionary setObject:[NSString stringWithFormat:@"%d",type] forKey:@"type"];
    
    if (aImage) {
        
        [dictionary setObject:aImage forKey:MESSAGE_MSG];
        [dictionary setObject:[NSNumber numberWithBool:YES] forKey:MESSAGE_MESSAGE_LOCAL];
    }
    
    [messages addObject:dictionary];
    
    //重新刷新tableView
    [self.table reloadData];
    
    if (_reloading) {
        
        return;
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:messages.count - 1 inSection:0];;
    [self.table scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

#pragma - mark XMPP发送消息

- (void)xmppSendMessage:(NSString *)messageText
{
    //XMPPFramework主要是通过KissXML来生成XML文件
    //生成<body>文档
    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    [body setStringValue:messageText];
    
    //生成XML消息文档
    NSXMLElement *mes = [NSXMLElement elementWithName:@"message"];
    //消息类型
    [mes addAttributeWithName:@"type" stringValue:@"chat"];
    //发送给谁
    
    NSString *toUser = [NSString stringWithFormat:@"%@@%@",self.chatWithUser,[[NSUserDefaults standardUserDefaults] stringForKey:XMPP_SERVER]];
    
    NSLog(@"_chatWithUser %@ server %@",self.chatWithUser,[[NSUserDefaults standardUserDefaults] stringForKey:XMPP_SERVER]);
    
    
    [mes addAttributeWithName:@"to" stringValue:toUser];
    //由谁发送
    [mes addAttributeWithName:@"from" stringValue:[[NSUserDefaults standardUserDefaults] stringForKey:XMPP_USERID]];
    //组合
    [mes addChild:body];
    
    //发送消息
    [[xmppServer xmppStream] sendElement:mes];
}

#pragma - mark 输入框点击发送消息 CWInputDelegate

- (void)inputView:(CWInputView *)inputView sendBtn:(UIButton*)sendBtn inputText:(NSString*)text
{
    NSLog(@"text %@",text);
    
    if (![text isEqualToString:@""] && text.length > 0) {
        
        NSLog(@"直接发送");
        
        [self xmppAuthenticatedWithMessage:text MessageType:Message_Normal image:nil];
    }
}

#pragma - mark 验证是否登录成功,否则自动登录再fasong

- (void)xmppAuthenticatedWithMessage:(NSString *)text MessageType:(MESSAGE_TYPE)type image:(UIImage *)aImage
{
    if (![xmppServer.xmppStream isAuthenticated])
    {
        NSLog(@"未认证");
        
        if (![xmppServer.xmppStream isConnected]) {
            
            NSLog(@"未连接");
            
            [xmppServer login:^(BOOL result) {
                
                if (result) {
                    
                    NSLog(@"连接 %d",result);
                    
                    [self localSendMessage:text MessageType:type image:aImage];
                    
                    [self xmppSendMessage:text];
                    
                }
                
            }];
            
        }else
        {
            NSError *error;
            BOOL isAuthicat = [xmppServer.xmppStream authenticate:xmppServer.xmppPlainAutentication error:&error];
            NSLog(@"kk erro %@",error);
            if (isAuthicat) {
                
                NSLog(@"认证成功了,发送");
                
                [self localSendMessage:text MessageType:type image:aImage];
                
                [self xmppSendMessage:text];
            }else
            {
                NSLog(@"认证失败");
            }
            
        }
    }else
    {
        NSLog(@"已认证,直接发送");
        [self localSendMessage:text MessageType:type image:aImage];
        
        [self xmppSendMessage:text];
    }
}



#pragma - mark messageDelegate 消息代理 <NSObject>

- (void)newMessage:(NSDictionary *)messageDic
{
    NSLog(@"newMessage %@",messageDic);
    
    NSString *sender = [messageDic objectForKey:@"sender"];
    
    NSLog(@"sender %@ chatWith %@",sender,self.chatWithUser);
    
    //是当前聊天用户才刷新页面
    
    if (sender && [sender hasPrefix:(self.chatWithUser ? self.chatWithUser : @"")]) {
        [messages addObject:messageDic];
        [self.table reloadData];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:messages.count - 1 inSection:0];;
        [self.table scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

#pragma - mark XMPP 用户状态代理 chatDelegate

-(void)userOnline:(User *)user
{
    NSLog(@"userOnline:%@  type:%@",user.userName,user.presentType);
    
//    //用户上线
//    
//    user.jid = [NSString stringWithFormat:@"%@@%@",user.userName,[[NSUserDefaults standardUserDefaults]objectForKey:XMPP_SERVER]];
//    
//    [self changeOnlineState:user];
}
-(void)userOffline:(User *)user
{
    NSLog(@"userOffline %@ %@",user.userName,user.presentType);
    
//    user.jid = [NSString stringWithFormat:@"%@@%@",user.userName,[[NSUserDefaults standardUserDefaults]objectForKey:XMPP_SERVER]];
//    [self changeOnlineState:user];
}

- (void)friendsArray:(NSArray *)array //好友列表
{
    NSLog(@"friendsArray:%@",array);
}

//改变上线状态

- (void)changeOnlineState:(User *)user
{
    NSLog(@"user:%@ changeOnlineState",user);
}

//用户是否已在列表

- (BOOL)isUserAdded:(User *)user
{
//    for (User *aUser in onlineUsers) {
//        if ([user.userName isEqualToString:aUser.userName]) {
//            return YES;
//        }
//    }
    return NO;
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
        [self createRichLabelWithMessage:dict isInsert:NO];
        
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
        [self createRichLabelWithMessage:dict isInsert:NO];
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
        
//        [self localSendMessage:Nil MessageType:Message_Image image:image];
        
        NSString *test = @"<img height=\"195\" width=\"325\" src=\"http://www0.autoimg.cn/newspic/2013/12/22/620x0_0_2013122223315823282.jpg\"/>>";
        
        [self xmppAuthenticatedWithMessage:test MessageType:Message_Image image:image];
        
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

#pragma - mark EGORefresh

-(void)createHeaderView
{
    if (_refreshHeaderView && _refreshHeaderView.superview) {
        [_refreshHeaderView removeFromSuperview];
    }
    self.refreshHeaderView = [[EGORefreshTableHeaderView alloc]initWithFrame:CGRectMake(0.0f,0.0f -self.view.frame.size.height, self.view.frame.size.width, self.view.bounds.size.height)];
    _refreshHeaderView.delegate = self;
    _refreshHeaderView.backgroundColor = [UIColor clearColor];
    [self.table addSubview:_refreshHeaderView];
    [_refreshHeaderView refreshLastUpdatedDate];
}
-(void)removeHeaderView
{
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
    _refreshHeaderView = Nil;
}

#pragma mark-
#pragma mark force to show the refresh headerView
//代码触发刷新
-(void)showRefreshHeader:(BOOL)animated
{
    if (animated)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        self.table.contentInset = UIEdgeInsetsMake(65.0f, 0.0f, 0.0f, 0.0f);
        [self.table scrollRectToVisible:CGRectMake(0, 0.0f, 1, 1) animated:NO];
        [UIView commitAnimations];
    }
    else
    {
        self.table.contentInset = UIEdgeInsetsMake(65.0f, 0.0f, 0.0f, 0.0f);
        [self.table scrollRectToVisible:CGRectMake(0, 0.0f, 1, 1) animated:NO];
    }
    
    [_refreshHeaderView setState:EGOOPullRefreshLoading];
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:self.table];
}

#pragma mark - EGORefreshTableDelegate
- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos
{
    [self beginToReloadData:aRefreshPos];
}

//根据刷新类型，是看是下拉还是上拉
-(void)beginToReloadData:(EGORefreshPos)aRefreshPos
{
    self.reloading = YES;
    
    if (aRefreshPos == EGORefreshHeader)
    {
        self.isLoadMoreData = YES;
        
        currentPage += MESSAGE_PAGE_SIZE;
        [self loadarchivemsg:currentPage];
        
    }
}

//完成数据加载
- (void)finishReloadigData
{
    NSLog(@"finishReloadigData完成加载");
    
    _reloading = NO;
    
    if (_refreshHeaderView)
    {
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.table];
        self.isLoadMoreData = NO;
    }

    [self.table reloadData];
    
    //如果有更多数据，重新设置footerview  frame
    
    
    if (self.isHaveMoreData)
    {
        [self createHeaderView];
        
    }else
    {
        [self removeHeaderView];
        
        NSLog(@"----");
    }
}

- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view
{
    return _reloading;
}
- (NSDate*)egoRefreshTableDataSourceLastUpdated:(UIView*)view
{
    return [NSDate date];
}

#pragma mark - UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDidScroll:self.table];
    }
    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
    if (_refreshHeaderView)
    {
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:self.table];
        
    }
}


@end
