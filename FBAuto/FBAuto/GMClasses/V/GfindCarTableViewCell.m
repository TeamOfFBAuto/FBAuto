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
    }
    return self;
}




-(CGFloat)loadView:(NSIndexPath*)theIndexPath{
    
    NSLog(@"%s",__FUNCTION__);
    CGFloat height = 0;
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
