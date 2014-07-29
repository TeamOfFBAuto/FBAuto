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
