//
//  PhotoImageView.m
//  FBAuto
//
//  Created by lichaowei on 14-7-2.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "PhotoImageView.h"

@implementation PhotoImageView
{
    UIImage *aImage;
}

- (id)initWithFrame:(CGRect)frame image:(UIImage*)image deleteBlock:(DeleteBlock)aBlock
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.userInteractionEnabled = YES;
        
        deleteBlock = aBlock;
        aImage = image;
        
        self.image = image;
        
        UIButton *delete = [UIButton buttonWithType:UIButtonTypeCustom];
        delete.frame = CGRectMake(self.width - 20, 0, 20, 20);
        [delete addTarget:self action:@selector(clickToDelete:) forControlEvents:UIControlEventTouchUpInside];
        [delete setBackgroundImage:[UIImage imageNamed:@"quxiao40_40"] forState:UIControlStateNormal];
        [self addSubview:delete];
    }
    return self;
}

- (void)clickToDelete:(UIButton *)btn
{
    deleteBlock(self,aImage);
}

@end
