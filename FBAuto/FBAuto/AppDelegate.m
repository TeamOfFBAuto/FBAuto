//
//  AppDelegate.m
//  FBAuto
//  Created by 史忠坤 on 14-6-25.
//  Copyright (c) 2014年 szk. All rights reserved.



#import "AppDelegate.h"


#import "CarResourceViewController.h"//车源类

#import "SendCarViewController.h"//发布

#import "FindCarViewController.h"//寻车

#import "PersonalViewController.h"//个人中心

#import "ASIHTTPRequest.h"

#import "XMPPServer.h"

#import <ShareSDK/ShareSDK.h>
#import "WeiboSDK.h"
#import "WXApi.h"
#import <TencentOpenAPI/QQApi.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>

//shareSDK fbauto2014@qq.com 123abc
//新浪 fbauto2014@qq.com  123abc 或者 fbauto2014
// 邮箱 fbauto2014@qq.com
// QQ: 2609534839
// 密码: 123abc

#define Appkey @"2831cfc47791"
#define App @"2354df12a6dd38312f3425b39e735d21"

#define SinaAppKey @"2437553400"
#define SinaAppSecret @"7379cf0aa245ba45a66cc7c9ae9b1dba"

//#define QQAPPID @"101030950"
#define WXAPPID @"wxd747942b226f56d5"


// shareSDK 测试数据

//#define SinaAppKey @"568898243"
//#define SinaAppSecret @"38a4f8204cc784f81f9f0daaf31e02e3"

#define QQAPPID @"100371282"
//#define WXAPPID @"wx4868b35061f87885"

#define RedirectUrl @"http://www.sharesdk.cn"
//#define RedirectUrl @"http://www.sina.com"


@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    CarResourceViewController * rootVC = [[CarResourceViewController alloc] init];
    
    SendCarViewController * fabuCarVC = [[SendCarViewController alloc] init];
    
    FindCarViewController * searchCarVC = [[FindCarViewController alloc] init];
    
    PersonalViewController * perSonalVC = [[PersonalViewController alloc] init];
    
    
    UINavigationController * navc1 = [[UINavigationController alloc] initWithRootViewController:rootVC];
    
    UINavigationController * navc2 = [[UINavigationController alloc] initWithRootViewController:fabuCarVC];
    
    UINavigationController * navc3 = [[UINavigationController alloc] initWithRootViewController:searchCarVC];
    
    UINavigationController * navc4 = [[UINavigationController alloc] initWithRootViewController:perSonalVC];
    
    
    rootVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"车源" image:[UIImage imageNamed:@"cheyuan_down46_46"] tag:0];
    
//    rootVC.tabBarItem=[[UITabBarItem alloc]initWithTitle:@"鸡毛" image:[UIImage imageNamed:@"fbselectios7.png"] selectedImage:[UIImage imageNamed:@"bbsselected.png"]];
    
    fabuCarVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"发布" image:[UIImage imageNamed:@"fabu_down46_46"] tag:1];
    
    searchCarVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"寻车" image:[UIImage imageNamed:@"xunche_down46_46"] tag:2];
    
    perSonalVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"个人中心" image:[UIImage imageNamed:@"geren_down46_46"] tag:3];
    
    UITabBarController * tabbar = [[UITabBarController alloc] init];
    tabbar.tabBar.backgroundImage=[UIImage imageNamed:@"testV.png"];
    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:232.0/255.0f green:128/255.0f blue:24/255.0f alpha:1]];
    
    tabbar.viewControllers = [NSArray arrayWithObjects:navc1,navc2,navc3,navc4,nil];

    //将状态栏设置成自定义颜色
    
    if (IOS7_OR_LATER) {
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    }

    //注册远程通知
    
    [[UIApplication sharedApplication]registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeAlert |UIRemoteNotificationTypeBadge |UIRemoteNotificationTypeSound)];
    //图标显示
    application.applicationIconBadgeNumber = 0;
    
    //UIApplicationLaunchOptionsRemoteNotificationKey,判断是通过推送消息启动的
    NSDictionary *infoDic = [launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
    if (infoDic)
    {
        NSLog(@"infoDic %@",infoDic);
        
        NSString *str = [NSString stringWithFormat:@"%@",infoDic];
        
        [LCWTools alertText:@"haha"];
    }
    
    //消息提醒
    [self initMessageAlert];
    
    //开启网络状况的监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    self.hostReach = [Reachability reachabilityWithHostname:@"http://fbautoapp.fblife.com"];
    
    //开始监听，会启动一个run loop
    [self.hostReach startNotifier];
    
    //分享
    [ShareSDK registerApp:Appkey];
    [self initSharePlat];
    
    //发送未读消息通知
    [[NSNotificationCenter defaultCenter]postNotificationName:@"unReadNumber" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateMessageCount:) name:@"fromUnread" object:nil];

    self.window.rootViewController=tabbar;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

#pragma mark - 消息提示

- (void)initMessageAlert
{
    CGFloat aHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    self.statusBarBack = [[UIWindow alloc]initWithFrame:CGRectMake(200, 0, 80, aHeight)];
    _statusBarBack.backgroundColor = [UIColor clearColor];
    [_statusBarBack setWindowLevel:UIWindowLevelStatusBar+1];
    [_statusBarBack makeKeyAndVisible];
    
    self.messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _statusBarBack.width, _statusBarBack.height)];
    _messageLabel.textColor = [UIColor orangeColor];
    _messageLabel.font = [UIFont systemFontOfSize:12];
//    _messageLabel.text = @"RNai()";
    [_statusBarBack addSubview:_messageLabel];
}

- (void)updateMessageCount:(NSNotification *)notification
{
    NSArray *messages = [_messageLabel.text componentsSeparatedByString:@"("];
    NSString *name = @"";
    if (messages.count > 0) {
        name = [messages objectAtIndex:0];
    }
    NSLog(@"notification %@",notification.userInfo);
    int number = [[notification.userInfo objectForKey:@"unreadNum"]intValue];
    NSString *fromName = [notification.userInfo objectForKey:@"fromName"];
    NSString *fromPhone = [notification.userInfo objectForKey:@"fromPhone"];
    
    if (number > 0) {
        
        _messageLabel.text = [NSString stringWithFormat:@"%@(%d)",fromName,number];
        
    }else
    {
        if ([fromName isEqualToString:name]) {
            _messageLabel.text = @"";//不显示
        }else
        {
            
        }
    }
}

#pragma - mark 分享

- (void)initSharePlat
{
    //添加新浪微博应用 注册网址 http://open.weibo.com
    [ShareSDK connectSinaWeiboWithAppKey:SinaAppKey
                               appSecret:SinaAppSecret
                             redirectUri:RedirectUrl];
    //当使用新浪微博客户端分享的时候需要按照下面的方法来初始化新浪的平台
    [ShareSDK  connectSinaWeiboWithAppKey:SinaAppKey
                                appSecret:SinaAppSecret
                              redirectUri:RedirectUrl
                              weiboSDKCls:[WeiboSDK class]];
    
    //添加QQ应用  注册网址  http://mobile.qq.com/api/
    [ShareSDK connectQQWithQZoneAppKey:QQAPPID
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    
    //添加微信应用 注册网址 http://open.weixin.qq.com
    [ShareSDK connectWeChatWithAppId:WXAPPID
                           wechatCls:[WXApi class]];
}


#pragma - mark 监控网络状态

-(void)reachabilityChanged:(NSNotification *)note
{
    
    Reachability *currReach = [note object];
    
    NSParameterAssert([currReach isKindOfClass:[Reachability class]]);
    
    //对连接改变做出响应处理动作
    
    NetworkStatus status = [currReach currentReachabilityStatus];
    
    //如果没有连接到网络就弹出提醒实况
    
    self.isReachable = YES;
    
    if(status == NotReachable)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络连接异常" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        
        [alert show];
        
        self.isReachable = NO;
        
        return;
    }
    
    if (status == ReachableViaWiFi || status == ReachableViaWWAN) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络连接信息" message:@"网络连接正常" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        
//        [alert show];
        
        self.isReachable = YES;
        
    }
}

#pragma mark - WXApiDelegate

-(void) onReq:(BaseReq*)req
{
    NSLog(@"req %@",req);
}

-(void) onResp:(BaseResp*)resp
{
    NSLog(@"req %@",resp);
}

- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    
    [[XMPPServer shareInstance] disconnect];//断开连接
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[XMPPServer shareInstance]loginTimes:10 loginBack:^(BOOL result) {
        if (result) {
            NSLog(@"连接并且登录成功");
        }else{
            NSLog(@"连接登录不成功");
        }
    }];
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"FBAuto" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"FBAuto.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}





#pragma mark - 上传的代理回调方法
-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"上传完成");
    
    if (request.tag == 123)//上传用户头像
    {
        NSLog(@"走了555");
        NSDictionary * dic = [[NSDictionary alloc] initWithDictionary:[request.responseData objectFromJSONData]];
        NSLog(@"tupiandic==%@",dic);
        
        if ([[dic objectForKey:@"errcode"]intValue] == 0) {
            NSString *str = @"no";
            [[NSUserDefaults standardUserDefaults]setObject:str forKey:@"gIsUpFace"];
            
        }else{
            NSString *str = @"yes";
            [[NSUserDefaults standardUserDefaults]setObject:str forKey:@"gIsUpFace"];
        }
        //发通知
        [[NSNotificationCenter defaultCenter]postNotificationName:@"chagePersonalInformation" object:nil];
        
    }
    
}

#pragma - mark 远程通知

//devicetoken
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    
    NSLog(@"My token is: %@", deviceToken);
    
    
    NSString *string_pushtoken=[NSString stringWithFormat:@"%@",deviceToken];
    
    while ([string_pushtoken rangeOfString:@"<"].length||[string_pushtoken rangeOfString:@">"].length||[string_pushtoken rangeOfString:@" "].length) {
        string_pushtoken=[string_pushtoken stringByReplacingOccurrencesOfString:@"<" withString:@""];
        string_pushtoken=[string_pushtoken stringByReplacingOccurrencesOfString:@">" withString:@""];
        string_pushtoken=[string_pushtoken stringByReplacingOccurrencesOfString:@" " withString:@""];
        
    }
    
    
    [[NSUserDefaults standardUserDefaults]setObject:string_pushtoken forKey:DEVICETOKEN];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSString *str = [NSString stringWithFormat: @"Error: %@", error];
    NSLog(@"erro  %@",str);
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"注册失败" message:str delegate:Nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //正在前台,获取推送时，此处可以获取
    //后台，点击进入,此处可以获取
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateInactive){
        NSLog(@"UIApplicationStateInactive %@",userInfo);
        //点击消息进入走此处,做相应处理
        
    }
    if (state == UIApplicationStateActive) {
        NSLog(@"UIApplicationStateActive %@",userInfo);
        //程序就在前台
        //弹框
        
    }
    if (state == UIApplicationStateBackground)
    {
        NSLog(@"UIApplicationStateBackground %@",userInfo);
    }
}

@end
