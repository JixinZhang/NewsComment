//
//  NewsCommentVoteRequest.h
//  MNewsCommentFramework
//
//  Created by ZhangBob on 19/10/2016.
//  Copyright © 2016 Micker. All rights reserved.
//

#import <GoldRPCFramework/GoldRPCFramework.h>

@interface NewsCommentVoteDownRequest : GoldRequest

@property (nonatomic, copy) NSString *commentId;

@end

@interface NewsCommentVoteUpRequest : GoldRequest

@property (nonatomic, copy) NSString *commentId;

@end
