//
//  GfindCarTableViewCell.m
//  FBAuto
//
//  Created by gaomeng on 14-7-8.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "GfindCarTableViewCell.h"

#import "GfindCarViewController.h"

@implementation GfindCarTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = RGBCOLOR(238, 238, 238);
    }
    return self;
}




-(CGFloat)loadView:(NSIndexPath*)theIndexPath{
    
    NSLog(@"%s",__FUNCTION__);
    CGFloat height = 0;
    
    //多少次浏览
    UILabel *ciLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 18, 75, 13)];
    ciLable.backgroundColor = [UIColor orangeColor];
    ciLable.textAlignment = NSTextAlignmentCenter;
    ciLable.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:ciLable];
    
    //浏览
    UILabel *llLabel = [[UILabel alloc]initWithFrame:CGRectMake(28, CGRectGetMaxY(ciLable.frame)+4, 24, 13)];
    llLabel.font = [UIFont systemFontOfSize:12];
    llLabel.text = @"浏览";
    [self.contentView addSubview:llLabel];
    
    //白色竖条
    UIView *bview = [[UIView alloc]initWithFrame:CGRectMake(78, 0, 0.5, 60)];
    bview.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:bview];
    
    
    //内容label
    UILabel *cLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(bview.frame)+20, 15, 158, 15)];
    cLabel.backgroundColor = [UIColor purpleColor];
    [self.contentView addSubview:cLabel];
    
    //时间label
    UILabel *tLabel = [[UILabel alloc]initWithFrame:CGRectMake(cLabel.frame.origin.x, CGRectGetMaxY(cLabel.frame)+8, 80, 13)];
    tLabel.backgroundColor = [UIColor orangeColor];
    [self.contentView addSubview:tLabel];
    
    
    
    
    
    
    
    
    
    //操作按钮
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(287, 10, 20, 20);
    addBtn.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:addBtn];
    [addBtn addTarget:self action:@selector(tianjia) forControlEvents:UIControlEventTouchUpInside];
    NSLog(@"%@",theIndexPath);
    NSLog(@"delegate - %@",self.delegate.flagIndexPath);
    if (theIndexPath.row == self.delegate.flagIndexPath.row && theIndexPath.section == self.delegate.flagIndexPath.section) {
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 60, 320, 60)];
        view.backgroundColor = [UIColor orangeColor];
        addBtn.backgroundColor = [UIColor greenColor];
        [self.contentView addSubview:view];
        self.isGreen = 120;
        height = 120;
    }else{
        height = 60;
    }
    return height;
}


-(void)tianjia{
    
    if (self.addviewBlock) {
        self.addviewBlock();
    }
    
    
}



-(void)setAddviewBlock:(addViewBlock)addviewBlock{
    _addviewBlock = addviewBlock;
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
