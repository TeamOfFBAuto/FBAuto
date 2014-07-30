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
        [self.contentView addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        
        //时间
        UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(nameLabel.frame)+10, nameLabel.frame.origin.y, 95, 13)];
        timeLabel.font = [UIFont systemFontOfSize:12];
        timeLabel.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:timeLabel];
        self.timeLabel = timeLabel;
        
        //内容
        UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLabel.frame.origin.x, CGRectGetMaxY(nameLabel.frame)+8, 250, 15)];
        contentLabel.backgroundColor = [UIColor redColor];
        contentLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:contentLabel];
        
        
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}




-(CGFloat)loadViewWithIndexPath:(NSIndexPath *)theIndexPath;{
    CGFloat height = 65.0f;
    
    return height;
}

-(void)configWithNetData:(NSMutableArray*)array indexPath:(NSIndexPath*)theIndexPath{
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
