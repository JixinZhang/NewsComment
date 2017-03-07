//
//  NewsCommentTextView.m
//  MNewsCommentFramework
//
//  Created by ZhangBob on 13/10/2016.
//  Copyright © 2016 Micker. All rights reserved.
//

#import "NewsCommentTextView.h"
#import "NewsCommentPostRequest.h"
#import "NewsCommentPostResponse.h"
#import "NewsCommentUtil.h"
#import "UIImage+NewsCommentImageEffects.h"

#define KTextViewNormalHeight 32.0f
#define KTextViewInputHeight 66.0f

#define KPanelViewNormalHeight 52.0f
#define KPanelViewInputHeight 127.0f

#define KSendButtonWidth 60.0f
#define KSendButtonHeight 35.0f

#define KPanelViewColor @"e6e6e6"
#define KTextColor @"222222"
#define KTextPlaceholderColor @"aaaaaa"

@interface NewsCommentTextView()<UITextViewDelegate>

@property (nonatomic, strong) UIView *newsCommentView;
//改 @property (nonatomic, strong) BindingMobilePhoneWindow *bingingPhoneView;
@property (nonatomic, strong) UIView *textViewTopView;  //用于点击空白处关闭键盘
@property (nonatomic, strong) UIButton *cancelButton;

@end

@implementation NewsCommentTextView

- (void) dealloc{
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupNewsCommentTextView];
        [self enableObserveKeyboard];
    }
    return self;
}

- (void)setupNewsCommentTextView {
    [self.panelView addSubview:self.cancelButton];
    [self.panelView addSubview:self.sendButton];
    [self.panelView addSubview:self.contentTextView];
    [self addSubview:self.textViewTopView];
    [self addSubview:self.panelView];
}

#pragma mark - getter

- (UIView *)textViewTopView {
    if (!_textViewTopView) {
        _textViewTopView = [[UIView alloc] init];
        _textViewTopView.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyBoard:)];
        [_textViewTopView addGestureRecognizer:tap];
    }
    return _textViewTopView;
}

- (UIView *)panelView {
    if (!_panelView) {
        _panelView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KPanelViewNormalHeight)];
        _panelView.backgroundColor = [UIColor getColor:KPanelViewColor];
        
        UILabel *panelViewTitle = [[UILabel alloc] initWithFrame:CGRectMake((_panelView.center.x - KSendButtonWidth / 2.0), 8, KSendButtonWidth, KSendButtonHeight)];
        panelViewTitle.font = [UIFont systemFontOfSize:16];
        panelViewTitle.textAlignment = NSTextAlignmentCenter;
        panelViewTitle.text = @"写评论";
        [_panelView addSubview:panelViewTitle];
    }
    return _panelView;
}

- (ANPlaceholderTextView *)contentTextView {
    if (!_contentTextView) {
        _contentTextView = [[ANPlaceholderTextView alloc] initWithFrame:CGRectMake(10, 10, KScreenWidth - 20, KTextViewNormalHeight)];
        _contentTextView.layer.cornerRadius = 16;
        _contentTextView.layer.masksToBounds = YES;
        _contentTextView.layer.borderWidth = 0.5;
        _contentTextView.layer.borderColor = [UIColor getColor:@"c3c3c3"].CGColor;
        _contentTextView.backgroundColor = [UIColor whiteColor];
        _contentTextView.placeholder = @"我也说两句";
        _contentTextView.placeholderColor = [UIColor getColor:KTextPlaceholderColor];
        _contentTextView.textView.delegate = self;
        _contentTextView.textView.backgroundColor = [UIColor clearColor];
        _contentTextView.textView.font = [UIFont systemFontOfSize:15.f];
        _contentTextView.placeholderLabel.frame = CGRectMake(12, 7, _contentTextView.placeholderLabel.bounds.size.width, _contentTextView.placeholderLabel.bounds.size.height);
        _contentTextView.textView.frame = CGRectMake(12, _contentTextView.placeholderLabel.frame.origin.y, _contentTextView.textView.bounds.size.width, _contentTextView.textView.bounds.size.height);
    }
    return _contentTextView;
}

- (UIButton *)sendButton {
    if (!_sendButton) {
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendButton.frame = CGRectZero;
        _sendButton.center = CGPointMake(KScreenWidth - KSendButtonWidth - 8, 8);
        _sendButton.hidden = YES;
        _sendButton.enabled = NO;
        _sendButton.backgroundColor = [UIColor clearColor];
        _sendButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [_sendButton setTitleColor:[UIColor getColor:@"3282f0"] forState:UIControlStateNormal];
        [_sendButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        UIImage *buttonBgImage = [UIImage newsCommentImageFromColor:[UIColor getColor:@"e1e1e1"] withSize:_sendButton.frame.size];
        [_sendButton setBackgroundImage:buttonBgImage forState:UIControlStateDisabled];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [_sendButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 25, 0, 0)];
        [_sendButton addTarget:self action:@selector(sendButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return  _sendButton;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.frame = CGRectZero;
        _cancelButton.hidden = YES;
        _cancelButton.backgroundColor = [UIColor clearColor];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [_cancelButton setTitleColor:[UIColor getColor:@"3282f0"] forState:UIControlStateNormal];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 25)];
        [_cancelButton addTarget:self action:@selector(dismissKeyBoard:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIView *)maskView {
    if (!_maskView) {
        UIWindow* window = [UIApplication sharedApplication].keyWindow;
        _maskView = [[UIView alloc] initWithFrame:self.frame];
        _maskView.userInteractionEnabled = NO;
        _maskView.hidden = YES;
        _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    }
    return _maskView;
}

#pragma mark - keyboard observe

- (void)enableObserveKeyboard {
    [self disabelObserveKeyboard];
    NSNotificationCenter *notify = [NSNotificationCenter defaultCenter];
    [notify addObserver:self
               selector:@selector(keyboardWillShow:)
                   name:UIKeyboardWillShowNotification
                 object:nil];
    [notify addObserver:self
               selector:@selector(keyboardWillHide:)
                   name:UIKeyboardWillHideNotification
                 object:nil];
}

- (void)disabelObserveKeyboard {
    NSNotificationCenter* notify = [NSNotificationCenter defaultCenter];
    [notify removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [notify removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - keyboard show/hide

- (void)dismissKeyBoard:(id)sender {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    //如果绑定手机号码的view显示了则不执行对输入框做frame的调整
//改    if (self.bingingPhoneView) {
//        return;
//    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isTextViewEmpty:) name:UITextViewTextDidChangeNotification object:_contentTextView.textView];
    self.contentTextView.textView.text.length ? (self.sendButton.enabled = YES) : (self.sendButton.enabled = NO);
    self.sendButton.hidden = NO;
    self.cancelButton.hidden = NO;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.frame = window.bounds;
    self.maskView.hidden = NO;
    self.maskView.userInteractionEnabled = YES;
    
    self.newsCommentView = [self superview];
    [self.newsCommentView insertSubview:self.maskView belowSubview:self];
    
    //获取键盘的高度
    NSDictionary * userInfo=[notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat keyboardHeight = [aValue CGRectValue].size.height;
    //获取键盘弹出的时间
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    CGSize windowSize = window.frame.size;
    
    //获取回复面板的frame
    CGRect panelFrame = CGRectMake(self.panelView.frame.origin.x, self.panelView.frame.origin.y, self.panelView.frame.size.width, KPanelViewInputHeight);
    panelFrame.origin.y = windowSize.height - keyboardHeight - panelFrame.size.height - 64 ;

    //修改sendButton的frame
    //sendButton的坐标相对于panelView
    CGRect sendFrame = self.sendButton.frame;
    sendFrame.origin.x = windowSize.width -8 - KSendButtonWidth;
    sendFrame.origin.y = 8.f;
    sendFrame.size = CGSizeMake(KSendButtonWidth, KSendButtonHeight);
    
    //修改cancelButton的frame
    CGRect cancelFrame = self.cancelButton.frame;
    cancelFrame.origin.x = 8.0f;
    cancelFrame.origin.y = 8.f;
    cancelFrame.size = CGSizeMake(KSendButtonWidth, KSendButtonHeight);

    //修改contentTextView的frame
    //contentTextView的坐标是相对于panelView的
    CGRect textViewFrame = self.contentTextView.frame;
    textViewFrame.size.width = windowSize.width - 20;
    textViewFrame.origin.x = 10;
    textViewFrame.origin.y = CGRectGetMaxY(cancelFrame) + 10;
    textViewFrame.size.height = KTextViewInputHeight;
    
    self.contentTextView.layer.cornerRadius = 4;
    self.contentTextView.placeholderLabel.frame = CGRectMake(4, 7, self.contentTextView.placeholderLabel.bounds.size.width, self.contentTextView.placeholderLabel.bounds.size.height);
    __weak typeof (self) weakSelf = self;
    self.contentTextView.textView.frame = CGRectMake(0, 0, self.contentTextView.textView.bounds.size.width, self.contentTextView.textView.bounds.size.height);
    
    [UIView animateWithDuration:animationDuration animations:^{
        weakSelf.maskView.alpha = 1;
        weakSelf.panelView.frame = panelFrame;
        weakSelf.contentTextView.frame = textViewFrame;
        weakSelf.sendButton.frame = sendFrame;
        weakSelf.cancelButton.frame = cancelFrame;
    } completion:^(BOOL finished) {
        weakSelf.textViewTopView.frame = CGRectMake(0, 0, KScreenWidth, panelFrame.origin.y);
    }];
}

-(void)keyboardWillHide:(NSNotification *)notification {
//改    self.bingingPhoneView = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
    NSDictionary *userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    self.contentTextView.textView.frame = CGRectMake(12, 0, self.contentTextView.textView.bounds.size.width, self.contentTextView.textView.bounds.size.height);
    __weak typeof (self) weakSelf = self;
    [UIView animateWithDuration:animationDuration animations:^{
        weakSelf.maskView.alpha = 0.f;
        weakSelf.panelView.frame = CGRectMake(0, 0, KScreenWidth, KPanelViewNormalHeight);
        weakSelf.contentTextView.frame= CGRectMake(10, 10, KScreenWidth - 20, KTextViewNormalHeight);
        weakSelf.frame = CGRectMake(0, KScreenHeight - KPanelViewNormalHeight - 64, KScreenWidth, KPanelViewNormalHeight);
    } completion:^(BOOL finished) {
        weakSelf.sendButton.hidden = YES;
        weakSelf.cancelButton.hidden = YES;
        weakSelf.contentTextView.placeholder = @"我也说两句";
        [weakSelf.maskView removeFromSuperview];
        weakSelf.textViewTopView.frame = CGRectZero;
    }];
    self.contentTextView.layer.cornerRadius = 16;
}

#pragma mark - send button 

- (void)sendButtonClicked:(id)sender {
    __weak typeof (self)weakSelf = self;
    if (![NewsCommentUtil isWSCNUserLogined]) {
        [self.contentTextView.textView resignFirstResponder];
        [NewsCommentUtil loginWSCNAccount];
        return;
    }
//改    UserInfoResponse *userInfoResonse = [NewsCommentUtil getCurrentWSCNUserInfo];
//    UserResponse *user = userInfoResonse.user;
//    if (user.mobile.length == 0) {
//        [self.contentTextView.textView resignFirstResponder];
//        self.bingingPhoneView = [[BindingMobilePhoneWindow alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
//        return;
//    }
    
    NSString* commentContent = [self.contentTextView.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NewsCommentPostRequest *postRequset = [[NewsCommentPostRequest alloc] init];
    postRequset.threadId = self.threadId ? self.threadId : @"";
    postRequset.content = commentContent ? commentContent: @"";
    postRequset.parentId = self.parentId ? self.parentId : @"0";
    postRequset.successCompletionBlock = ^(GoldBaseRequest *responseData) {
        NewsCommentPostResponse *postRespone = [[NewsCommentPostResponse alloc] initWithContent:responseData.responseObject];
        if (weakSelf.commentTextViewBlock) {
            weakSelf.commentTextViewBlock(YES,postRespone.commentModel);
        }
        weakSelf.contentTextView.textView.text = @"";
        [weakSelf.contentTextView.textView resignFirstResponder];
    };
    postRequset.failureCompletionBlock = ^(GoldBaseRequest *responseData) {
        [weakSelf.contentTextView.textView resignFirstResponder];
        [MBProgressHUD showOnlyText:@"评论失败" toView:[UIApplication sharedApplication].keyWindow];
    };
    [postRequset start];
}

#pragma mark - text view editing

- (void)newsCommentTextBeginEditing {
    if (self.placeholder) {
        self.contentTextView.placeholder = self.placeholder;
    }
    [self.contentTextView.textView becomeFirstResponder];
}

- (void)newsCommentTextEndEditing {
    self.contentTextView.textView.text = @"";
    [self endEditing:YES];
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

#pragma mark - is textView empty

- (void)isTextViewEmpty:(NSNotification *)notification {
    UITextView *textView = notification.object;
    NSString* commentContent = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (commentContent.length <= 0) {
        self.sendButton.enabled = NO;
    } else {
        self.sendButton.enabled = YES;
    }
}

@end
