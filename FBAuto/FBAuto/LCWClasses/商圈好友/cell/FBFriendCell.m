//
//  FBFriendCell.m
//  FBAuto
//
//  Created by lichaowei on 14-7-3.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "FBFriendCell.h"

@implementation FBFriendCell

- (void)awakeFromNib
{
    // Initialization code
    NSLog(@"---");
    self.bgView.layer.borderWidth = 0.5f;
    self.bgView.layer.borderColor = [UIColor colorWithHexString:@"b4b4b4"].CGColor;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)clickToDial:(id)sender {
    
    NSString *num = [[NSString alloc] initWithFormat:@"tel://%@",@"18612389982"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]];
    
}
- (IBAction)clickToChat:(id)sender {
    cellBlock(@"okoko");
}

/**
 *  赋值
 */

- (void)getCellData:(NSString *)test cellBlock:(CellBlock)aCellBlock
{
    cellBlock = aCellBlock;
}

@end
