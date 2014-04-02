//
//  CommentCell.h
//  SecretTestApp
//
//  Created by Aaron Pang on 3/29/14.
//  Copyright (c) 2014 Aaron Pang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentCell : UITableViewCell

extern const CGFloat kCommentPaddingFromLeft;
extern const CGFloat kCommentPaddingFromRight;

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *commentLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *likeCountLabel;
@property (nonatomic, strong) UIImageView *likeCountImageView;
@property (nonatomic, strong) UIButton *likeButton;
@end
