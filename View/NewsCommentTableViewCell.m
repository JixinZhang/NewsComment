//
//  NewsCommentTableViewCell.m
//  MNewsCommentFramework
//
//  Created by ZhangBob on 11/10/2016.
//  Copyright © 2016 Micker. All rights reserved.
//

#import "NewsCommentTableViewCell.h"
#import "NewsCommentUserBadgeImageView.h"
#import "NewsCommentUtil.h"
#import "NewsCommentViewController.h"
#import "UIImage+NewsCommentImageEffects.h"
#import "NewsCommentStoreVoteModel.h"
#import "NewsCommentVoteRequest.h"
#import "NewsCommentVoteResponse.h"

#define kBadgeSize 25.f

@interface NewsCommentTableViewCell()

@property (strong, nonatomic) IBOutlet UIView *badgeContainerView;
@property (nonatomic, strong) NSMutableArray* badgeImageViews;
@property (nonatomic, readonly) NewsCommentViewController *newsCommentVC;
@property (nonatomic, copy) NSString *userId;

@end

@implementation NewsCommentTableViewCell

- (NewsCommentViewController *)newsCommentVC {
    return (NewsCommentViewController *)self.viewController;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configButton];
    [self configUsernameLabel];
    [self configCommentContentLabel];
}

- (NSString *)userId {
    if (!_userId) {
        _userId = [YAccountService() currentAccountUserId].length ? [YAccountService() currentAccountUserId] : @"guest";
    }
    return _userId;
}

- (void) loadBadgeItems:(NSArray *)items {
    if (!_badgeImageViews) {
        _badgeImageViews = [NSMutableArray array];
    }
    
    CGFloat size = [UIScreen mainScreen].scale * kBadgeSize;
    for (NSInteger index = 0; index < items.count; index++) {
        NewscommentUserBadge *badge = items[index];
        NewsCommentUserBadgeImageView *badgeImageView = [[NewsCommentUserBadgeImageView alloc] initWithFrame:CGRectMake((index * 30), 0, kBadgeSize, kBadgeSize)];
        badgeImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showArchievementWindowAction:)];
        badgeImageView.badgeId = badge.badgeId;
        [badgeImageView addGestureRecognizer:tapGesture];
        [self.badgeContainerView addSubview:badgeImageView];
        [self.badgeImageViews addObject:badgeImageView];
        NSString* smallUrl = [NewsCommentUtil qiniuFormatImageUrlFromUrl:badge.imageUrl width:size height:size];
        [badgeImageView sd_setImageWithURL:[NSURL URLWithString:smallUrl] placeholderImage:nil];
    }
    if (items.count > 0){
        self.badgeContainerView.hidden = NO;
        if (self.badgeImageViews.count > items.count){
            NSRange range = NSMakeRange(items.count, self.badgeImageViews.count - items.count);
            NSArray* imageViews = [self.badgeImageViews subarrayWithRange:range];
            [imageViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [self.badgeImageViews removeObjectsInRange:range];
        }
    } else{
        self.badgeContainerView.hidden = YES;
        [self.badgeImageViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.badgeImageViews removeAllObjects];
    }
}

- (UIImageView *) badgeImageViewAtIndex:(NSInteger)index{
    if (index < self.badgeImageViews.count){
        return self.badgeImageViews[index];
    }else{
        return [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25.f, 25.f)];
    }
}

-(void)configButton {
    [self.expandButton setTitleColor:kColourWithRGB(20, 80, 160) forState:UIControlStateNormal];
    [self.expandButton setTitleColor:kColourWithRGB(20, 80, 160) forState:UIControlStateSelected];
    [self.expandButton addTarget:self action:@selector(expandButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self.voteUpButton setTitleColor:kColourWithRGB(102, 102, 102) forState:UIControlStateNormal];
    [self.voteUpButton addTarget:self action:@selector(voteUpButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self.voteDownButton setTitleColor:kColourWithRGB(102, 102, 102) forState:UIControlStateNormal];
    [self.voteDownButton addTarget:self action:@selector(voteDownButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self.replyButton setTitleColor:kColourWithRGB(170, 170, 170) forState:UIControlStateNormal];
    
    [self.usernameLabel setTextColor:kColourWithRGB(102, 102, 102)];
    [self.dateLabel setTextColor:kColourWithRGB(170, 170, 170)];
}

- (void) configUsernameLabel{
    self.usernameLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(usernameLabelTapped:)];
    [self.usernameLabel addGestureRecognizer:gesture];
}

- (void) configCommentContentLabel{
    self.commentContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width - 15 - 60, 47)];
    self.commentContentLabel.font = [UIFont systemFontOfSize:16.0];
    self.commentContentLabel.numberOfLines = 0;
    
    UIImage *buttonBgImage = [UIImage newsCommentImageFromColor:[UIColor lightGrayColor] withSize:self.commentContentLabel.frame.size];
    [self.commentContentBtn setBackgroundImage:buttonBgImage forState:UIControlStateHighlighted];
    [self.commentContentBtn addTarget:self action:@selector(commentContentBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.commentContentBtn addSubview:self.commentContentLabel];
}

#pragma mark - gesture recognizer

- (void) usernameLabelTapped:(id)sender{
    [self gotoAuthorVC];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void) layoutSubviews{
    [super layoutSubviews];
    [self layoutUsernameLabel];
    [self layoutBadgeViews];
    [self layoutDateLabel];
    [self layoutTopViews];
    [self layoutCommentContentLabel];
    [self layoutReplyButton];
}

- (void) layoutUsernameLabel{
    CGSize usernameSize = [self.usernameLabel sizeThatFits:CGSizeMake(self.frame.size.width, self.usernameLabel.frame.size.height)];
    CGRect usernameRect = self.usernameLabel.frame;
    usernameRect.size.width = usernameSize.width;
    self.usernameLabel.frame = usernameRect;
}

- (void) layoutBadgeViews{
    CGRect frame = self.badgeContainerView.frame;
    if (self.badgeContainerView.hidden){
        frame.size.width = 0.f;
        frame.origin.x = CGRectGetMaxX(self.usernameLabel.frame);
    }else{
        frame.size.width = self.badgeImageViews.count * 30 - 5;
        frame.origin.x = CGRectGetMaxX(self.usernameLabel.frame) + 7;
    }
    self.badgeContainerView.frame = frame;
}

- (void) layoutDateLabel{
    CGSize dateSize = [self.dateLabel sizeThatFits:CGSizeMake(self.frame.size.width, self.usernameLabel.frame.size.height)];
    CGRect frame = self.dateLabel.frame;
    frame.origin.x = CGRectGetMaxX(!self.badgeContainerView.hidden ? self.badgeContainerView.frame : self.usernameLabel.frame) + 7;
    frame.size.width = dateSize.width;
    self.dateLabel.frame = frame;
}

- (void) layoutTopViews{
    CGRect usernameFrame = self.usernameLabel.frame;
    CGRect badgeFrame = self.badgeContainerView.frame;
    CGRect dateFrame = self.dateLabel.frame;
    if (CGRectGetMaxX(dateFrame) > self.bounds.size.width){
        if (!self.badgeContainerView.hidden){
            self.badgeContainerView.hidden = YES;
            dateFrame.origin.x = badgeFrame.origin.x;
        }else{
            dateFrame.origin.x = self.bounds.size.width - dateFrame.size.width;
            usernameFrame.size.width = dateFrame.origin.x - 7 - usernameFrame.origin.x;
            self.usernameLabel.frame = usernameFrame;
        }
        self.dateLabel.frame = dateFrame;
    }
}

- (void) layoutCommentContentLabel{
    //评论label，设置frame
    CGRect contentFrame = self.commentContentLabel.frame;
    contentFrame.size.width = self.frame.size.width - 15 - 60;
    if (self.layoutDescription.expanded){
        contentFrame.size.height = self.layoutDescription.expandContentHeight;
    }else{
        contentFrame.size.height = self.layoutDescription.shrinkContentHeight;
    }
    self.commentContentLabel.frame = contentFrame;
    //评论button，设置frame
    CGRect commentContentBtnFrame = self.commentContentBtn.frame;
    commentContentBtnFrame.size.height = self.commentContentLabel.frame.size.height;
    commentContentBtnFrame.size.width = self.frame.size.width - 15 - 60;
    self.commentContentBtn.frame = commentContentBtnFrame;
}

- (void) layoutReplyButton {
    CGRect replyFrame = self.replyButton.frame;
    replyFrame.origin.x = CGRectGetMinX(self.voteUpButton.frame) - 52;
    self.replyButton.frame = replyFrame;
}

#pragma mark - Button Clicked

//评论内容点击
- (void)commentContentBtnClicked:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(clickCommentlabel:)]) {
        [_delegate clickCommentlabel:self];
    }
}

- (IBAction)replyBtnClick {
    if (_delegate && [_delegate respondsToSelector:@selector(clickReply:)]) {
        [_delegate clickReply:self];
    }
}

- (IBAction)clickUserHeaderBtn:(id)sender {
    [self gotoAuthorVC];
}

//展开、收起按钮
- (void)expandButtonClicked {
    NSIndexPath* indexPath = [self.newsCommentVC.commentTableView indexPathForCell:self];
    NewsCommentBaseViewModel *description = self.newsCommentVC.allComments[indexPath.section][indexPath.row];
    description.expanded = !description.expanded;
    [self.newsCommentVC.commentTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

//点赞
- (void)voteUpButtonClicked {
    if (![NewsCommentUtil isWSCNUserLogined]) {
        [NewsCommentUtil loginWSCNAccount];
        return;
    }
    
    NSIndexPath* indexPath = [self.newsCommentVC.commentTableView indexPathForCell:self];
    NewsCommentBaseViewModel *description = self.newsCommentVC.allComments[indexPath.section][indexPath.row];
    NewsCommentModel *commentModel = description.data;
    NewsCommentVoteUpModel *voteUpModel = [[NewsCommentVoteUpModel alloc] init];
    voteUpModel.commentIdUserId = [NSString stringWithFormat:@"%@_%@",commentModel.commentId,self.userId];
    voteUpModel.type = @"voteUp";

    NewsCommentVoteUpRequest *voteUpRequest = [[NewsCommentVoteUpRequest alloc] init];
    voteUpRequest.commentId = commentModel.commentId;
    __weak typeof (self)weakSelf = self;
    if (self.voteUpButton.selected ) {
        voteUpRequest.requestMethod = GoldRequestMethodDelete;
        voteUpRequest.successCompletionBlock = ^(GoldBaseRequest *responseData){
            NewsCommentVoteResponse *voteResponse = [[NewsCommentVoteResponse alloc] initWithContent:responseData.responseObject];
            DEBUGLOG(@"%@",voteResponse);
            [[GoldDataOperateCenter sharedInstance] deleteDB:voteUpModel block:nil];
            [weakSelf resetVoteCountWith:voteResponse];
        };
        voteUpRequest.failureCompletionBlock = ^(GoldBaseRequest *responseData){
            [MBProgressHUD showError:[NSString stringWithFormat:@"取消赞失败，%@",responseData.error.localizedDescription]
                              toView:weakSelf.newsCommentVC.view];
        };
        [voteUpRequest start];
        
    } else {
        voteUpRequest.requestMethod = GoldRequestMethodPost;
        voteUpRequest.successCompletionBlock = ^(GoldBaseRequest *responseData){
            NewsCommentVoteResponse *voteResponse = [[NewsCommentVoteResponse alloc] initWithContent:responseData.responseObject];
            [[GoldDataOperateCenter sharedInstance] insertDB:voteUpModel block:nil];
            [weakSelf resetVoteCountWith:voteResponse];
        };
        voteUpRequest.failureCompletionBlock = ^(GoldBaseRequest *responseData){
            [MBProgressHUD showError:[NSString stringWithFormat:@"赞失败，%@",responseData.error.localizedDescription]
                              toView:weakSelf.newsCommentVC.view];
        };
        [voteUpRequest start];
    }
}

//点不赞
- (void)voteDownButtonClicked {
    if (![NewsCommentUtil isWSCNUserLogined]) {
        [NewsCommentUtil loginWSCNAccount];
        return;
    }
    
    NSIndexPath* indexPath = [self.newsCommentVC.commentTableView indexPathForCell:self];
    NewsCommentBaseViewModel *description = self.newsCommentVC.allComments[indexPath.section][indexPath.row];
    NewsCommentModel *commentModel = description.data;
    NewsCommentVoteDownModel *voteDownModel = [[NewsCommentVoteDownModel alloc] init];
    voteDownModel.commentIdUserId = [NSString stringWithFormat:@"%@_%@",commentModel.commentId,self.userId];
    voteDownModel.type = @"voteDown";
    
    NewsCommentVoteDownRequest *voteDownRequest = [[NewsCommentVoteDownRequest alloc] init];
    voteDownRequest.commentId = commentModel.commentId;
    
    __weak typeof (self)weakSelf = self;
    if (self.voteDownButton.selected) {
        voteDownRequest.requestMethod = GoldRequestMethodDelete;
        voteDownRequest.successCompletionBlock = ^(GoldBaseRequest *responseData){
            NewsCommentVoteResponse *voteResponse = [[NewsCommentVoteResponse alloc] initWithContent:responseData.responseObject];
            DEBUGLOG(@"%@",voteResponse);
            [[GoldDataOperateCenter sharedInstance] deleteDB:voteDownModel block:nil];
            [weakSelf resetVoteCountWith:voteResponse];
        };
        voteDownRequest.failureCompletionBlock = ^(GoldBaseRequest *responseData){
            [MBProgressHUD showError:[NSString stringWithFormat:@"取消踩失败，%@",responseData.error.localizedDescription]
                              toView:weakSelf.newsCommentVC.view];
        };
        [voteDownRequest start];
    } else {
        voteDownRequest.requestMethod = GoldRequestMethodPost;
        voteDownRequest.successCompletionBlock = ^(GoldBaseRequest *responseData){
            NewsCommentVoteResponse *voteResponse = [[NewsCommentVoteResponse alloc] initWithContent:responseData.responseObject];
            DEBUGLOG(@"%@",voteResponse);
            [[GoldDataOperateCenter sharedInstance] insertDB:voteDownModel block:nil];
            [weakSelf resetVoteCountWith:voteResponse];
        };
        voteDownRequest.failureCompletionBlock = ^(GoldBaseRequest *responseData){
            [MBProgressHUD showError:[NSString stringWithFormat:@"踩失败，%@",responseData.error.localizedDescription]
                              toView:weakSelf.newsCommentVC.view];
        };
        [voteDownRequest start];
    }
    if (self.voteDownButtonBlock) {
        self.voteDownButtonBlock();
    }
}

#pragma mark - go to MAuthorViewController 

- (void)gotoAuthorVC {
    NSIndexPath* indexPath = [self.newsCommentVC.commentTableView indexPathForCell:self];
    NewsCommentBaseViewModel *description = self.newsCommentVC.allComments[indexPath.section][indexPath.row];
    NewsCommentModel *commentModel = description.data;
    NSString *string = [NSString stringWithFormat:@"http://s.wallstreetcn.com/users/%@",commentModel.user.userId];
    [[MRouter sharedRouter] handleURL:[NSURL URLWithString:string] userInfo:nil];
}

#pragma mark - setup Cell

- (void)setupCellWithDescription:(NewsCommentBaseViewModel *)description {
    self.layoutDescription = description;
    
    self.commentContentLabel.attributedText = description.attributedContent;
    
    self.expandButton.hidden = !description.expandable;
    self.expandButton.selected = description.expanded;
    
    NewsCommentModel* comment = (NewsCommentModel *)description.data;
    [self.userAvatarImageView sd_setImageWithURL:[NSURL URLWithString:[description.data user].avatar]
                                placeholderImage:[UIImage imageNamed:@"avatar_default"]];
    [self loadBadgeItems:comment.user.badges];
    
    self.usernameLabel.attributedText = description.attributedTitle;
    self.dateLabel.text = description.dateText;
    
    [self.voteDownButton setTitle:[NSString stringWithFormat:@"%@", comment.downVotes] forState:UIControlStateNormal];
    [self.voteDownButton setTitle:[NSString stringWithFormat:@"%@", comment.downVotes] forState:UIControlStateSelected];
    self.voteDownButton.selected = [self hadVotedDownWithCommentId:description.data.commentId];
    
    [self.voteUpButton setTitle:[NSString stringWithFormat:@"%@", comment.upVotes] forState:UIControlStateNormal];
    [self.voteUpButton setTitle:[NSString stringWithFormat:@"%@", comment.upVotes] forState:UIControlStateSelected];
    self.voteUpButton.selected = [self hadVotedUpWithCommentId:description.data.commentId];
}

#pragma mark - TapGesture

- (void)showArchievementWindowAction: (UITapGestureRecognizer *)tapGesture {
   
}

#pragma mark - 判断是否点赞

- (BOOL)hadVotedUpWithCommentId:(NSString *)commentId {
    __block BOOL hadVoted = NO;
    __weak typeof (self) weakSelf = self;
    NewsCommentVoteUpModel *voteUpModel = [[NewsCommentVoteUpModel alloc] init];
    voteUpModel.type = @"voteUp";
    voteUpModel.commentIdUserId = [NSString stringWithFormat:@"%@_%@",commentId,self.userId];
    [[GoldDataOperateCenter sharedInstance] selectDB:voteUpModel block:^(NSArray *items, NSError *error) {
        if (items.count) {
            NewsCommentVoteUpModel *voteModelLocal = items.firstObject;
            NSArray *stringArr = [voteModelLocal.commentIdUserId componentsSeparatedByString:@"_"];
            NSString *localUserId = stringArr.lastObject;
            if ([voteModelLocal.type isEqualToString:@"voteUp"] &&
                 [localUserId isEqualToString:weakSelf.userId]) {
                 hadVoted = YES;
            }
        }
    }];
    return hadVoted;
}

- (BOOL)hadVotedDownWithCommentId:(NSString *)commentId {
    __block BOOL hadVoted = NO;
    __weak typeof (self) weakSelf = self;
    NewsCommentVoteDownModel *voteDownModel = [[NewsCommentVoteDownModel alloc] init];
    voteDownModel.type = @"voteDown";
    voteDownModel.commentIdUserId = [NSString stringWithFormat:@"%@_%@",commentId,self.userId];
    [[GoldDataOperateCenter sharedInstance] selectDB:voteDownModel block:^(NSArray *items, NSError *error) {
        if (items.count) {
            NewsCommentVoteDownModel *voteModelLocal = items.firstObject;
            NSArray *stringArr = [voteModelLocal.commentIdUserId componentsSeparatedByString:@"_"];
            NSString *localUserId = stringArr.lastObject;
            if ([voteModelLocal.type isEqualToString:@"voteDown"] &&
                [localUserId isEqualToString:weakSelf.userId]) {
                hadVoted = YES;
            }
        }
    }];
    return hadVoted;
}

#pragma mark - 更改点赞／点踩数

- (void)resetVoteCountWith:(NewsCommentVoteResponse *)voteResponse {
    NSString *action = voteResponse.action;
    
    NSIndexPath* indexPath = [self.newsCommentVC.commentTableView indexPathForCell:self];
    if (!indexPath) {
        return;
    }
    NewsCommentBaseViewModel *description = self.newsCommentVC.allComments[indexPath.section][indexPath.row];
    NewsCommentModel *commentModel = description.data;
    if ([action isEqualToString:@"up"]) {
        if (voteResponse.voted.integerValue > 0) {
            [MBProgressHUD showInfo:@"您已赞过" toView:self.newsCommentVC.view];
        } else {
            NSInteger upVotes;
            if ([self hadVotedUpWithCommentId:description.data.commentId]) {
                upVotes = commentModel.upVotes.integerValue + 1;
            } else {
                upVotes = commentModel.upVotes.integerValue - 1;
            }
            if (upVotes < 0) {upVotes = 0;}
            commentModel.upVotes = [NSString stringWithFormat:@"%ld",upVotes];
        }
    } else if ([action isEqualToString:@"down"]) {
        if (voteResponse.voted.integerValue > 0) {
            [MBProgressHUD showInfo:@"您已踩过" toView:self.newsCommentVC.view];
        } else {
            NSInteger downVotes;
            if ([self hadVotedDownWithCommentId:description.data.commentId]) {
                downVotes = commentModel.downVotes.integerValue + 1;
            } else {
                downVotes = commentModel.downVotes.integerValue - 1;
            }
            if (downVotes < 0) {downVotes = 0;}
            commentModel.downVotes = [NSString stringWithFormat:@"%ld",downVotes];
        }
    }
    description.data = commentModel;
    [(NSMutableArray *)self.newsCommentVC.allComments[indexPath.section] replaceObjectAtIndex:indexPath.row withObject:description];
    [self.newsCommentVC.commentTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
