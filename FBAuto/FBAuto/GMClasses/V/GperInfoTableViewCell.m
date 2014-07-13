//
//  GperInfoTableViewCell.m
//  FBAuto
//
//  Created by gaomeng on 14-7-10.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "GperInfoTableViewCell.h"
#import "GperInfoViewController.h"

#import "GjjxxViewController.h"//简介 和 详细的界面

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
    
    
    NSArray *titleArray = @[@"姓名",@"地区",@"手机号",@"详细地址",@"简介"];
    
    
    
    if (theIndexPath.section == 0) {//头像
        
        height = 95;
        
        //框
        UIButton *kuang = [[UIButton alloc]initWithFrame:CGRectMake(10, 15, 300, 64)];
        kuang.layer.borderWidth = 0.5;
        kuang.layer.borderColor = [RGBCOLOR(220, 220, 220)CGColor];
        
        //title
        UILabel *titielLabel = [[UILabel alloc]initWithFrame:CGRectMake(22, 40, 30, 15)];
        titielLabel.font = [UIFont systemFontOfSize:15];
        titielLabel.text = @"头像";
        
        //头像imageview
        UIImageView *touxiangImv = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titielLabel.frame)+187, 25, 45, 45)];
        touxiangImv.backgroundColor = [UIColor redColor];
        
        
        
        //添加视图
        [self.contentView addSubview:kuang];
        [self.contentView addSubview:titielLabel];
        [self.contentView addSubview:touxiangImv];
        
        
    }else if (theIndexPath.section == 1){//详细信息
        
        height = 44;
        
        //框
        UIButton *kuang = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, 300, 44)];
        kuang.layer.borderWidth = 0.5;
        kuang.layer.borderColor = [RGBCOLOR(220, 220, 220)CGColor];
        
        //遮挡底部边框重合的部分
        UIView *diview = [[UIView alloc]initWithFrame:CGRectMake(10, 44, 300, 0.5)];
        diview.backgroundColor = [UIColor whiteColor];
        
        //title
        UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(22, 15, 60, 15)];
        titleLable.font = [UIFont systemFontOfSize:15];
        titleLable.backgroundColor = [UIColor grayColor];
        titleLable.text = titleArray[theIndexPath.row];
        
        
        //内容label
        UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLable.frame)+130, titleLable.frame.origin.y, 90, titleLable.frame.size.height)];
        contentLabel.font = [UIFont systemFontOfSize:15];
        contentLabel.backgroundColor = [UIColor redColor];
        
        
        //添加视图
        [self.contentView addSubview:kuang];
        [self.contentView addSubview:titleLable];
        [self.contentView addSubview:diview];
        [self.contentView addSubview:contentLabel];
        
        
        //功能
        if (theIndexPath.row == 3 || theIndexPath.row == 4) {
            [kuang addTarget:self action:@selector(tui) forControlEvents:UIControlEventTouchUpInside];
        }
        
        
        
        
        
    }
    
    
    
    
    
    
    
    return height;
}





-(void)tui{
    [self.delegate.navigationController pushViewController:[[GjjxxViewController alloc]init] animated:YES];
}


@end
