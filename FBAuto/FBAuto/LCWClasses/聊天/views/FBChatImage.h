//
//  FBChatImage.h
//  FBAuto
//
//  Created by lichaowei on 14-7-8.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ ClickBlock) (UIImageView *imageView);

@interface FBChatImage : UIImageView
{
    ClickBlock aBlock;
}

- (void)showBigImage:(ClickBlock )clickBlock;

@end
