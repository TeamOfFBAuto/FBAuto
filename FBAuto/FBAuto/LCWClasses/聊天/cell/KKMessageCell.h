//
//  KKMessageCell.h
//  XmppDemo
//

#import <UIKit/UIKit.h>
#import "FBChatHeader.h"
#import "OHAttributedLabel.h"

@interface KKMessageCell : UITableViewCell


@property(nonatomic, retain) UILabel *senderAndTimeLabel;
@property(nonatomic, retain) UITextView *messageContentView;
@property(nonatomic, retain) UIImageView *bgImageView;
@property(nonatomic,retain)OHAttributedLabel *OHLabel;

- (void)loadDataWithDic:(NSDictionary *)dict labelHeight:(CGFloat)labelHeight OHLabel:(OHAttributedLabel *)OHLabel;

@end
