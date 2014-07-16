//
//  SendCarViewController.m
//  FBAuto
//
//  Created by 史忠坤 on 14-6-25.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "SendCarViewController.h"
#import "FBActionSheet.h"
#import "FBBaseViewController.h"
#import "Section_Button.h"

#import "SendCarParamsController.h"

#import "AppDelegate.h"

#import "PhotoImageView.h"

#import "QBImagePickerController.h"

#import "DDPageControl.h"

#import "GloginViewController.h"

#import "ASIFormDataRequest.h"

#define KFistSectionHeight 110 //上部分高度

@interface SendCarViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,QBImagePickerControllerDelegate,UIScrollViewDelegate,UITextFieldDelegate>
{
    UIImageView *navigationBgView;
    
    UIScrollView *bigBgScroll;//背景scroll
    
    UIView *firstBgView;
    UIView *secondBgView;
    UIButton *publish;
    
    UIScrollView *photosScroll;//图片底部scrollView
    UIButton *addPhotoBtn;//添加图片按钮
    NSMutableArray *photosArray;//存放图片
    NSMutableArray *photoViewArray;//存放所以imageView
    
    DDPageControl *pageControl;
    
    QBImagePickerController * imagePickerController;
    
    UITextField *priceTF;
}

@end

@implementation SendCarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (IOS7_OR_LATER) {
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    }
    
   }

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.view.backgroundColor=RGBCOLOR(220, 233, 3);

    // Do any additional setup after loading the view.
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"daohanglan_bg_640_88"] forBarMetrics: UIBarMetricsDefault];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 21)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"发布车源";
    
    
    self.navigationItem.titleView = titleLabel;
    
    bigBgScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.height - 49 - 44 - 20)];
    bigBgScroll.backgroundColor = [UIColor clearColor];
    bigBgScroll.showsHorizontalScrollIndicator = NO;
    bigBgScroll.showsVerticalScrollIndicator = NO;
    bigBgScroll.delegate = self;
    [self.view addSubview:bigBgScroll];
    
    [self createFirstSection];
    [self createSecondSection];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickToHideKeyboard)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
}


- (void)didReceiveMemoryWarning

{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - mark 图片上传

#define TT_CACHE_EXPIRATION_AGE_NEVER     (1.0 / 0.0)   // inf
- (void)postImages:(NSArray *)allImages
{
    NSString* url = [NSString stringWithFormat:FBAUTO_CARSOURCE_ADD_PIC];
    
    NSString *newUrl = [url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString: newUrl]];
    [request setRequestMethod:@"POST"];
    request.timeOutSeconds = 30.f;
    request.cachePolicy = TT_CACHE_EXPIRATION_AGE_NEVER;
    request.cacheStoragePolicy = ASICacheForSessionDurationCacheStoragePolicy;
    
    [request setShouldAttemptPersistentConnection:YES];
    [request setResponseEncoding:NSUTF8StringEncoding];
    [request setPostFormat:ASIMultipartFormDataPostFormat];
    
    request.delegate = self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        
        NSData* data;

        NSMutableData *myRequestData=[NSMutableData data];
        
        for (int i = 0;i < allImages.count; i++)
        {
            UIImage *image=[allImages objectAtIndex:i];
            
            UIImage * newImage = [SzkAPI scaleToSizeWithImage:image size:CGSizeMake(image.size.width>1024?1024:image.size.width,image.size.width>1024?image.size.height*1024/image.size.width:image.size.height)];
            
            data = UIImageJPEGRepresentation(newImage,0.5);
            
            [request addRequestHeader:@"Content-Length" value:[NSString stringWithFormat:@"%lu", (unsigned long)[myRequestData length]]];
            
            NSLog(@"---->图片大小:%lu",(unsigned long)[data length]);
            
            //设置http body
            
            [request addData:data withFileName:[NSString stringWithFormat:@"quan_img[%d].png",i] andContentType:@"image/PNG" forKey:@"photo"];
            
            [request addPostValue:[GMAPI getAuthkey] forKey:@"authkey"];
    
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            
            [request startAsynchronous];
        });
    });
}

- (void)requestStarted:(ASIHTTPRequest *)request
{
    NSLog(@"requestStarted %@",request.responseString);
}
- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders
{
    NSLog(@"didReceiveResponseHeaders %@",responseHeaders);
}
- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"requestFinished %@",request.responseString);
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:0 error:nil];
    
    NSLog(@"dic %@ %@",dic,[dic objectForKey:@"errinfo"]);
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"requestFailed %@",request.responseString);
}




#pragma - mark 价格输入框

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    [UIView animateWithDuration:0.5 animations:^{
        CGRect aFrame = bigBgScroll.frame;
        aFrame.origin.y = - 100.f;
        bigBgScroll.frame = aFrame;
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.5 animations:^{
        CGRect aFrame = bigBgScroll.frame;
        aFrame.origin.y = 0.f;
        bigBgScroll.frame = aFrame;
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [priceTF resignFirstResponder];
    return YES;
}

- (void)clickToHideKeyboard
{
    [priceTF resignFirstResponder];
}



#pragma - mark 创建 PageControl

- (void)createPageControl
{
    pageControl = [[DDPageControl alloc] init] ;
	[pageControl setCenter: CGPointMake(firstBgView.center.x, firstBgView.height-10.0f + 30)] ;
//	[pageControl addTarget: self action: @selector(pageControlClicked:) forControlEvents: UIControlEventValueChanged] ;
	[pageControl setDefersCurrentPageDisplay: YES] ;
	[pageControl setType: DDPageControlTypeOnFullOffEmpty] ;
	[pageControl setOnColor: [UIColor colorWithHexString:@"ff9c00"]];
	[pageControl setOffColor: [UIColor colorWithHexString:@"b4b4b4"]] ;
	[pageControl setIndicatorDiameter: 9.0f] ;
	[pageControl setIndicatorSpace: 5.0f] ;
	[firstBgView addSubview: pageControl] ;
    
    pageControl.hidden = YES;
}

//控制是否显示

- (void)controlPageControlDisplay:(BOOL)isShow showPage:(NSInteger)pageNum sumPage:(NSInteger)sum
{
    if (sum % 2 == 0) {
        sum = sum / 2;
    }else
    {
        sum = (sum / 2) + 1;
    }
   
    pageControl.hidden = !isShow;
    [pageControl setNumberOfPages:sum];
	[pageControl setCurrentPage: pageNum];
    
//    [self pageControlClicked:pageControl];
}


#pragma mark -
#pragma mark DDPageControl triggered actions

- (void)pageControlClicked:(id)sender
{
	DDPageControl *thePageControl = (DDPageControl *)sender ;
	
	// we need to scroll to the new index
	[photosScroll setContentOffset: CGPointMake(photosScroll.bounds.size.width * thePageControl.currentPage, photosScroll.contentOffset.y) animated: YES] ;
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

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)aScrollView
{
	// if we are animating (triggered by clicking on the page control), we update the page control
	[pageControl updateCurrentPageDisplay] ;
}


#pragma - mark 添加图片部分

- (void)createFirstSection
{
    firstBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, KFistSectionHeight)];
    firstBgView.backgroundColor = [UIColor clearColor];
    [bigBgScroll addSubview:firstBgView];
    
    photosScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(100, 10, 210, 90)];//和图片一样高
    photosScroll.backgroundColor = [UIColor clearColor];
    photosScroll.showsHorizontalScrollIndicator = NO;
    photosScroll.pagingEnabled = YES;
    photosScroll.contentSize = CGSizeZero;
    photosScroll.delegate = self;
    [firstBgView addSubview:photosScroll];
    
    
    addPhotoBtn = [self addPhotoButton];
    [firstBgView addSubview:addPhotoBtn];
    addPhotoBtn.center = firstBgView.center;
    
    photosArray = [NSMutableArray array];
    photoViewArray = [NSMutableArray array];
    
    [self createPageControl];
}

/**
 *  一定 添加图片按钮位置 以及 第一部分高度调整
 *
 *  @param isLeft 是否在左边
 */
- (void)moveAddPhotoBtnToLeft:(BOOL)isLeft
{
    CGFloat x = 0.0;
    CGFloat newHeight = 0.0;
    if (isLeft) {
        x = 10.f;
        newHeight = KFistSectionHeight + 30.f;
    }else
    {
        x = 160 - addPhotoBtn.width/2.0;
        newHeight = KFistSectionHeight;
    }
    CGRect photoFrame = addPhotoBtn.frame;
    photoFrame.origin.x = x;
    addPhotoBtn.frame = photoFrame;
    
    CGRect firstFrame = firstBgView.frame;
    firstFrame.size.height = newHeight;
    firstBgView.frame = firstFrame;
    
    CGRect secondFrame = secondBgView.frame;
    secondFrame.origin.y = firstBgView.bottom;
    secondBgView.frame = secondFrame;
    
    CGRect pubBtnFrame = publish.frame;
    pubBtnFrame.origin.y = secondBgView.bottom + 16;
    publish.frame = pubBtnFrame;
    
    bigBgScroll.contentSize = CGSizeMake(320, firstBgView.height + secondBgView.height + 16 + publish.height + 10);
}


//添加图片,移动scrollView 和 添加图片按钮 (并且控制是否显示 点)

- (void)updateScrollViewAndPhotoButton:(UIImage *)aImage
{
    if (aImage == nil) {
        return;
    }
    
    [self moveAddPhotoBtnToLeft:YES];
    
    CGSize scrollSize = photosScroll.contentSize;
    CGFloat scrollSizeWidth = scrollSize.width;
    
    __block typeof (UIScrollView *)weakScroll = photosScroll;
    __block typeof (NSMutableArray *)weakPhotoArray = photosArray;
    __block typeof (NSMutableArray *)weakPhotoViewArray = photoViewArray;
    __block typeof (SendCarViewController *)weakSelf = self;
    
    
    PhotoImageView *newImageV= [[PhotoImageView alloc]initWithFrame:CGRectMake(scrollSizeWidth + 15,0, 90, 90) image:aImage deleteBlock:^(UIImageView *deleteImageView, UIImage *deleteImage) {
        
        
        [weakPhotoViewArray removeObject:deleteImageView];
        [weakPhotoArray removeObject:aImage];
        [deleteImageView removeFromSuperview];
        
        weakScroll.contentSize = CGSizeMake(weakPhotoViewArray.count * (90 + 15), weakScroll.contentSize.height);
        
        [UIView animateWithDuration:0.5 animations:^{

            for (int i = 0; i < photoViewArray.count; i ++) {
                PhotoImageView *newImageV = (PhotoImageView *)[photoViewArray objectAtIndex:i];
                CGRect aFrame = newImageV.frame;
                aFrame.origin.x = 15 + (90 + 15) * i;
                newImageV.frame = aFrame;
            }
            
            if (weakPhotoViewArray.count == 0) {
                [weakSelf moveAddPhotoBtnToLeft:NO];
                [self controlPageControlDisplay:NO showPage:0 sumPage:0];
            }else
            {
                [self controlPageControlDisplay:YES showPage:weakPhotoArray.count sumPage:weakPhotoArray.count];
            }
            
        }];
        
    }];
    
    [photosScroll addSubview:newImageV];
    [photosArray addObject:aImage];
    [photoViewArray addObject:newImageV];
    
    [self controlPageControlDisplay:YES showPage:photosArray.count sumPage:photosArray.count];
    
    scrollSize.width = photoViewArray.count * (90 + 15);
    photosScroll.contentSize = scrollSize;
}

/**
 *  添加图片按钮
 */

- (UIButton *)addPhotoButton
{
    UIButton *addPhoto = [UIButton buttonWithType:UIButtonTypeCustom];
    addPhoto.frame = CGRectMake(0, 0, 90, 90);
    [addPhoto addTarget:self action:@selector(clickToAddPhoto:) forControlEvents:UIControlEventTouchUpInside];
    [addPhoto setBackgroundImage:[UIImage imageNamed:@"zhaoxiangji180_180"] forState:UIControlStateNormal];
    [self.view addSubview:addPhoto];
//    addPhoto.center = firstBgView.center;
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 63, addPhoto.width, 20)];
    title.text = @"添加照片";
    title.textColor = [UIColor colorWithHexString:@"8c8c8c"];
    title.font = [UIFont boldSystemFontOfSize:13];
    title.textAlignment = NSTextAlignmentCenter;
    [addPhoto addSubview:title];
    
    title.center = CGPointMake(addPhoto.width/2.0, title.center.y);
    
    return addPhoto;
}

/**
 *  添加图片按钮点击事件
 */

- (void)clickToAddPhoto:(UIButton *)button
{
    FBActionSheet *sheet = [[FBActionSheet alloc]initWithFrame:self.view.frame];
    [sheet actionBlock:^(NSInteger buttonIndex) {
        NSLog(@"%ld",(long)buttonIndex);
        if (buttonIndex == 0) {
            NSLog(@"拍照");
            
            [self clickToCamera:nil];
            
        }else if (buttonIndex == 1)
        {
            NSLog(@"相册");
            
            [self clickToAlbum:nil];
        }
        
    }];
}

//打开相册

- (IBAction)clickToAlbum:(id)sender {
    
    if (!imagePickerController)
    {
        imagePickerController = nil;
    }
    
    imagePickerController = [[QBImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsMultipleSelection = YES;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
    
    [self presentViewController:navigationController animated:YES completion:NULL];
    
//    BOOL is =  [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
//    if (is) {
//        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
//        picker.delegate = self;
//        
//        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//        
//        [self presentViewController:picker animated:YES completion:^{
//            
//        }];
//    }else
//    {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"不支持相册" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
//    }
}

//打开相机

- (IBAction)clickToCamera:(id)sender {
    
    BOOL is =  [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    if (is) {
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker animated:YES completion:^{
            if (IOS7_OR_LATER) {
                ((AppDelegate *)[[UIApplication sharedApplication] delegate]).statusBar.hidden = YES;
            }
        }];
    }else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"不支持相机" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}


#pragma - mark 条件选择部分

- (void)createSecondSection
{
    secondBgView = [[UIView alloc]initWithFrame:CGRectMake(10, firstBgView.bottom, 320 - 20, 45 * 6)];
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
    
    //价格特殊处理，需要输入
    
    UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 45*5, 100, 45.f)];
    priceLabel.backgroundColor = [UIColor clearColor];
    priceLabel.text = @"价格";
    priceLabel.textAlignment = NSTextAlignmentLeft;
    priceLabel.font = [UIFont systemFontOfSize:14];
    priceLabel.textColor = [UIColor blackColor];
    [secondBgView addSubview:priceLabel];
    
    priceTF = [[UITextField alloc]initWithFrame:CGRectMake(80 - 10, 45 * 5, 175, 45)];
    priceTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    priceTF.delegate = self;
    priceTF.backgroundColor = [UIColor clearColor];
    [secondBgView addSubview:priceTF];
    
    UILabel *hintLabel = [[UILabel alloc]initWithFrame:CGRectMake(300 - 35 - 10, 45 * 5, 35, 45.f)];
    hintLabel.backgroundColor = [UIColor clearColor];
    hintLabel.text = @"万元";
    hintLabel.textAlignment = NSTextAlignmentRight;
    hintLabel.font = [UIFont systemFontOfSize:14];
    hintLabel.textColor = [UIColor colorWithHexString:@"c7c7cc"];
    [secondBgView addSubview:hintLabel];
    
    //发布按钮
    
    publish = [UIButton buttonWithType:UIButtonTypeCustom];
    publish.frame = CGRectMake(10, secondBgView.bottom + 16, 300, 50);
    [publish setTitle:@"发布" forState:UIControlStateNormal];
    [publish setBackgroundImage:[UIImage imageNamed:@"huquyanzhengma_kedianji600_100"] forState:UIControlStateNormal];
    [publish addTarget:self action:@selector(clickToPublish:) forControlEvents:UIControlEventTouchUpInside];
    [bigBgScroll addSubview:publish];
    
    bigBgScroll.contentSize = CGSizeMake(320, firstBgView.height + secondBgView.height + 16 + publish.height + 10);
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
    [self.navigationController pushViewController:base animated:YES];
}

#pragma - mark 发布车源

- (void)clickToPublish:(UIButton *)btn
{
    if (photosArray.count > 0) {
        
        [self postImages:photosArray];
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
        
        [self updateScrollViewAndPhotoButton:image];
        
        [picker dismissViewControllerAnimated:NO completion:^{
            
            
        }];
        
    }
}

#pragma - mark QBImagePicker 代理

-(void)imagePickerControllerDidCancel:(QBImagePickerController *)aImagePickerController
{
    [aImagePickerController dismissViewControllerAnimated:YES completion:^{
        
    }];
}


-(void)imagePickerController1:(QBImagePickerController *)imagePickerController didFinishPickingMediaWithInfo:(id)info
{
    NSArray *mediaInfoArray = (NSArray *)info;
    
    NSMutableArray * allImageArray = [NSMutableArray array];
    
//    NSMutableArray * allAssesters = [[NSMutableArray alloc] init];
    
    for (int i = 0;i < mediaInfoArray.count;i++)
    {
        UIImage * image = [[mediaInfoArray objectAtIndex:i] objectForKey:@"UIImagePickerControllerOriginalImage"];
        
        UIImage * newImage = image;
        [allImageArray addObject:newImage];
        
        
        [self updateScrollViewAndPhotoButton:newImage];
        
        
//        NSURL * url = [[mediaInfoArray objectAtIndex:i] objectForKey:@"UIImagePickerControllerReferenceURL"];
//        
//        NSString * url_string = [[url absoluteString] stringByReplacingOccurrencesOfString:@"/" withString:@""];
//        
//        url_string = [url_string stringByAppendingString:@".png"];
//        
//        [allAssesters addObject:url_string];
//        
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
////            [ZSNApi saveImageToDocWith:url_string WithImage:image];
//        });
        
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)imagePickerControllerWillFinishPickingMedia:(QBImagePickerController *)imagePickerController
{
    
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
