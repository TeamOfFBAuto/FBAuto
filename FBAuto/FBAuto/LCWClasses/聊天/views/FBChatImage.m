//
//  FBChatImage.m
//  FBAuto
//
//  Created by lichaowei on 14-7-8.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "FBChatImage.h"

@implementation FBChatImage

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)showBigImage:(ClickBlock)clickBlock
{
    aBlock = clickBlock;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesBegan");
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesEnded");
    aBlock(self);
}

@end
