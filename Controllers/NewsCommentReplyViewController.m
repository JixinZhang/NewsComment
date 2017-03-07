//
//  NewsCommentReplyViewController.m
//  MNewsCommentFramework
//
//  Created by WSCN on 07/11/2016.
//  Copyright © 2016 Micker. All rights reserved.
//

#import "NewsCommentReplyViewController.h"
#import "ANPlaceholderTextView.h"
#import "NewsCommentUtil.h"
#import "NewsCommentPostRequest.h"
#import "NewsCommentPostResponse.h"

#define KTextColor @"222222"
#define KTextPlaceholderColor @"aaaaaa"

@interface NewsCommentReplyViewController ()

@property (nonatomic, strong) ANPlaceholderTextView *contentTextView;
@property (nonatomic, strong) UIView *navigationView;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *sendButton;
//改@property (nonatomic, strong) BindingMobilePhoneWindow *bingingPhoneView;

@end

@implementation NewsCommentReplyViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        [self __setup];
    }
    return self;
}

- (ANPlaceholderTextView *)contentTextView {
    if (!_contentTextView) {
        _contentTextView = [[ANPlaceholderTextView alloc] initWithFrame:CGRectMake(10, 70, KScreenWidth - 20, KScreenHeight - 70)];
        _contentTextView.backgroundColor = [UIColor clearColor];
        _contentTextView.placeholder = @"我也说两句";
        _contentTextView.placeholderColor = [UIColor getColor:KTextPlaceholderColor];
        _contentTextView.textView.delegate = self;
        _contentTextView.textView.backgroundColor = [UIColor clearColor];
        _contentTextView.textView.font = [UIFont systemFontOfSize:15.f];
        _contentTextView.placeholderLabel.frame = CGRectMake(12, 19, _contentTextView.placeholderLabel.bounds.size.width, _contentTextView.placeholderLabel.bounds.size.height);
        _contentTextView.textView.frame = CGRectMake(5, 12, _contentTextView.textView.bounds.size.width, _contentTextView.textView.bounds.size.height);
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isTextViewEmpty:) name:UITextViewTextDidChangeNotification object:_contentTextView.textView];
    }
    return _contentTextView;
}

- (UIView *)navigationView {
    if (!_navigationView) {
        _navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 70)];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 69.5, KScreenWidth, 0.5)];
        lineView.backgroundColor = [UIColor getColor:@"cdcdcd"];
        [_navigationView addSubview:lineView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((KScreenWidth - 60) / 2.0, 36, 60, 17)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = @"写评论";
        titleLabel.textColor = [UIColor getColor:@"333333"];
        titleLabel.font = [UIFont systemFontOfSize:17.0f];
        [_navigationView addSubview:titleLabel];
    }
    return _navigationView;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.frame = CGRectMake(0, 20, 44, 44);
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor getColor:@"808080"] forState:UIControlStateNormal];
        [_cancelButton addTarget:self
                          action:@selector(replyCancelButtonClicked:)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)sendButton {
    if (!_sendButton) {
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendButton.frame = CGRectMake(KScreenWidth - 44, 20, 44, 44);
        _sendButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [_sendButton setTitle:@"发布" forState:UIControlStateNormal];
        [_sendButton setTitleColor:[UIColor getColor:@"808080"] forState:UIControlStateDisabled];
        [_sendButton setTitleColor:[UIColor getColor:@"1482f0"] forState:UIControlStateNormal];
        [_sendButton addTarget:self
                          action:@selector(replysendButtonClicked:)
                forControlEvents:UIControlEventTouchUpInside];
        _sendButton.enabled = NO;
    }
    return _sendButton;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (BOOL)fd_prefersNavigationBarHidden {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)__setup {
    [self.navigationView addSubview:self.cancelButton];
    [self.navigationView addSubview:self.sendButton];
    [self.view addSubview:self.navigationView];
    [self.view addSubview:self.contentTextView];
}

- (IBAction)replyCancelButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)replysendButtonClicked:(id)sender {
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
    postRequset.parentId = self.commentModel.commentId ? self.commentModel.commentId : @"0";
    postRequset.uniqueKey = [NSString stringWithFormat:@"psarticles_%@",self.newsId];
    postRequset.successCompletionBlock = ^(GoldBaseRequest *responseData) {
        NewsCommentPostResponse *postRespone = [[NewsCommentPostResponse alloc] initWithContent:responseData.responseObject];
        if (weakSelf.commentReplyVCBlock) {
            weakSelf.commentReplyVCBlock(YES,postRespone.commentModel);
        }
        weakSelf.contentTextView.textView.text = @"";
        [weakSelf.contentTextView.textView resignFirstResponder];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    postRequset.failureCompletionBlock = ^(GoldBaseRequest *responseData) {
        [weakSelf.contentTextView.textView resignFirstResponder];
        [MBProgressHUD showOnlyText:@"评论失败" toView:weakSelf.view];
    };
    [postRequset start];
}

- (void)isTextViewEmpty:(NSNotification *)notification {
    UITextView *textView = notification.object;
    NSString* commentContent = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (commentContent.length <= 0) {
        self.sendButton.enabled = NO;
    } else {
        self.sendButton.enabled = YES;
    }
}

- (void)setReplyVCPlaceholderWithString:(NSString *)placeholder {
    self.contentTextView.placeholder = placeholder;
}

@end
