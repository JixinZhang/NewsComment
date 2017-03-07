//
//  NewsCommentVoteResponse.h
//  MNewsCommentFramework
//
//  Created by ZhangBob on 19/10/2016.
//  Copyright © 2016 Micker. All rights reserved.
//

#import <GoldRPCFramework/GoldRPCFramework.h>

@interface NewsCommentVoteResponse : GoldBaseReponse

@property (nonatomic, copy) NSString *vid;
@property (nonatomic, copy) NSString *commentId;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *action;
@property (nonatomic, copy) NSString *createdAt;
@property (nonatomic, copy) NSString *total;
@property (nonatomic, copy) NSString *num;
@property (nonatomic, strong) NSNumber *voted;

@end
