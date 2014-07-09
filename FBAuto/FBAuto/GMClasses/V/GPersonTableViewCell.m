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
        
        viewTag++;
        
        
        self.kuang = [[UIView alloc]initWithFrame:CGRectMake(10, 0, 300, 44)];
        self.kuang.layer.borderWidth = 0.5;
        self.kuang.layer.borderColor = [RGBCOLOR(220, 220, 220)CGColor];
        [self.contentView addSubview:self.kuang];
        self.kuang.tag = viewTag;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gdoTap:)];
        [self.kuang addGestureRecognizer:tap];
        
        self.titileLabel= [[UILabel alloc]initWithFrame:CGRectMake(12, 14, 60, 17)];
        self.titileLabel.font = [UIFont systemFontOfSize:15];
        //self.titileLabel.backgroundColor = [UIColor orangeColor];
        [self.contentView addSubview:self.titileLabel];
        
        
    }
    return self;
}


//block的set方法
-(void)setKuangBlock:(kuangBlock)kuangBlock{
    _kuangBlock = kuangBlock;
}



//给标题赋值
-(void)dataWithTitleLableWithIndexPath:(NSIndexPath *)theIndexPatch{
    
    if (theIndexPatch.row == 0 && theIndexPatch.section == 0) {
        self.titileLabel.text = @"我的资料";
    }else if (theIndexPatch.row == 1 && theIndexPatch.section == 0){
        self.titileLabel.text = @"我的车源";
    }else if (theIndexPatch.row == 2 && theIndexPatch.section == 0){
        self.titileLabel.text = @"我的寻车";
    }else if (theIndexPatch.row == 3 && theIndexPatch.section == 0){
        self.titileLabel.text = @"我的收藏";
    }else if (theIndexPatch.row == 0 && theIndexPatch.section == 1){
        self.titileLabel.text = @"修改密码";
    }else if (theIndexPatch.row == 1 && theIndexPatch.section == 1){
        self.titileLabel.text = @"联系我们";
    }else if (theIndexPatch.row == 2 && theIndexPatch.section == 1){
        self.titileLabel.text = @"消息设置";
    }
    
}






-(void)gdoTap:(UITapGestureRecognizer *)sender{
    
    if (self.kuangBlock) {
        self.kuangBlock(sender.view.tag);
    }
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
