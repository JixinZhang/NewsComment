//
//  NewsCommentMenuView.m
//  MNewsCommentFramework
//
//  Created by ZhangBob on 12/10/2016.
//  Copyright © 2016 Micker. All rights reserved.
//

#import "NewsCommentMenuView.h"
#import "UIImage+NewsCommentImageEffects.h"
#import "NewsCommentUtil.h"

#define KCommentMenuButtonWidth 72.0f
#define KCommentMenuButtonHeight 34.0f
#define KCommentMenuPanelWith (KScreenWidth - 30)
#define KCommentMenuButtonGaps ((KCommentMenuPanelWith - KCommentMenuButtonWidth * 3 - 30) / 2.0)

#define KCommentBorderColor [UIColor getColor:@"aaaaaa"]
#define KCommentTitleColor [UIColor getColor:@"262626"]
#define KCommentBtnBgColor [UIColor getColor:@"e1e1e1"]

@interface NewsCommentMenuView()

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIView *panelView;
@property (nonatomic, strong) UIButton *menuCancelButton;
@property (nonatomic, strong) UIImageView* screenshootImageView;
@property (nonatomic, strong) UITapGestureRecognizer* tapGesture;

@end

@implementation NewsCommentMenuView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupNewsCommentMenuView];
    }
    return self;
}

- (void)setupNewsCommentMenuView {
    self.frame = [UIScreen mainScreen].bounds;
    [self addSubview:self.bgImageView];
    [self addSubview:self.maskView];
    
    [self.panelView addSubview:self.replyButton];
    [self.panelView addSubview:self.contentCopyButton];
    [self.panelView addSubview:self.reportButton];
    [self.panelView addSubview:self.menuCancelButton];
    [self addSubview:self.panelView];
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithFrame:self.frame];
    }
    return _bgImageView;
}

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:self.frame];
        _maskView.backgroundColor = [UIColor getColor:@"333333" alpha:0.5];
        self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maskViewTapped:)];
        self.tapGesture.enabled = NO;
        [_maskView addGestureRecognizer:self.tapGesture];
    }
    return _maskView;
}

- (UIView *)panelView {
    if (!_panelView) {
        _panelView = [[UIView alloc] initWithFrame:CGRectMake(15, (KScreenHeight / 2.0 - 60), KCommentMenuPanelWith, 120)];
        _panelView.transform = CGAffineTransformMakeScale(0.7, 0.7);
        _panelView.backgroundColor = [UIColor whiteColor];
        _panelView.layer.cornerRadius = 5.0f;
        _panelView.layer.masksToBounds = YES;
    }
    return _panelView;
}

- (UIButton *)replyButton {
    if (!_replyButton) {
        _replyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _replyButton.frame = CGRectMake(15, 20, KCommentMenuButtonWidth, KCommentMenuButtonHeight);
        _replyButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [_replyButton setTitleColor:KCommentTitleColor forState:UIControlStateNormal];
        [_replyButton setTitle:@"回复评论" forState:UIControlStateNormal];
        UIImage *buttonBgImage = [UIImage newsCommentImageFromColor:KCommentBtnBgColor withSize:_replyButton.frame.size];
        [_replyButton setBackgroundImage:buttonBgImage forState:UIControlStateHighlighted];
        _replyButton.layer.borderWidth = 0.5f;
        _replyButton.layer.borderColor = KCommentBorderColor.CGColor;
        _replyButton.layer.cornerRadius = 3.0f;
        _replyButton.layer.masksToBounds = YES;
    }
    return _replyButton;
}

- (UIButton *)contentCopyButton {
    if (!_contentCopyButton) {
        _contentCopyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _contentCopyButton.frame = CGRectMake(CGRectGetMaxX(self.replyButton.frame) + KCommentMenuButtonGaps, 20, KCommentMenuButtonWidth, KCommentMenuButtonHeight);
        _contentCopyButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [_contentCopyButton setTitleColor:KCommentTitleColor forState:UIControlStateNormal];
        [_contentCopyButton setTitle:@"复制" forState:UIControlStateNormal];
        UIImage *buttonBgImage = [UIImage newsCommentImageFromColor:KCommentBtnBgColor withSize:_contentCopyButton.frame.size];
        [_contentCopyButton setBackgroundImage:buttonBgImage forState:UIControlStateHighlighted];
        _contentCopyButton.layer.borderWidth = 0.5f;
        _contentCopyButton.layer.borderColor = KCommentBorderColor.CGColor;
        _contentCopyButton.layer.cornerRadius = 3.0f;
        _contentCopyButton.layer.masksToBounds = YES;
    }
    return _contentCopyButton;
}

- (UIButton *)reportButton {
    if (!_reportButton) {
        _reportButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _reportButton.frame = CGRectMake(CGRectGetMaxX(self.contentCopyButton.frame) + KCommentMenuButtonGaps, 20, KCommentMenuButtonWidth, KCommentMenuButtonHeight);
        _reportButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [_reportButton setTitleColor:KCommentTitleColor forState:UIControlStateNormal];
        UIImage *buttonBgImage = [UIImage newsCommentImageFromColor:KCommentBtnBgColor withSize:_reportButton.frame.size];
        [_reportButton setBackgroundImage:buttonBgImage forState:UIControlStateHighlighted];
        [_reportButton setBackgroundImage:buttonBgImage forState:UIControlStateDisabled];
        [_reportButton setTitle:@"举报" forState:UIControlStateNormal];
        [_reportButton setTitle:@"已举报" forState:UIControlStateDisabled];
        _reportButton.layer.borderWidth = 0.5f;
        _reportButton.layer.borderColor = KCommentBorderColor.CGColor;
        _reportButton.layer.cornerRadius = 3.0f;
        _reportButton.layer.masksToBounds = YES;
    }
    return _reportButton;
}

- (UIButton *)menuCancelButton {
    if (!_menuCancelButton) {
        _menuCancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _menuCancelButton.frame = CGRectMake(0, 64, KCommentMenuPanelWith, 56);
        _menuCancelButton.titleLabel.font = [UIFont systemFontOfSize:18.0f];
        [_menuCancelButton setTitleColor:KCommentTitleColor forState:UIControlStateNormal];
        UIImage *buttonBgImage = [UIImage newsCommentImageFromColor:KCommentBtnBgColor withSize:_menuCancelButton.frame.size];
        [_menuCancelButton setBackgroundImage:buttonBgImage forState:UIControlStateHighlighted];
        [_menuCancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_menuCancelButton addTarget:self action:@selector(menuCancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _menuCancelButton;
}

#pragma mark - show/hide panel view

- (void)showPanelView {
    if (!self.subviews) {
        return;
    }
    //设置举报button是否可用，已经举报不可点击
    [self.reportButton setEnabled:!self.commentModel.isReported];
    
    UIImage* windowShootImage = [self windowShootImage];;
    self.bgImageView.image = windowShootImage;
    UIWindow* keyWindow = [UIApplication sharedApplication].keyWindow;
    self.tapGesture.enabled = YES;
    [keyWindow addSubview:self];
    
    __weak typeof (self)weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.panelView.transform = CGAffineTransformMakeScale(1.05, 1.05);
        weakSelf.panelView.alpha = 1.0f;
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            weakSelf.panelView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }];
    }];
}

- (void)hidePanelView {
    [self removeNewsCommentMenuView];
}

- (void)removeNewsCommentMenuView {
    __weak typeof (self)weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.panelView.transform = CGAffineTransformMakeScale(0.7, 0.7);
        weakSelf.panelView.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}

#pragma mark action methods

- (void)maskViewTapped:(id)sender {
    [self removeNewsCommentMenuView];
}

- (void)menuCancelButtonClicked:(id)sender {
    [self removeNewsCommentMenuView];
}

- (UIImage *) windowShootImage{
    UIView *baseView = [UIApplication sharedApplication].keyWindow;
    UIGraphicsBeginImageContextWithOptions(baseView.bounds.size, baseView.opaque, 0.0);
    [baseView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [img newsCommentBlurImageWithVIImageOfBlur:0.2f];
}

@end
