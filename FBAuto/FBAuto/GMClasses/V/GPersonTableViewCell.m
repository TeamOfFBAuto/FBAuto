//
//  GPersonTableViewCell.m
//  FBAuto
//
//  Created by gaomeng on 14-7-7.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "GPersonTableViewCell.h"

@implementation GPersonTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(10, 0, 300, 44);
        btn.layer.cornerRadius = 4;
        btn.layer.borderWidth = 0.5;
        //btn.layer.borderColor = RGBCOLOR(<#r#>, <#g#>, <#b#>)
        
        
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
