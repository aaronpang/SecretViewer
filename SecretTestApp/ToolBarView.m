//
//  ToolBarView.m
//  SecretTestApp
//
//  Created by Aaron Pang on 3/28/14.
//  Copyright (c) 2014 Aaron Pang. All rights reserved.
//

#import "ToolBarView.h"
#import "UIFont+SecretFont.h"

@implementation ToolBarView {
    UILabel *_cityLabel;
    UIButton *_moreButton;
    UIButton *_commentButton;
    UILabel *_commentCountLabel;
    UIButton *_likeButton;
    UILabel *_likeCountLabel;
    
    NSInteger _likeCounter;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // Obviously my secret would have at least 10 likes
        _likeCounter = 10;
        
        _cityLabel = [[UILabel alloc] init];
        _cityLabel.text = @"San Francisco";
        _cityLabel.font = [UIFont secretFontLightWithSize:14.f];
        _cityLabel.textColor = [UIColor whiteColor];
        _cityLabel.textAlignment = NSTextAlignmentLeft;
        _cityLabel.frame = (CGRect) {.origin = {15,0}};
        _cityLabel.backgroundColor = [UIColor clearColor];
        [_cityLabel sizeToFit];
        [self addSubview:_cityLabel];
        
        // Hardcoded the frames for all of these for simplicity and quickness
        _moreButton = [[UIButton alloc] initWithFrame:(CGRect){.origin = {CGRectGetMaxX(_cityLabel.frame) + 98, CGRectGetMinY(_cityLabel.frame) + 3}, .size = {22, 13}}];
        [_moreButton setImage:[UIImage imageNamed:@"moreButton.png"] forState:UIControlStateNormal];
        [self addSubview:_moreButton];
        
        _commentButton = [[UIButton alloc] initWithFrame:(CGRect){.origin = {CGRectGetMaxX(_moreButton.frame) + 20, CGRectGetMinY(_cityLabel.frame) + 2}, .size = {22,17}}];
        [_commentButton setImage:[UIImage imageNamed:@"commentButton.png"] forState:UIControlStateNormal];
        [self addSubview:_commentButton];
        
        _commentCountLabel = [[UILabel alloc] init];
        _commentCountLabel.font = [UIFont secretFontLightWithSize:13.f];
        _commentCountLabel.textColor = [UIColor whiteColor];
        _commentCountLabel.textAlignment = NSTextAlignmentLeft;
        _commentCountLabel.frame = (CGRect) {.origin = {CGRectGetMaxX(_commentButton.frame) + 6, CGRectGetMinY(_cityLabel.frame) + 1}};
        _commentCountLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_commentCountLabel];
        
        _likeButton = [[UIButton alloc] initWithFrame:(CGRect){.origin = {CGRectGetMaxX(_commentCountLabel.frame) + 25, CGRectGetMinY(_cityLabel.frame) + 3}, .size = {15,15}}];
        [_likeButton setImage:[UIImage imageNamed:@"likeButtonToolbar_unselected"] forState:UIControlStateNormal];
        [_likeButton setImage:[UIImage imageNamed:@"likeButtonToolbar_selected"] forState:UIControlStateSelected];

        [_likeButton addTarget:self action:@selector(likeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_likeButton];
        
        _likeCountLabel = [[UILabel alloc] init];
        _likeCountLabel.font = [UIFont secretFontLightWithSize:13.f];
        _likeCountLabel.textColor = [UIColor whiteColor];
        _likeCountLabel.textAlignment = NSTextAlignmentLeft;
        _likeCountLabel.frame = (CGRect) {.origin = {CGRectGetMaxX(_likeButton.frame) + 6, CGRectGetMinY(_cityLabel.frame) + 1}};
        _likeCountLabel.text = [NSString stringWithFormat:@"%d", _likeCounter];
        _likeCountLabel.backgroundColor = [UIColor clearColor];
        [_likeCountLabel sizeToFit];
        [self addSubview:_likeCountLabel];
        
    }
    return self;
}

- (void)setNumberOfComments:(NSInteger)comments {
    _commentCountLabel.text = [NSString stringWithFormat:@"%d",comments];
    [_commentCountLabel sizeToFit];
}

- (void)likeButtonTapped:(id)sender{
    _likeButton.selected = !_likeButton.selected;
    if (_likeButton.selected) {
        _likeCounter++;
        // Don't let the user interrupt the animation
        _likeButton.userInteractionEnabled = NO;
        const NSInteger pixelsToScale = 9.0f;
        const NSInteger pixelsToShrink = 4.0f;
        CGRect likeButtonRect = _likeButton.frame;
        
        // Play that like/heart beat animation!
        [UIView animateWithDuration:0.4f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _likeButton.frame = (CGRect){.origin = {CGRectGetMinX(likeButtonRect) - pixelsToScale / 2.0f, CGRectGetMinY(likeButtonRect) - pixelsToScale / 2.0f}, .size = {CGRectGetWidth(likeButtonRect) + pixelsToScale, CGRectGetHeight(likeButtonRect) + pixelsToScale}};
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2f delay:0.1f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                _likeButton.frame = (CGRect) {.origin = {CGRectGetMinX(likeButtonRect) + pixelsToShrink / 2.0f, CGRectGetMinY(likeButtonRect) + pixelsToShrink / 2.0f}, .size = {CGRectGetWidth(likeButtonRect) - pixelsToShrink, CGRectGetHeight(likeButtonRect) - pixelsToShrink}};
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    _likeButton.frame = likeButtonRect;
                } completion:^(BOOL finished) {
                    _likeButton.userInteractionEnabled = YES;
                }];
            }];
        }];
    } else {
        _likeCounter--;
    }
    [_likeCountLabel setText:[NSString stringWithFormat:@"%d",_likeCounter]];
}

@end
