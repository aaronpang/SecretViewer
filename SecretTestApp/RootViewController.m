//
//  RootViewController.m
//  SecretTestApp
//
//  Created by Aaron Pang on 3/28/14.
//  Copyright (c) 2014 Aaron Pang. All rights reserved.
//

#import "RootViewController.h"
#import "UIImage+ImageEffects.h"
#import "ToolBarView.h"
#import "UIFont+SecretFont.h"
#import "CommentCell.h"
#import "UIView+GradientMask.h"

#import <QuartzCore/QuartzCore.h>

#define HEADER_HEIGHT 320.0f
#define HEADER_INIT_FRAME CGRectMake(0, 0, self.view.frame.size.width, HEADER_HEIGHT)
#define TOOLBAR_INIT_FRAME CGRectMake (0, 292, 320, 22)

const CGFloat kBarHeight = 50.0f;
const CGFloat kBackgroundParallexFactor = 0.5f;
const CGFloat kBlurFadeInFactor = 0.005f;
const CGFloat kTextFadeOutFactor = 0.05f;
const CGFloat kCommentCellHeight = 50.0f;

@interface RootViewController () <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>

@end

@implementation RootViewController {
    UIScrollView *_mainScrollView;
    UIScrollView *_backgroundScrollView;
    UIImageView *_blurImageView;
    UILabel *_textLabel;
    ToolBarView *_toolBarView;
    UIView *_commentsViewContainer;
    UITableView *_commentsTableView;
    
    // TODO: Implement these
    UIGestureRecognizer *_leftSwipeGestureRecognizer;
    UIGestureRecognizer *_rightSwipeGestureRecognizer;
    
    NSMutableArray *comments;
}

- (id)init {
    self = [super init];
    if (self) {
        _mainScrollView = [[UIScrollView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.frame];
        _mainScrollView.delegate = self;
        _mainScrollView.bounces = YES;
        _mainScrollView.alwaysBounceVertical = YES;
        _mainScrollView.contentSize = CGSizeZero;
        _mainScrollView.showsVerticalScrollIndicator = YES;
        _mainScrollView.scrollIndicatorInsets = UIEdgeInsetsMake(kBarHeight, 0, 0, 0);
        self.view = _mainScrollView;
        
        _backgroundScrollView = [[UIScrollView alloc] initWithFrame:HEADER_INIT_FRAME];
        _backgroundScrollView.scrollEnabled = NO;
        _backgroundScrollView.contentSize = CGSizeMake(320, 1000);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:HEADER_INIT_FRAME];
        imageView.image = [UIImage imageNamed:@"secret.png"];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        UIView *fadeView = [[UIView alloc] initWithFrame:imageView.frame];
        fadeView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3f];
        fadeView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        _textLabel = [[UILabel alloc] initWithFrame:HEADER_INIT_FRAME];
        [_textLabel setText:@"I love sharing secrets"];
        [_textLabel setFont:[UIFont secretFontWithSize:22.f]];
        [_textLabel setTextAlignment:NSTextAlignmentCenter];
        [_textLabel setTextColor:[UIColor whiteColor]];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.layer.shadowColor = [UIColor blackColor].CGColor;
        _textLabel.layer.shadowRadius = 10.0f;
        _textLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        _toolBarView = [[ToolBarView alloc] initWithFrame:TOOLBAR_INIT_FRAME];
        _toolBarView.autoresizingMask =   UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin;
        [_backgroundScrollView addSubview:imageView];
        [_backgroundScrollView addSubview:fadeView];
        [_backgroundScrollView addSubview:_toolBarView];
        [_backgroundScrollView addSubview:_textLabel];
        
        // Take a snapshot of the background scroll view and apply a blur to that image
        // Then add the blurred image on top of the regular image and slowly fade it in
        // in scrollViewDidScroll
        UIGraphicsBeginImageContextWithOptions(_backgroundScrollView.bounds.size, _backgroundScrollView.opaque, 0.0);
        [_backgroundScrollView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        _blurImageView = [[UIImageView alloc] initWithFrame:HEADER_INIT_FRAME];
        _blurImageView.image = [img applyBlurWithRadius:12 tintColor:[UIColor colorWithWhite:0.8 alpha:0.4] saturationDeltaFactor:1.8 maskImage:nil];
        _blurImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _blurImageView.alpha = 0;
        _blurImageView.backgroundColor = [UIColor clearColor];
        [_backgroundScrollView addSubview:_blurImageView];
 
        _commentsViewContainer = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_backgroundScrollView.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - kBarHeight )];
        [_commentsViewContainer addGradientMaskWithStartPoint:CGPointMake(0.5, 0.0) endPoint:CGPointMake(0.5, 0.03)];
        _commentsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - kBarHeight ) style:UITableViewStylePlain];
        _commentsTableView.scrollEnabled = NO;
        _commentsTableView.delegate = self;
        _commentsTableView.dataSource = self;
        _commentsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _commentsTableView.separatorColor = [UIColor clearColor];
        
        [self.view addSubview:_backgroundScrollView];
        [_commentsViewContainer addSubview:_commentsTableView];
        [self.view addSubview:_commentsViewContainer];
        
        // Let's put in some fake data!
        comments = [@[@"Oh my god! Me too!", @"No way! I love secrets too!", @"I for some reason really like sharing my deepest darkest secrest to the entire world", @"More comments", @"Go Toronto Blue Jays!", @"I rather use Twitter", @"I don't get Secret", @"I don't have an iPhone", @"How are you using this then?"] mutableCopy];
        [_toolBarView setNumberOfComments:[comments count]];
    }
    return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat delta = 0.0f;
    CGRect rect = HEADER_INIT_FRAME;
    CGRect toolbarRect = TOOLBAR_INIT_FRAME;
    // Here is where I do the "Zooming" image and the quick fade out the text and toolbar
    if (scrollView.contentOffset.y < 0.0f) {
        delta = fabs(MIN(0.0f, _mainScrollView.contentOffset.y));
        _backgroundScrollView.frame = CGRectMake(CGRectGetMinX(rect) - delta / 2.0f, CGRectGetMinY(rect) - delta, CGRectGetWidth(rect) + delta, CGRectGetHeight(rect) + delta);
        _textLabel.alpha = MIN(1.0f, 1.0f - delta * kTextFadeOutFactor);
        _toolBarView.alpha = _textLabel.alpha;
        _toolBarView.frame = CGRectMake(CGRectGetMinX(toolbarRect) + delta / 2.0f, CGRectGetMinY(toolbarRect) + delta, CGRectGetWidth(toolbarRect), CGRectGetHeight(toolbarRect));
        [_commentsTableView setContentOffset:(CGPoint){0,0} animated:NO];
    } else {
        delta = _mainScrollView.contentOffset.y;
        _textLabel.alpha = 1.0f;
        _toolBarView.alpha = _textLabel.alpha;
        _blurImageView.alpha = MIN(1 , delta * kBlurFadeInFactor);
        _toolBarView.frame = TOOLBAR_INIT_FRAME;
        CGFloat backgroundScrollViewLimit = _backgroundScrollView.frame.size.height - kBarHeight;
        // Here I check whether or not the user has scrolled passed the limit where I want to stick the header, if they have then I move the frame with the scroll view
        // to give it the sticky header look
        if (delta > backgroundScrollViewLimit) {
            _backgroundScrollView.frame = (CGRect) {.origin = {0, delta - _backgroundScrollView.frame.size.height + kBarHeight}, .size = {self.view.frame.size.width, HEADER_HEIGHT}};
            _commentsViewContainer.frame = (CGRect){.origin = {0, CGRectGetMinY(_backgroundScrollView.frame) + CGRectGetHeight(_backgroundScrollView.frame)}, .size = _commentsViewContainer.frame.size };
            _commentsTableView.contentOffset = CGPointMake (0, delta - backgroundScrollViewLimit);
            CGFloat contentOffsetY = -backgroundScrollViewLimit * kBackgroundParallexFactor;
            [_backgroundScrollView setContentOffset:(CGPoint){0,contentOffsetY} animated:NO];
        }
        else {
            _backgroundScrollView.frame = rect;
            _commentsViewContainer.frame = (CGRect){.origin = {0, CGRectGetMinY(rect) + CGRectGetHeight(rect)}, .size = _commentsViewContainer.frame.size };
            [_commentsTableView setContentOffset:(CGPoint){0,0} animated:NO];
            [_backgroundScrollView setContentOffset:CGPointMake(0, -delta * kBackgroundParallexFactor)animated:NO];
        }
    }
}

#pragma mark

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [comments count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *text = [comments objectAtIndex:[indexPath row]];
    CGSize requiredSize;
    if ([text respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        CGRect rect = [text boundingRectWithSize:(CGSize){225, MAXFLOAT}
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:@{NSFontAttributeName:[UIFont secretFontLightWithSize:16.f]}
                                                   context:nil];
        requiredSize = rect.size;
    } else {
        requiredSize = [text sizeWithFont:[UIFont secretFontLightWithSize:16.f] constrainedToSize:(CGSize){225, MAXFLOAT} lineBreakMode:NSLineBreakByWordWrapping];
    }
    return kCommentCellHeight + requiredSize.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"Cell %d", indexPath.row]];
    if (!cell) {
        cell = [[CommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"Cell %d", indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.commentLabel.frame = (CGRect) {.origin = cell.commentLabel.frame.origin, .size = {CGRectGetMinX(cell.likeButton.frame) - CGRectGetMaxY(cell.iconView.frame) - kCommentPaddingFromLeft - kCommentPaddingFromRight,[self tableView:tableView heightForRowAtIndexPath:indexPath] - kCommentCellHeight}};
        cell.commentLabel.text = comments[indexPath.row];
        cell.timeLabel.frame = (CGRect) {.origin = {CGRectGetMinX(cell.commentLabel.frame), CGRectGetMaxY(cell.commentLabel.frame)}};
        cell.timeLabel.text = @"1d ago";
        [cell.timeLabel sizeToFit];
        
        // Don't judge my magic numbers or my crappy assets!!!
        cell.likeCountImageView.frame = CGRectMake(CGRectGetMaxX(cell.timeLabel.frame) + 7, CGRectGetMinY(cell.timeLabel.frame) + 3, 10, 10);
        cell.likeCountImageView.image = [UIImage imageNamed:@"like_greyIcon.png"];
        cell.likeCountLabel.frame = CGRectMake(CGRectGetMaxX(cell.likeCountImageView.frame) + 3, CGRectGetMinY(cell.timeLabel.frame), 0, CGRectGetHeight(cell.timeLabel.frame));
    }

    return cell;
}


- (void)viewDidAppear:(BOOL)animated {
    _mainScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), _commentsTableView.contentSize.height + CGRectGetHeight(_backgroundScrollView.frame));
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
