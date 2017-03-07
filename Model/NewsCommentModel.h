//
//  NewsCommentModel.h
//  MNewsCommentFramework
//
//  Created by ZhangBob on 10/10/2016.
//  Copyright © 2016 Micker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewscommentUserBadge : NSObject

@property(nonatomic, copy) NSString* imageUrl;
@property(nonatomic, copy) NSString* badgeId;

@end

@interface NewsCommentUser : NSObject

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, strong) NSArray *tags;
@property (nonatomic, strong) NSArray *badges;

@end

@interface NewsCommentParent : NSObject

@property (nonatomic, copy) NSString *commentId;
@property (nonatomic, copy) NSString *comment_content;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *upVotes;
@property (nonatomic, copy) NSString *downVotes;
@property (nonatomic, copy) NSString *createdAt;
@property (nonatomic, strong) NewsCommentUser *user;

@end

@interface NewsCommentModel : NSObject

@property (nonatomic, copy) NSString *commentId;
@property (nonatomic, copy) NSString *comment_content;
@property (nonatomic, copy) NSString *upVotes;
@property (nonatomic, copy) NSString *downVotes;
@property (nonatomic, copy) NSString *createdAt;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) BOOL isHighlight;
@property (nonatomic, strong) NSNumber *isExcellent;
@property (nonatomic, strong) NSNumber *reportStatus;
@property (nonatomic, strong) NewsCommentUser *user;
@property (nonatomic, strong) NewsCommentParent *parent;

//评论已删除
+ (NSString *) parentDeleteDescription;
- (BOOL) isParentCommentDeleted;

//举报
- (BOOL)isReported;
- (void)setReportStatusReported;

@end
