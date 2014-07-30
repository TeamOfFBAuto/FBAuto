//
//  GxiaoxiTableViewCell.m
//  FBAuto
//
//  Created by gaomeng on 14-7-24.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "GxiaoxiTableViewCell.h"

#import "GxiaoxiViewController.h"

@implementation GxiaoxiTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        //头像
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 45, 45)];
        imageView.backgroundColor = RGBCOLOR(180, 180, 180);
        [self.contentView addSubview:imageView];
        self.headImageView = imageView;
        
        
        //姓名
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+6, CGRectGetMinY(imageView.frame)+3, 150, 17)];
        nameLabel.backgroundColor = [UIColor redColor];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        
        //时间
        UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(nameLabel.frame)+10, nameLabel.frame.origin.y+4, 90, 13)];
        timeLabel.font = [UIFont systemFontOfSize:12];
        timeLabel.backgroundColor = [UIColor redColor];
        timeLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:timeLabel];
        self.timeLabel = timeLabel;
        
        //内容
        UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLabel.frame.origin.x, CGRectGetMaxY(nameLabel.frame)+8, 250, 15)];
        contentLabel.backgroundColor = [UIColor redColor];
        contentLabel.textAlignment = NSTextAlignmentLeft;
        contentLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:contentLabel];
        
        
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}




-(void)configWithData:(XMPPMessageModel *)model{
    NSString *imageUrlUtf8 = [LCWTools md5:model.fromId];
    NSString *jiequ = [imageUrlUtf8 substringFromIndex:imageUrlUtf8.length-4];
    
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
