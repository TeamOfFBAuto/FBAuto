//
//  GptzTableViewCell.m
//  FBAuto
//
//  Created by gaomeng on 14-7-9.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "GptzTableViewCell.h"


#import "GTimeSwitch.h"//时间处理类

@implementation GptzTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        //内容
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 25, 185, 17)];
        label.backgroundColor = [UIColor purpleColor];
        
        //时间
        UILabel *lable1 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label.frame)+28, 25, 90, 17)];
        lable1.backgroundColor = [UIColor orangeColor];
        
        [self.contentView addSubview:label];
        [self.contentView addSubview:lable1];
        
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
