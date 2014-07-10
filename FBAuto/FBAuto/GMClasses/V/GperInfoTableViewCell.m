//
//  GperInfoTableViewCell.m
//  FBAuto
//
//  Created by gaomeng on 14-7-10.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "GperInfoTableViewCell.h"

@implementation GperInfoTableViewCell

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
}



//加载控件并返回高度
-(CGFloat)loadViewWithIndexPath:(NSIndexPath*)theIndexPath{
    CGFloat height = 0;
    
    NSArray *titleArray = @[@"头像",@"姓名",@"地区",@"手机号",@"详细地址",@"简介"];
    
    //左右两个竖条
    for (int i = 0; i<2; i++) {
        UIView *shuView = [[UIView alloc]initWithFrame:CGRectMake(9.5+i*300, 0, 0.5, 44)];
        if (theIndexPath.row == 0) {
            shuView.frame = CGRectMake(9.5+i*300, 15, 0.5, 60);//竖条
            UIView *hengtiao = [[UIView alloc]initWithFrame:CGRectMake(10, 14.5+i*60, 300, 0.5)];
            hengtiao.backgroundColor = RGBCOLOR(220, 220, 220);
            [self.contentView addSubview:hengtiao];
        }
        shuView.backgroundColor = RGBCOLOR(220, 220, 220);
        [self.contentView addSubview:shuView];
    }
    
    
    
    //titile
    UILabel *titleLabel  = [[UILabel alloc]initWithFrame:CGRectMake(22, 15, 53, 14)];
    titleLabel.font = [UIFont systemFontOfSize:13];
    if (theIndexPath.row == 0) {
        titleLabel.frame = CGRectMake(22, 40, 53, 14);
    }
    titleLabel.text = titleArray[theIndexPath.row];
    [self.contentView addSubview:titleLabel];
    
    
    
    
    
    
    if (theIndexPath.row == 0) {
        height = 94;
    }else{
        height = 44;
    }
    
    
    return height;
}


@end
