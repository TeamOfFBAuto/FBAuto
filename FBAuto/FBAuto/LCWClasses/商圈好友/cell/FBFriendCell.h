//
//  FBFriendCell.h
//  FBAuto
//
//  Created by lichaowei on 14-7-3.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ CellBlock) (NSString *friendInfo);

@interface FBFriendCell : UITableViewCell
{
    CellBlock cellBlock;
}

@property (strong, nonatomic) IBOutlet UIView *bgView;

@property (strong, nonatomic) IBOutlet UIImageView *iconImage;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIButton *saleTypeLabel;//类型,个人或者商家等
@property (strong, nonatomic) IBOutlet UILabel *phoneNumLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
- (IBAction)clickToDial:(id)sender;//电话
- (IBAction)clickToChat:(id)sender;

- (void)getCellData:(NSString *)test cellBlock:(CellBlock)aCellBlock;

@end
