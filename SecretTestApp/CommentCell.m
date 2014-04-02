//
//  CommentCell.m
//  SecretTestApp
//
//  Created by Aaron Pang on 3/29/14.
//  Copyright (c) 2014 Aaron Pang. All rights reserved.
//

#import "CommentCell.h"
#import "UIFont+SecretFont.h"

@implementation CommentCell {
    NSInteger _likeCount;
}
const CGFloat kCommentPaddingFromTop = 4.0f;
const CGFloat kCommentPaddingFromLeft = 10.0f;
const CGFloat kCommentPaddingFromRight = 8.0f;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 35, 35)];
        // Go Toronto!
        self.iconView.image =[UIImage imageNamed:@"bluejay.jpg"];
        self.iconView.layer.cornerRadius = CGRectGetWidth(self.iconView.frame) / 2.0f;
        self.iconView.layer.masksToBounds = YES;
        [self addSubview:self.iconView];
        
        self.commentLabel = [[UILabel alloc] init];
        self.commentLabel.textColor = [UIColor blackColor];
        self.commentLabel.textAlignment = NSTextAlignmentLeft;
        self.commentLabel.font = [UIFont secretFontLightWithSize:16.f];
        self.commentLabel.numberOfLines = 0;
        self.commentLabel.frame = (CGRect){.origin = {CGRectGetMinX(self.iconView.frame) + CGRectGetWidth(self.iconView.frame) + kCommentPaddingFromLeft, CGRectGetMinY(self.iconView.frame) + kCommentPaddingFromTop}};
        [self addSubview:self.commentLabel];
        
        self.timeLabel = [[UILabel alloc] init];
        self.timeLabel.textColor = [UIColor grayColor];
        self.timeLabel.textAlignment = NSTextAlignmentLeft;
        self.timeLabel.font = [UIFont secretFontLightWithSize:12.f];
        self.timeLabel.numberOfLines = 1;
        [self addSubview:self.timeLabel];
        
        
        self.likeButton = [[UIButton alloc] init];
        // Hardcode the x value and size for simplicity
        self.likeButton.frame = (CGRect) {.origin = {290,CGRectGetMinY(self.commentLabel.frame) + 5}, .size = {18,18}};
        [self.likeButton setImage:[UIImage imageNamed:@"likeButton_unselected.png"] forState:UIControlStateNormal];
        [self.likeButton setImage:[UIImage imageNamed:@"likeButton_selected.png"] forState:UIControlStateSelected];
        [self.likeButton setImage:[UIImage imageNamed:@"likeButton_highlighted.png"] forState:UIControlStateHighlighted];
        [self.likeButton addTarget:self action:@selector(likeButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.likeButton];
        
        self.likeCountLabel = [[UILabel alloc] init];
        self.likeCountLabel.numberOfLines = 1;
        self.likeCountLabel.textColor = [UIColor grayColor];
        self.likeCountLabel.textAlignment = NSTextAlignmentLeft;
        self.likeCountLabel.font = [UIFont secretFontLightWithSize:12.f];
        self.likeCountLabel.hidden = YES;
        [self addSubview:self.likeCountLabel];
        
        self.likeCountImageView = [[UIImageView alloc] init];
        self.likeCountImageView.image = [UIImage imageNamed:@"like_greyIcon.png"];
        self.likeCountImageView.hidden = YES;
        [self addSubview:self.likeCountImageView];
        
        

    }
    return self;
}

- (void)likeButtonSelected:(id)sender {
    self.likeButton.selected = !self.likeButton.selected;
    if (self.likeButton.selected) {
        _likeCount++;
    } else {
        _likeCount--;
    }
    self.likeCountLabel.text = [NSString stringWithFormat:@"%d",_likeCount];
    [self.likeCountLabel sizeToFit];
    self.likeCountImageView.hidden = _likeCount <= 0;
    self.likeCountLabel.hidden = _likeCount <= 0;
}


@end
