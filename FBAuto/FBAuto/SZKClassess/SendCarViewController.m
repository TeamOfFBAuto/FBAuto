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

#import "Menu_Header.h"

#import "FBDetail2Controller.h"

#import "DXAlertView.h"

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
    
    UITextField *priceTF;//价格输入
    UITextField *descriptionTF;//车源描述输入
    
    //车源列表参数
    NSString *_car;//  车型id
    NSString *_price;// 价格
    int _spot_future;// 现货或者期货id
    int _color_out;// 外观颜色id
    int _color_in;// 内饰颜色id
    int _carfrom;// 汽车规格id（美规，中规）
    NSString *_cardiscrib;// 车源描述
    NSString *_photo;// 图片id（用逗号隔开）
    
    BOOL isShowKeyboard;//键盘是否已经显示
    
    MBProgressHUD *loadingHub;
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

-(id)initWithStyle:(ActionStyle)aStyle
{
    self = [super init];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.view.backgroundColor=RGBCOLOR(220, 233, 3);

    // Do any additional setup after loading the view.
    
    if (self.actionStyle == Action_Add) {
        
        self.titleLabel.text = @"发布车源";
        self.button_back.hidden = YES;
        
    }else if (self.actionStyle == Action_Edit)
    {
        self.titleLabel.text = @"修改车源";
        
        [self getSingleCarInfoWithId:self.infoId];//获取单个车源信息
    }
    
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
    
    loadingHub = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:loadingHub];
	loadingHub.labelText = @"发布中...";

}


- (void)didReceiveMemoryWarning

{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showMBProgressWithText:(NSString *)text
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = text;
    hud.margin = 10.f;
    hud.yOffset = 150.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1];
}

#pragma - mark 网络请求

#pragma - mark 发布车源

- (void)publishCarSource
{
    
    NSString *descrip = descriptionTF.text;
    descrip = descrip ? descrip : @"无";
    
    NSString *url = @"0";
    
    _photo = _photo ? _photo : @"";
    
    if (self.actionStyle == Action_Add) {
        
        url = [NSString stringWithFormat:@"%@&authkey=%@&car=%@&spot_future=%d&color_out=%d&color_in=%d&carfrom=%d&cardiscrib=%@&price=%@&photo=%@",FBAUTO_CARSOURCE_ADD_SOURCE,[GMAPI getAuthkey],_car,_spot_future,_color_out,_color_in,_carfrom,descrip,priceTF.text,_photo];
        
        NSLog(@"发布车源 %@",url);
        
    }else if (self.actionStyle == Action_Edit)
    {
        url = [NSString stringWithFormat:@"%@&authkey=%@&cid=%@&car=%@&spot_future=%d&color_out=%d&color_in=%d&carfrom=%d&cardiscrib=%@&price=%@&photo=%@",FBAUTO_CARSOURCE_EDIT,[GMAPI getAuthkey],self.infoId,_car,_spot_future,_color_out,_color_in,_carfrom,descrip,priceTF.text,_photo];
        
        NSLog(@"修改车源 %@",url);
    }
    
    __weak typeof(self)weakSelf = self;
    
    LCWTools *tool = [[LCWTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"车源 result %@, erro%@",result,[result objectForKey:@"errinfo"]);
        
        [loadingHub hide:NO];
        
//        [self showMBProgressWithText:[result objectForKey:@"errinfo"]];
        
        [self refreshUI];
        
        DXAlertView *alert = [[DXAlertView alloc]initWithTitle:@"寻车发布成功" contentText:nil leftButtonTitle:nil rightButtonTitle:@"确定" isInput:NO];
        [alert show];
        
        alert.rightBlock = ^(){
            NSLog(@"取消");
            
            int infoId = [[result objectForKey:@"datainfo"]integerValue];
            
            [weakSelf clickToDetail:[NSString stringWithFormat:@"%d",infoId]];
            
        };

    }failBlock:^(NSDictionary *failDic, NSError *erro) {
        [LCWTools showMBProgressWithText:[failDic objectForKey:ERROR_INFO] addToView:self.view];
    }];
    
}

#pragma - mark 编辑车源

- (void)editeCarSource
{
    
    NSString *descrip = descriptionTF.text;
    descrip = descrip ? descrip : @"无";
    NSString *url = [NSString stringWithFormat:@"%@&authkey=%@&car=%@&spot_future=%d&color_out=%d&color_in=%d&carfrom=%d&cardiscrib=%@&price=%@&photo=%@",FBAUTO_CARSOURCE_ADD_SOURCE,[GMAPI getAuthkey],_car,_spot_future,_color_out,_color_in,_carfrom,descrip,priceTF.text,_photo];
    
    NSLog(@"车源列表 %@",url);
    
    __weak typeof(self)weakSelf = self;
    
    LCWTools *tool = [[LCWTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"车源发布 result %@, erro%@",result,[result objectForKey:@"errinfo"]);
        
        [loadingHub hide:NO];
        
        [weakSelf showMBProgressWithText:@"车源信息发布成功"];
        
        [weakSelf refreshUI];
        
    }failBlock:^(NSDictionary *failDic, NSError *erro) {
        [LCWTools showMBProgressWithText:[failDic objectForKey:ERROR_INFO] addToView:self.view];
    }];
    
}

/**
 *  跳转到 车源详情页
 *
 *  @param infoId 车源信息id
 *  @param car    汽车编码
 */

- (void)clickToDetail:(NSString *)infoId
{
    FBDetail2Controller *detail = [[FBDetail2Controller alloc]init];
    detail.style = Navigation_Special;
    detail.navigationTitle = @"详情";
    detail.infoId = infoId;
    detail.carId = _car;
    detail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];
    
}

#pragma - mark 网络请求

- (void)getSingleCarInfoWithId:(NSString *)carId
{
    NSString *url = [NSString stringWithFormat:FBAUTO_CARSOURCE_SINGLE_SOURE,carId];
    
    NSLog(@"单个车源信息 %@",url);
    
    LCWTools *tool = [[LCWTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"单个车源发布 result %@, erro%@",result,[result objectForKey:@"errinfo"]);
        
        NSArray *dataInfo = [result objectForKey:@"datainfo"];
        
        if (dataInfo.count == 0) {
            return ;
        }
        
        NSDictionary *dic = [dataInfo objectAtIndex:0];
        
        //车辆图片
        
        [self labelWithTag:100].text = [dic objectForKey:@"car_name"];
        _car = [dic objectForKey:@"car"];
        [self labelWithTag:101].text = [dic objectForKey:@"carfrom"];
        _carfrom = (int)[MENU_STANDARD indexOfObject:[dic objectForKey:@"carfrom"]];
        
        [self labelWithTag:102].text = [dic objectForKey:@"spot_future"];
        
        _spot_future = (int)[MENU_TIMELIMIT indexOfObject:[dic objectForKey:@"spot_future"]];
        
        [self labelWithTag:103].text = [dic objectForKey:@"color_out"];
        
        _color_out = (int)[MENU_HIGHT_OUTSIDE_CORLOR indexOfObject:[dic objectForKey:@"color_out"]];
        
        [self labelWithTag:104].text = [dic objectForKey:@"color_in"];
        
        _color_in = (int)[MENU_HIGHT_INSIDE_CORLOR indexOfObject:[dic objectForKey:@"color_in"]];
        
        priceTF.text = [dic objectForKey:@"price"];
        descriptionTF.text = [dic objectForKey:@"cardiscrib"];
        
        NSArray *image = [dic objectForKey:@"image"];
        NSMutableArray *imageUrls = [NSMutableArray arrayWithCapacity:image.count];
        
        for (NSDictionary *aImageDic in image) {
            
            NSString *url = [aImageDic objectForKey:@"link"];
            NSString *imageId = [aImageDic objectForKey:@"imgid"];
            [imageUrls addObject:url];
            
            [photosArray addObject:imageId];//编辑的时候里面开始存放的是 图片id
            
            [self updateScrollViewAndPhotoButton:nil imageUrl:url];
        }
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        NSLog(@"failDic %@",failDic);
        [LCWTools showMBProgressWithText:[failDic objectForKey:ERROR_INFO] addToView:self.view];
    }];
}

- (UILabel *)labelWithTag:(int)aTag
{
    Section_Button *btn = (Section_Button *)[secondBgView viewWithTag:aTag];
    return btn.contentLabel;
}


#pragma - mark 发布成功之后 UI复原

- (void)refreshUI
{
    
    [photosArray removeAllObjects];
    
    for (PhotoImageView *aImageV in photoViewArray) {
        [aImageV removeFromSuperview];
    }
    [photoViewArray removeAllObjects];

    
    [UIView animateWithDuration:0.5 animations:^{
        
        if (photosArray.count == 0) {
            [self moveAddPhotoBtnToLeft:NO];
            [self controlPageControlDisplay:NO showPage:0 sumPage:0];
        }
    }];
    
    CGSize scrollSize = photosScroll.contentSize;
    scrollSize.width = photoViewArray.count * (90 + 15);
    photosScroll.contentSize = scrollSize;
    
    
    priceTF.text = @"";
    descriptionTF.text = @"";
    
    for (int i = 0; i < 5; i ++) {
        Section_Button *btn = (Section_Button *)[secondBgView viewWithTag:100 + i];
        btn.contentLabel.text = @"";
    }
    
    if (self.actionStyle == Action_Edit) {
        [self performSelector:@selector(clickToBack:) withObject:nil afterDelay:0.5];
    }
    
}

#pragma - mark 图片上传

- (void)postImages:(NSArray *)allImages
{
    [loadingHub show:YES];
    
    
    //挑选 imageId 和 image
    
    NSMutableArray *ids = [NSMutableArray array];
    NSMutableArray *images = [NSMutableArray array];
    for (id aObject in allImages) {
        if ([aObject isKindOfClass:[UIImage class]]) {
            
            NSLog(@"aObject %@",aObject);
            [images addObject:aObject];
            
        }else
        {
            [ids addObject:aObject];
            NSLog(@"ids %@",aObject);
        }
    }
    
    if (ids.count == allImages.count) { //说明全是 imageId,那么不需要再上传图片了,直接执行下一步
        
        _photo = [ids componentsJoinedByString:@","];
        NSLog(@"aObject %@",_photo);
        [self publishCarSource];
        
        return;
        
    }else
    {
        allImages = images; //全是图片
    }
    
    
    NSString* url = [NSString stringWithFormat:FBAUTO_CARSOURCE_ADD_PIC];
    
    ASIFormDataRequest *uploadImageRequest= [ ASIFormDataRequest requestWithURL : [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ]];
    
    [uploadImageRequest setStringEncoding:NSUTF8StringEncoding];
    
    [uploadImageRequest setRequestMethod:@"POST"];
    
    [uploadImageRequest setResponseEncoding:NSUTF8StringEncoding];

    [uploadImageRequest setPostValue:[GMAPI getAuthkey] forKey:@"authkey"];
    
    [uploadImageRequest setPostFormat:ASIMultipartFormDataPostFormat];
    
    for (int i = 0;i < allImages.count; i ++)
        
    {
        UIImage *eImage  = [allImages objectAtIndex:i];
        
        
        UIImage * newImage = [SzkAPI scaleToSizeWithImage:eImage size:CGSizeMake(eImage.size.width>1024?1024:eImage.size.width,eImage.size.width>1024?eImage.size.height*1024/eImage.size.width:eImage.size.height)];
        
        NSData *imageData=UIImageJPEGRepresentation(newImage,1);
        
        NSString *photoName=[NSString stringWithFormat:@"FBAuto%d.png",i];
        
        NSLog(@"photoName:%@",photoName);
        
        [uploadImageRequest addData:imageData withFileName:photoName andContentType:@"image/png" forKey:@"photo[]"];
    }
    
    [uploadImageRequest setDelegate : self ];
    
    [uploadImageRequest startAsynchronous];
    
    __weak typeof(ASIFormDataRequest *)weakRequst = uploadImageRequest;
    //完成
    [uploadImageRequest setCompletionBlock:^{
        
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:weakRequst.responseData options:0 error:nil];
        
        if ([result isKindOfClass:[NSDictionary class]]) {
            
            int erroCode = [[result objectForKey:@"errcode"]intValue];
            NSString *erroInfo = [result objectForKey:@"errinfo"];
            
            [loadingHub hide:YES];
            
            if (erroCode != 0) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:erroInfo delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                
                return ;
            }
            
            NSArray *dataInfo = [result objectForKey:@"datainfo"];
            NSMutableArray *imageIdArr = [NSMutableArray arrayWithCapacity:dataInfo.count];
            
            for (NSDictionary *imageDic in dataInfo) {
                NSString *imageId = [imageDic objectForKey:@"imageid"];
                [imageIdArr addObject:imageId];
            }
            
            if (ids.count > 0) {
                for (NSString *aId in ids) {
                    [imageIdArr addObject:aId];
                }
            }
            
            _photo = [imageIdArr componentsJoinedByString:@","];
            
            __weak typeof(SendCarViewController *)weakSelf = self;
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                [weakSelf publishCarSource];
                
            });
        }

        
    }];
    
    //失败
    [uploadImageRequest setFailedBlock:^{
        
        NSLog(@"uploadFail %@",weakRequst.responseString);
        
        [loadingHub hide:YES];
        
        [LCWTools showMBProgressWithText:@"上传失败，重新发布" addToView:self.view];
        
    }];

}


#pragma - mark 价格输入框

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    isShowKeyboard = YES;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        bigBgScroll.contentOffset = CGPointMake(0, iPhone5 ? 200 : 150 + 101);
        bigBgScroll.scrollEnabled = NO;
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (isShowKeyboard) {
        return;
    }
    [UIView animateWithDuration:0.5 animations:^{
        
        bigBgScroll.contentOffset = CGPointMake(0, 0);
        bigBgScroll.scrollEnabled = YES;
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    isShowKeyboard = NO;
    [priceTF resignFirstResponder];
    [descriptionTF resignFirstResponder];
    return YES;
}

- (void)clickToHideKeyboard
{
    isShowKeyboard = NO;
    [priceTF resignFirstResponder];
    [descriptionTF resignFirstResponder];
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

- (void)updateScrollViewAndPhotoButton:(UIImage *)aImage imageUrl:(NSString *)imageUrl
{
    if (aImage == nil && imageUrl == Nil) {
        return;
    }
    
    [self moveAddPhotoBtnToLeft:YES];
    
    CGSize scrollSize = photosScroll.contentSize;
    CGFloat scrollSizeWidth = scrollSize.width;
    
    __weak typeof (UIScrollView *)weakScroll = photosScroll;
    __weak typeof (NSMutableArray *)weakPhotoArray = photosArray;
    __weak typeof (NSMutableArray *)weakPhotoViewArray = photoViewArray;
    __weak typeof (SendCarViewController *)weakSelf = self;
    
    
    PhotoImageView *newImageV= [[PhotoImageView alloc]initWithFrame:CGRectMake(scrollSizeWidth + 15,0, 90, 90) image:aImage deleteBlock:^(UIImageView *deleteImageView, UIImage *deleteImage) {
        
        
        int deleteIndex = (int)[weakPhotoViewArray indexOfObject:deleteImageView];
        [weakPhotoArray removeObjectAtIndex:deleteIndex];
        
        [weakPhotoViewArray removeObject:deleteImageView];
//        [weakPhotoArray removeObject:aImage];
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
    
    //有可能是图片的网络地址
    
    if (imageUrl) {
        
        [newImageV sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"detail_test"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
//            [photosArray addObject:image];
            
        }];
    }else
    {
        [photosArray addObject:aImage];
    }
    
    [photosScroll addSubview:newImageV];
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
                ((AppDelegate *)[[UIApplication sharedApplication] delegate]).statusBarBack.hidden = YES;
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
    secondBgView = [[UIView alloc]initWithFrame:CGRectMake(10, firstBgView.bottom, 320 - 20, 45 * 7)];
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
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 45*5, 300, 0.5)];
    line1.backgroundColor = [UIColor colorWithHexString:@"b4b4b4"];
    [secondBgView addSubview:line1];
    
    [secondBgView addSubview:[self createLabelFrame:CGRectMake(10, 45*5, 100, 45.f) text:@"价格" alignMent:NSTextAlignmentLeft textColor:[UIColor blackColor]]];
    
    priceTF = [[UITextField alloc]initWithFrame:CGRectMake(80 - 10, 45 * 5, 175, 45)];
    priceTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    priceTF.delegate = self;
    priceTF.backgroundColor = [UIColor clearColor];
    [secondBgView addSubview:priceTF];
    
    [secondBgView addSubview:[self createLabelFrame:CGRectMake(300 - 35 - 10, 45 * 5, 35, 45.f) text:@"万元" alignMent:NSTextAlignmentRight textColor:[UIColor colorWithHexString:@"c7c7cc"]]];
    
    //车源描述，需要输入
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 45*6, 300, 1)];
    line2.backgroundColor = [UIColor colorWithHexString:@"b4b4b4"];
    [secondBgView addSubview:line2];
    
    [secondBgView addSubview:[self createLabelFrame:CGRectMake(10, 45*6, 100, 45.f) text:@"车源描述" alignMent:NSTextAlignmentLeft textColor:[UIColor blackColor]]];
    
    descriptionTF = [[UITextField alloc]initWithFrame:CGRectMake(80 - 10, 45 * 6, 175, 45)];
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
    
    if (self.actionStyle == Action_Edit) {
        base.rootVC = self;
    }
    
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
    
    Section_Button *btn1 = (Section_Button *)[secondBgView viewWithTag:100];
    
    if (btn1.contentLabel.text == nil || [btn1.contentLabel.text isEqualToString:@""])
    {
        [self alertText:@"请选择车型"];

        return;
    }
    
    for (int i = 0; i < 5; i ++) {
        
        Section_Button *btn1 = (Section_Button *)[secondBgView viewWithTag:100 + i];
        
        if (btn1.contentLabel.text == nil || [btn1.contentLabel.text isEqualToString:@""])
        {
            if (i == 0) {
                
                [self alertText:@"请选择车型"];
                
            }else if (i == 1)
            {
                [self alertText:@"请选择规格"];
                
            }else if (i == 2)
            {
                [self alertText:@"请选择期限"];
                
            }else if (i == 3)
            {
                [self alertText:@"请选择外观颜色"];
                
            }else if (i == 4)
            {
                [self alertText:@"请选择内饰颜色"];
            }
            
            return;
        }
    }
    
    
    if ([LCWTools isValidateFloat:priceTF.text] || [LCWTools isValidateInt:priceTF.text]) {
        
        NSLog(@"%@有效数字",priceTF.text);
        
        [self postImages:photosArray];
        
    }else
    {
        [self alertText:@"价格需要输入有效数字"];
    }
}

- (void)alertText:(NSString *)text
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:text delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

#pragma - mark imagePicker 代理

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:@"public.image"]) {
        
        //压缩图片 不展示原图
        UIImage *originImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        
        UIImage * scaleImage = [SzkAPI scaleToSizeWithImage:originImage size:CGSizeMake(originImage.size.width>1024?1024:originImage.size.width,originImage.size.width>1024?originImage.size.height*1024/originImage.size.width:originImage.size.height)];
//        UIImage *scaleImage = [self scaleImage:originImage toScale:0.5];
        
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
        
        [self updateScrollViewAndPhotoButton:image imageUrl:nil];
        
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
        
        
        [self updateScrollViewAndPhotoButton:newImage imageUrl:nil];
        
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
