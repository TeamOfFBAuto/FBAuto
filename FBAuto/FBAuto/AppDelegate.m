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


#import "XMPPServer.h"



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
    
//    tabbar.tabBar.backgroundColor=RGBCOLOR(31, 32, 33);
  //  tabbar.tabBar.backgroundColor=[UIColor blackColor];
    
    tabbar.tabBar.backgroundImage=[UIImage imageNamed:@"testV.png"];
    
  //  tabbar.tabBar.selectionIndicatorImage = [UIImage imageNamed:@"background_image.png"];
    
    [[UITabBar appearance] setTintColor:RGBCOLOR(232, 128, 24)];
    
    tabbar.viewControllers = [NSArray arrayWithObjects:navc1,navc2,navc3,navc4,nil];

    //将状态栏设置成自定义颜色
    
    if (IOS7_OR_LATER) {
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    }
    
    
    self.window.rootViewController=tabbar;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
//    //将状态栏设置成自定义颜色
//    
//    if (IOS7_OR_LATER) {
//        
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
//        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
//    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    
    [[XMPPServer shareInstance] disconnect];//断开连接
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[XMPPServer shareInstance]connect];//连接
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

@end
