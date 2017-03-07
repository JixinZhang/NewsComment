//
//  NewsCommentTableViewCell.h
//  MNewsCommentFramework
//
//  Created by ZhangBob on 11/10/2016.
//  Copyright © 2016 Micker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsCommentBaseViewModel.h"
#import "NewsCommentModel.h"

@class NewsCommentTableViewCell;

@protocol MNewsCommentTableViewCellDelegate <NSObject>

- (void)clickReply:(NewsCommentTableViewCell *)cell;
- (void)clickCommentlabel:(NewsCommentTableViewCell *)cell;

@end

@interface NewsCommentTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userAvatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIButton *expandButton;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *voteUpButton;
@property (weak, nonatomic) IBOutlet UIButton *voteDownButton;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *userHeaderBtn;
@property (weak, nonatomic) IBOutlet UIButton *commentContentBtn;
@property (strong, nonatomic) UILabel *commentContentLabel;

@property (nonatomic, copy) void(^voteUpButtonBlock)();
@property (nonatomic, copy) void(^voteDownButtonBlock)();

@property (nonatomic, weak) id<MNewsCommentTableViewCellDelegate> delegate;
@property(nonatomic, strong) NewsCommentBaseViewModel *layoutDescription;

- (void) loadBadgeItems:(NSArray *)badgeItems;
- (void) setupCellWithDescription:(NewsCommentBaseViewModel *)description;

@end
