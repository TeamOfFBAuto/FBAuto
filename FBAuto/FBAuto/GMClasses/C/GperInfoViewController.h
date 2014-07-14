//
//  GperInfoViewController.h
//  FBAuto
//
//  Created by gaomeng on 14-7-10.
//  Copyright (c) 2014年 szk. All rights reserved.
//



//个人中心 我的资料
#import <UIKit/UIKit.h>

#import "MLImageCrop.h"//截图

//网络相关
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"


@class GperInfoTableViewCell;

@interface GperInfoViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MLImageCropDelegate,ASIHTTPRequestDelegate>

{
    UITableView *_tableview;//主tableview
    
    GperInfoTableViewCell *_tmpCell;//临时cell用户获取单元格高度
    
    
}

@property(nonatomic,strong)NSString *userName;//用户名
@property(nonatomic,strong)NSString *area;//地区
@property(nonatomic,strong)NSString *phoneNum;//手机号
@property(nonatomic,strong)NSString *address;//地址
@property(nonatomic,strong)NSString *jianjie;//简介

//头像相关
@property(nonatomic,strong)UIImage *userUpFaceImage;//用户需要上传的头像image
@property(nonatomic,strong)NSData *userUpFaceImagedata;//用户上传头像data



@end
