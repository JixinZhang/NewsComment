//
//  NewsCommentViewController.m
//  MNewsCommentFramework
//
//  Created by ZhangBob on 10/10/2016.
//  Copyright © 2016 Micker. All rights reserved.
//

#import "NewsCommentViewController.h"
#import "NewsCommentHeaderView.h"
#import "NewsCommentTableViewCell.h"
#import "NewsCommentMenuView.h"
#import "NewsCommentTextView.h"

#import "NewsCommentHotListRequest.h"
#import "NewsCommentListRequest.h"
#import "NewsCommentReportRequest.h"
#import "NewsCommentListResponse.h"
#import "NewsCommentPostResponse.h"
#import "NewsCommentReportResponse.h"
#import "NewsCommentUtil.h"
#import "NewsCommentReplyViewController.h"
#import <GoldNetworkFramework/UIImage+GIF.h>

#define kSectionHeaderHeight 32.f
#define KTableViewCellReuseId @"NewsCommentTableViewCell"
#define kTableViewSectionHeaderReuseId @"NewsCommentTableViewSectionHeader"

@interface NewsCommentViewController ()<UITableViewDelegate,UITableViewDataSource,MNewsCommentTableViewCellDelegate>

@property (nonatomic, strong) NSString *newsId;
@property (nonatomic, strong) NSIndexPath *cellSelectedIndexPath;   //被选中的cell的indexPath
@property (nonatomic, strong) NewsCommentMenuView *commentMenuView;
@property (nonatomic, strong) NewsCommentTextView *commentTextView;
@property (nonatomic, strong) NewsCommentThreadModel *threadModel;
@property (nonatomic, strong) UIButton *originalButton;
@property (nonatomic, assign) BOOL showOriginalButton;
@property (nonatomic, strong) UIView *emptyView;
//改@property (nonatomic, strong) BindingMobilePhoneWindow *bingingPhoneView;
@property (nonatomic, copy) NSString *channel;
@property (nonatomic, strong) UIView *errorView;
@property (nonatomic, strong) YLoadingPanel *loadingPanel;
@end

@implementation NewsCommentViewController

- (instancetype)initWitNewsId:(NSString *)newsId {
    self = [super init];
    if (self) {
        self.newsId = newsId;
        self.hotComments = [NSMutableArray array];
        self.normalComments = [NSMutableArray array];
        self.allComments = [NSMutableArray arrayWithObjects:self.hotComments, self.normalComments, nil];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.hotComments = [NSMutableArray array];
        self.normalComments = [NSMutableArray array];
        self.allComments = [NSMutableArray arrayWithObjects:self.hotComments, self.normalComments, nil];
    }
    return self;
}

- (UITableView *)commentTableView {
    __weak typeof (self)weakSelf = self;
    if (!_commentTableView) {
        _commentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64 - 52)];
        NSBundle *MNewsCommentBundle = [NSBundle bundleWithPath:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"MNewsComment.bundle"]];
        [_commentTableView registerNib:[UINib nibWithNibName:@"NewsCommentTableViewCell" bundle:MNewsCommentBundle] forCellReuseIdentifier:KTableViewCellReuseId];
        [_commentTableView registerClass:[NewsCommentHeaderView class] forHeaderFooterViewReuseIdentifier:kTableViewSectionHeaderReuseId];
        _commentTableView.backgroundColor = [UIColor getColor:@"F0F2F5"];
        _commentTableView.tableHeaderView = [[UIView alloc] init];
        _commentTableView.tableFooterView = [[UIView alloc] init];
        if ([_commentTableView respondsToSelector:@selector(cellLayoutMarginsFollowReadableWidth)]){
            _commentTableView.cellLayoutMarginsFollowReadableWidth = NO;
        }
        _commentTableView.delegate = self;
        _commentTableView.dataSource = self;
        [_commentTableView addInfiniteScrollingWithActionHandler:^{
            [weakSelf pullUpLoadMore];
        }];
    }
    return _commentTableView;
}

- (NewsCommentMenuView *)commentMenuView {
    if (!_commentMenuView) {
        _commentMenuView = [[NewsCommentMenuView alloc] init];
    }
    return _commentMenuView;
}

- (NewsCommentTextView *)commentTextView {
    __weak typeof (self)weakSelf = self;
    if (!_commentTextView) {
        _commentTextView = [[NewsCommentTextView alloc] initWithFrame:CGRectMake(0, KScreenHeight - 52 - 64, KScreenWidth, 52)];
        _commentTextView.commentTextViewBlock = ^(BOOL isSucceed,NewsCommentBaseViewModel *commenModel) {
            if (isSucceed) {
                [weakSelf hideEmptyView];
                [weakSelf.normalComments insertObject:commenModel atIndex:0];
                [weakSelf.commentTableView reloadData];
                [MBProgressHUD showInfo:@"评论成功" toView:weakSelf.view];
            }
        };
        
        if ([self.channel isEqualToString:@"psarticles" ]) {
            _commentTextView.contentTextView.userInteractionEnabled = NO;
            [_commentTextView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentReplyForPsArticles:)]];
        }
    }
    return _commentTextView;
}

- (UIButton *)originalButton {
    if (!_originalButton) {
        _originalButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _originalButton.frame = CGRectMake(0, 0, 38, 30);
        [_originalButton setTitle:@"原文" forState:UIControlStateNormal];
        [_originalButton setTitleColor:[UIColor getColor:@"FFFFFF"] forState:UIControlStateNormal];
        [_originalButton setTitleColor:[UIColor lightTextColor] forState:UIControlStateHighlighted];

        [_originalButton addTarget:self action:@selector(originalButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _originalButton;
}

- (UIView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64)];
        UIImageView *emptyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 70, 90)];
        emptyImageView.image = [UIImage imageNamed:@"MNewsComment.bundle/nocomment"];
        emptyImageView.center = CGPointMake(_emptyView.center.x, _emptyView.center.y - 64);
        [_emptyView addSubview:emptyImageView];
    }
    return _emptyView;
}

- (YLoadingPanel *)loadingPanel {
    if (!_loadingPanel) {
        _loadingPanel = [[YLoadingPanel alloc] init];
        _loadingPanel.frame = self.view.bounds;
        _loadingPanel.internalSpacing = 10.0f;
        _loadingPanel.backgroundColor = [UIColor clearColor];
        _loadingPanel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
    }
    return _loadingPanel;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self __setup];
    [self pullDownRefresh];
}

- (void)__setup {
    self.title = @"评论";
    [self setupNavigationRightButton];
    [self.view addSubview:self.commentTableView];
    self.commentTextView.placeholder = @"我也说两句";
    [self.view addSubview:self.commentTextView];
}

- (void)setupNavigationRightButton {
    if (self.showOriginalButton) {
        UIView *originalButtonView = self.originalButton;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:originalButtonView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.allComments.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.hotComments.count;
    } else {
        return self.normalComments.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [(NewsCommentBaseViewModel *)self.allComments[indexPath.section][indexPath.row] cellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsCommentTableViewCell *cell = (NewsCommentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:KTableViewCellReuseId forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    NewsCommentBaseViewModel *description = self.allComments[indexPath.section][indexPath.row];
    [cell setupCellWithDescription:description];
    return cell;
}

#pragma mark - UITableViewDelegate Methods

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if ([(NSArray *)self.allComments[section] count] == 0) {
        return 0;
    } else {
        return kSectionHeaderHeight;
    }
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if ([(NSArray *)self.allComments[section] count] == 0) {
        return [UIView new];
    }
    NewsCommentHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kTableViewSectionHeaderReuseId];
    if (section == 0) {
        headerView.leftColorView.backgroundColor =[UIColor getColor:@"FF3B2F"];
        headerView.titleLabel.text = @"热门评论";
    } else {
        headerView.leftColorView.backgroundColor = [UIColor getColor:@"688fdb"];
        headerView.titleLabel.text = @"最新评论";
    }
    return headerView;
}

//给cell赋值

#pragma mark - News Comment Request

- (void)pullDownRefresh {
    [self hideErrorView];
    [self showLoadingAnimationWith:YES];
    [self requestHotComments];
    [self requestNewestNormalComments];
}

- (void)pullUpLoadMore {
    [self requestNextPageNormalComments];
}

//请求热门评论
- (void)requestHotComments {
    __weak typeof (self)weakSelf = self;
    NewsCommentHotListRequest *request = [[NewsCommentHotListRequest alloc] init];
    request.channel = self.channel;
    request.count = @"30";
    request.newsId = self.newsId;
    request.successCompletionBlock = request.cacheCompletionBlock = ^(GoldBaseRequest *responseData) {
        if (request.responseObject){
            [weakSelf.hotComments removeAllObjects];
            NewsCommentListResponse *commentListResponse = [[NewsCommentListResponse alloc] initWithContent:responseData.responseObject];
            [weakSelf.hotComments addObjectsFromArray:commentListResponse.comments];
            if (weakSelf.hotComments.count) {
                [weakSelf hideEmptyView];
            }
            [weakSelf.commentTableView reloadData];
        }
    };
    
    request.failureCompletionBlock = ^(GoldBaseRequest *request) {
        ERRLOG(@"%@", request.responseObject);
    };
    
    if (![request loadDataFromCache]) {
        [request start];
    }
}

//请求最新评论
- (void)requestNewestNormalComments {
    __weak typeof (self)weakSelf = self;
    NewsCommentListRequest *request = [[NewsCommentListRequest alloc] init];
    request.channel = self.channel;
    request.count = @"30";
    request.newsId = self.newsId;
    request.successCompletionBlock = request.cacheCompletionBlock = ^(GoldBaseRequest *responseData){
        [weakSelf showLoadingAnimationWith:NO];
        //下拉刷新，删除所有的数据
        if (responseData.responseObject) {
            [weakSelf.normalComments removeAllObjects];
            NewsCommentListResponse *commentListResponse = [[NewsCommentListResponse alloc] initWithContent:responseData.responseObject];
            [weakSelf.normalComments addObjectsFromArray:commentListResponse.comments];
            weakSelf.threadModel = commentListResponse.threadModel;
            weakSelf.commentTextView.threadId = weakSelf.threadModel.threadId;
            if ([weakSelf.threadModel.commentStatus isEqualToString:@"closed"]) {
                [weakSelf showEmptyView];
            } else {
//                [weakSelf.commentTableView dealPullDownRefreshStatus:commentListResponse.comments.count];
                [weakSelf.commentTableView reloadData];
                if (weakSelf.normalComments.count == 0) {
                    [weakSelf showEmptyView];
                }
            }
        }
    };

    request.failureCompletionBlock = ^(GoldBaseRequest *request) {
        ERRLOG(@"%@", request.responseObject);
        [weakSelf.commentTableView stopAnimating];
        [weakSelf showErrorView:@"数据加载失败，点击重试"];
        [weakSelf showLoadingAnimationWith:NO];
    };
    
    if (![request loadDataFromCache]) {
        [request start];
    }
}

//请求下一页评论
- (void)requestNextPageNormalComments {
    __weak typeof (self)weakSelf = self;
    NewsCommentModel *comment = [(NewsCommentBaseViewModel *)self.normalComments.lastObject data];
    NewsCommentListRequest *requeset = [[NewsCommentListRequest alloc] init];
    requeset.channel = self.channel;
    requeset.count = @"30";
    requeset.newsId = self.newsId;
    requeset.downId = comment.commentId;
    requeset.successCompletionBlock = ^(GoldBaseRequest *responseData){
        if (responseData.responseObject) {
            NewsCommentListResponse *commentListResponse = [[NewsCommentListResponse alloc] initWithContent:responseData.responseObject];
            [weakSelf.normalComments addObjectsFromArray:commentListResponse.comments];
//            [weakSelf.commentTableView dealPullUpRefreshStatus:commentListResponse.comments.count];
            [weakSelf.commentTableView reloadData];
        }
    };
    requeset.failureCompletionBlock = ^(GoldBaseRequest *request) {
        [weakSelf.commentTableView stopAnimating];
        [MBProgressHUD showError:[NSString stringWithFormat:@"%@",request.error.localizedDescription] toView:weakSelf.view];
    };

    [requeset start];
}

#pragma mark - MNewsCommentTableViewCellDelegate Methods

- (void)clickCommentlabel:(NewsCommentTableViewCell *)cell {
    NSIndexPath* indexPath = [self.commentTableView indexPathForCell:cell];
    self.cellSelectedIndexPath = indexPath;
    NewsCommentBaseViewModel *description = self.allComments[self.cellSelectedIndexPath.section][self.cellSelectedIndexPath.row];
    self.commentMenuView.commentModel = description.data;
    [self.commentMenuView showPanelView];
    [self.commentMenuView.replyButton addTarget:self
                                    action:@selector(cellReplyAction:)
                          forControlEvents:UIControlEventTouchUpInside];
    [self.commentMenuView.contentCopyButton addTarget:self
                                          action:@selector(cellCopyAction:)
                                forControlEvents:UIControlEventTouchUpInside];
    [self.commentMenuView.reportButton addTarget:self
                                          action:@selector(cellReportyAction:)
                                forControlEvents:UIControlEventTouchUpInside];
}

//回复评论
- (void)cellReplyAction:(id)sender {
    [self commentReply];
}

//复制
- (void)cellCopyAction:(id)sender {
    [self.commentMenuView hidePanelView];
    NewsCommentBaseViewModel *description = self.allComments[self.cellSelectedIndexPath.section][self.cellSelectedIndexPath.row];
    NewsCommentModel *commentModel = description.data;
    NSString *content = commentModel.comment_content;
    if (commentModel.parent) {
        NSString *appendString = [NSString stringWithFormat:@" // %@: %@",commentModel.parent.user.userName,commentModel.parent.comment_content];
    }
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = content;
    [MBProgressHUD showOnlyText:@"复制成功" toView:self.view];
    self.cellSelectedIndexPath = nil;
}

//举报
- (void)cellReportyAction:(id)sender {
    [self.commentMenuView hidePanelView];
    if (![NewsCommentUtil isWSCNUserLogined]) {
        //don't login
        self.cellSelectedIndexPath = nil;
        [NewsCommentUtil loginWSCNAccount];
        return;
    }
#warning TODO 绑定电话号码之后才能举报
//改    UserInfoResponse *userInfoResonse = [NewsCommentUtil getCurrentWSCNUserInfo];
//    UserResponse *user = userInfoResonse.user;
//    if (user.mobile.length == 0) {
//        self.bingingPhoneView = [[BindingMobilePhoneWindow alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
//        return;
//    }
    __weak typeof (self)weakSelf = self;
    NewsCommentBaseViewModel *description = self.allComments[self.cellSelectedIndexPath.section][self.cellSelectedIndexPath.row];
    NewsCommentModel *commentModel = description.data;
    if ([commentModel isReported]) {
        [self.commentMenuView hidePanelView];
        [MBProgressHUD showInfo:@"您已经举报过" toView:self.view];
    } else {
        NewsCommentReportRequest *commentReportRequest = [[NewsCommentReportRequest alloc] init];
        commentReportRequest.commentId = commentModel.commentId;
        commentReportRequest.successCompletionBlock = ^(GoldBaseRequest *responseData){
            NewsCommentReportResponse *commentReportResponse = [[NewsCommentReportResponse alloc] initWithContent:responseData.responseObject];
            [weakSelf.commentMenuView hidePanelView];
            [weakSelf setCommentsReportStatusReported:commentReportResponse.commentModel];
            [MBProgressHUD showInfo:@"举报成功" toView:weakSelf.view];
        };
        commentReportRequest.failureCompletionBlock = ^(GoldBaseRequest *responseData){
            [weakSelf.commentTableView stopAnimating];
            [MBProgressHUD showError:[NSString stringWithFormat:@"%@",responseData.error.localizedDescription] toView:weakSelf.view];

        };
        [commentReportRequest start];
    }
}

/**
 回复评论方法
 */
- (void)commentReply {
    [self.commentMenuView hidePanelView];
    if (![NewsCommentUtil isWSCNUserLogined]) {
        //don't login
        self.cellSelectedIndexPath = nil;
        [NewsCommentUtil loginWSCNAccount];
        return;
    }
    NewsCommentBaseViewModel *description = self.allComments[self.cellSelectedIndexPath.section][self.cellSelectedIndexPath.row];
    NewsCommentModel *commentModel = description.data;
    
    if ([self.channel isEqualToString:@"psarticles" ]) {
        //付费节目单的评论与新闻评论的发表评论的页面不同
        __weak typeof (self)weakSelf = self;
        NewsCommentReplyViewController *replyViewController = [[NewsCommentReplyViewController alloc] init];
        replyViewController.commentModel = commentModel;
        replyViewController.newsId = self.newsId;
        replyViewController.threadId = self.threadModel.threadId;
        [replyViewController setReplyVCPlaceholderWithString:[NSString stringWithFormat:@"回复%@：",commentModel.user.userName]];
        replyViewController.commentReplyVCBlock = ^(BOOL isSucceed,NewsCommentBaseViewModel *commentModel) {
            if (isSucceed) {
                [weakSelf.normalComments insertObject:commentModel atIndex:0];
                [weakSelf.commentTableView reloadData];
                [MBProgressHUD showInfo:@"评论成功" toView:weakSelf.view];
            }
        };
        [self.navigationController pushViewController:replyViewController animated:YES];
    } else {
        [self.commentTableView scrollToRowAtIndexPath:self.cellSelectedIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        if (commentModel.user.userName == nil) {
            self.commentTextView.placeholder = @"回复：";
        } else {
            self.commentTextView.placeholder = [NSString stringWithFormat:@"回复%@：",commentModel.user.userName];
        }
        self.commentTextView.parentId = commentModel.commentId;
        [self.commentTextView newsCommentTextBeginEditing];
        self.cellSelectedIndexPath = nil;
    }
}

//回复评论图标被点击
- (void)clickReply:(NewsCommentTableViewCell *)cell {
    NSIndexPath* indexPath = [self.commentTableView indexPathForCell:cell];
    self.cellSelectedIndexPath = indexPath;
    [self commentReply];
}

#pragma mark - 付费节目单评论的回复

- (void) commentReplyForPsArticles:(id)sender {
    __weak typeof (self)weakSelf = self;
    NewsCommentReplyViewController *replyViewController = [[NewsCommentReplyViewController alloc] init];
    replyViewController.newsId = self.newsId;
    replyViewController.threadId = self.threadModel.threadId;
    replyViewController.commentReplyVCBlock = ^(BOOL isSucceed,NewsCommentBaseViewModel *commentModel) {
        if (isSucceed) {
            [weakSelf hideEmptyView];
            [weakSelf.normalComments insertObject:commentModel atIndex:0];
            [weakSelf.commentTableView reloadData];
            [MBProgressHUD showInfo:@"评论成功" toView:weakSelf.view];
        }
    };
    [self.navigationController pushViewController:replyViewController animated:YES];
}

#pragma mark - 将已经举报的cell的数据更新

- (void)setCommentsReportStatusReported:(NewsCommentModel *)aComment {
    [self.normalComments enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NewsCommentModel *commentModel = [(NewsCommentBaseViewModel *)obj data];
        if ([commentModel.commentId isEqualToString:aComment.commentId]) {
            [commentModel setReportStatusReported];
            *stop = YES;
        }
    }];
    
    [self.hotComments enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NewsCommentModel *commentModel = [(NewsCommentBaseViewModel *)obj data];
        if ([commentModel.commentId isEqualToString:aComment.commentId]) {
            [commentModel setReportStatusReported];
            *stop = YES;
        }
    }];
}

#pragma mark - original button clicked

- (void)originalButtonClicked:(id)sender {
    NSString *nodeRouterString = [NSString stringWithFormat:@"https://wallstreetcn.com/node/%@",self.newsId];
    [[MRouter sharedRouter] handleURL:[NSURL URLWithString:nodeRouterString] userInfo:nil];
}

#pragma mark - show/hide empty view

- (void)showEmptyView {
    self.commentTableView.tableFooterView = self.emptyView;
    [self.commentTableView hideRefreshFooter];
}

- (void)hideEmptyView {
    self.commentTableView.tableFooterView = [[UIView alloc] init];
    self.emptyView = nil;
    [self.commentTableView showRefreshFooter];
}

- (void)showErrorView:(NSString *)error {
    self.errorView = [[UIView alloc] initWithFrame:CGRectMake(KScreenWidth/2-110, KScreenHeight/2-150-64, 220, 200)];
    [self.errorView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pullDownRefresh)]];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.errorView.bounds)/2-90, CGRectGetHeight(self.errorView.bounds)/2 + 25, 180, 50)];
    label.textColor = [UIColor colorWithWhite:0.5 alpha:0.8];
    label.text = error;
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:15];
    
    UIImageView *loadingView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.errorView.bounds)/2-95, CGRectGetHeight(self.errorView.bounds)/2 - 55, 190, 110)];
    loadingView.image = [UIImage sd_animatedGIFNamed:@"detail_logo"];
    loadingView.backgroundColor = [UIColor clearColor];
    loadingView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.errorView addSubview:loadingView];
    [self.errorView addSubview:label];
    [self.view addSubview:self.errorView];
}

- (void)hideErrorView {
    [self.errorView removeFromSuperview];
    self.errorView = nil;
}

#pragma mark --Show loading animation

- (void) showLoadingAnimationWith:(BOOL)flag {
    if (flag) {
        [self.view addSubview:self.loadingPanel];
        [self.loadingPanel doPageLoadingAnimation];
    } else {
        [self.loadingPanel stopPageLoadingAnimation];
        [self.loadingPanel removeFromSuperview];
    }
}

#pragma mark - NewsComment router

- (void)handleRouterLink:(MRouterLink *) link {
    self.newsId = [link.routeParameters stringValueForKey:@"nodeId"];
    if ([link.queryParameters stringValueForKey:@"channel"]) {
        self.channel = [link.queryParameters stringValueForKey:@"channel"];
    } else {
        self.channel = @"news";
    }
    if ([link.queryParameters stringValueForKey:@"show"]) {
        self.showOriginalButton = YES;
    } else {
        self.showOriginalButton = NO;
    }
}

@end
