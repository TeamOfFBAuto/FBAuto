//
//  LShareSheetView.h
//  FBAuto
//
//  Created by lichaowei on 14-7-24.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  分享 sheetView
 */

typedef void(^ ActionBlock) (NSInteger buttonIndex);

@interface LShareSheetView : UIView
{
    ActionBlock actionBlock;
    UIView *bgView;
}

- (void)actionBlock:(ActionBlock)aBlock;

@end
