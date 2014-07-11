//
//  GyhzyTableViewCell.m
//  FBAuto
//
//  Created by gaomeng on 14-7-11.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "GyhzyTableViewCell.h"

@implementation GyhzyTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
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





-(CGFloat)loadViewWithIndexPath:(NSIndexPath *)theIndexPath{
    CGFloat height = 0;
    
    if (theIndexPath.row == 0){//公司名 省份
        //图片
        UIImageView *imaV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 45, 45)];
        imaV.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:imaV];
        
        //公司全称
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imaV.frame)+10, 14, 240, 15)];
        nameLabel.font = [UIFont systemFontOfSize:15];
        nameLabel.backgroundColor = [UIColor purpleColor];
        [self.contentView addSubview:nameLabel];
        
        //省份
        UILabel *cityLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLabel.frame.origin.x, CGRectGetMaxY(nameLabel.frame)+8, 240, 15)];
        cityLabel.backgroundColor = [UIColor orangeColor];
        [self.contentView addSubview:cityLabel];
        
        //高度
        height = 65;
        
    }else if (theIndexPath.row == 1){//电话 地址
        
        
    }else if (theIndexPath.row == 2){//简介
        
    }
    
    return height;
}



@end
