//
//  FBDetail2Controller.m
//  FBAuto
//
//  Created by lichaowei on 14-7-3.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "FBDetail2Controller.h"
#import "FBPhotoBrowserController.h"
#import "DDPageControl.h"
#import "FBChatViewController.h"

@interface FBDetail2Controller ()
{
    DDPageControl *pageControl;
}

@end

@implementation FBDetail2Controller

@synthesize bigBgScroll,photosScroll;
@synthesize firstBgView,thirdBgView;

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
    
    self.bigBgScroll.frame = CGRectMake(0, 64, 320, self.view.height - 44 - 20 - 75);
    
    CGRect thirdFrame = self.thirdBgView.frame;
    thirdFrame.origin.y = self.view.bottom - 75 - 44 - (iPhone5 ? 20 : 0);
    self.thirdBgView.frame = thirdFrame;
    
    self.imagesArray = @[@"geren_down46_46",@"haoyou_dianhua40_46",@"geren_down46_46",@"haoyou_dianhua40_46",@"haoyou_dianhua40_46",@"geren_down46_46",@"haoyou_dianhua40_46",@"haoyou_dianhua40_46",@"geren_down46_46",@"haoyou_dianhua40_46"];
    [self createFirstSection];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - mark 图片部分

- (void)createFirstSection
{
    CGFloat aWidth = (photosScroll.width - 14)/ 3;
    for (int i = 0; i < self.imagesArray.count; i ++) {
        UIButton *imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [imageBtn setImage:[UIImage imageNamed:[_imagesArray objectAtIndex:i]] forState:UIControlStateNormal];
        imageBtn.tag = 100 + i;
        imageBtn.layer.borderWidth = 2;
        [imageBtn addTarget:self action:@selector(clickToBigPhoto:) forControlEvents:UIControlEventTouchUpInside];
        imageBtn.frame = CGRectMake((aWidth + 7) * i, 0, aWidth, 80);
        [photosScroll addSubview:imageBtn];
    }
    
    photosScroll.contentSize = CGSizeMake(aWidth * _imagesArray.count + 7 * (_imagesArray.count - 1), 80);
    
    [self createPageControlSumPages:(int)_imagesArray.count];
}


#pragma - mark 创建 PageControl

- (void)createPageControlSumPages:(int)sum
{
    if (sum % 3 == 0) {
        sum = sum / 3;
    }else
    {
        sum = (sum / 3) + 1;
    }
    
    
    pageControl = [[DDPageControl alloc] init] ;
	[pageControl setCenter: CGPointMake(firstBgView.center.x, firstBgView.height-10.0f)] ;
    //	[pageControl addTarget: self action: @selector(pageControlClicked:) forControlEvents: UIControlEventValueChanged] ;
	[pageControl setDefersCurrentPageDisplay: YES] ;
	[pageControl setType: DDPageControlTypeOnFullOffEmpty] ;
	[pageControl setOnColor: [UIColor colorWithHexString:@"ff9c00"]];
	[pageControl setOffColor: [UIColor colorWithHexString:@"b4b4b4"]] ;
	[pageControl setIndicatorDiameter: 9.0f] ;
	[pageControl setIndicatorSpace: 5.0f] ;
	[firstBgView addSubview: pageControl] ;
    
    //    pageControl.hidden = YES;
    
    [pageControl setNumberOfPages:sum];
	[pageControl setCurrentPage: 0];
}

#pragma - mark click 事件

- (void)clickToBigPhoto:(UIButton *)btn
{
    FBPhotoBrowserController *browser = [[FBPhotoBrowserController alloc]init];
    browser.imagesArray = @[[UIImage imageNamed:@"geren_down46_46"],[UIImage imageNamed:@"haoyou_dianhua40_46"]];
    browser.showIndex = 1;
    browser.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:browser animated:YES];
}

#pragma mark -
#pragma mark UIScrollView delegate methods

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
	CGFloat pageWidth = photosScroll.bounds.size.width ;
    float fractionalPage = photosScroll.contentOffset.x / pageWidth ;
	NSInteger nearestNumber = lround(fractionalPage) ;
	
	if (pageControl.currentPage != nearestNumber)
	{
		pageControl.currentPage = nearestNumber ;
		
		// if we are dragging, we want to update the page control directly during the drag
		if (photosScroll.dragging)
			[pageControl updateCurrentPageDisplay] ;
	}
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"%f",scrollView.contentOffset.x);
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)aScrollView
{
	// if we are animating (triggered by clicking on the page control), we update the page control
	[pageControl updateCurrentPageDisplay] ;
    
    NSLog(@"%f",aScrollView.contentOffset.x);
}

#pragma - mark 点击事件

- (IBAction)clickToDial:(id)sender {
    
    NSString *num = [[NSString alloc] initWithFormat:@"tel://%@",@"18612389982"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]];
}
- (IBAction)clickToChat:(id)sender {
    
    FBChatViewController *chat = [[FBChatViewController alloc]init];
    [self.navigationController pushViewController:chat animated:YES];
    
}

@end
