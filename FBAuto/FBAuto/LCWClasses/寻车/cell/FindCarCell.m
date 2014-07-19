//
//  FindCarCell.m
//  FBAuto
//
//  Created by lichaowei on 14-7-18.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "FindCarCell.h"
#import "CarSourceClass.h"

@implementation FindCarCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellDataWithModel:(CarSourceClass *)aCar
{
    
    self.contentLabel.text = @"发河北 寻美规 奥迪Q7 14款 豪华";
    self.moneyLabel.text = @"已交定金";
    self.nameLabel.text = @"张三";
    self.timeLabel.text = [LCWTools timechange:aCar.dateline];
}

@end
