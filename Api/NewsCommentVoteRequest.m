//
//  NewsCommentVoteRequest.m
//  MNewsCommentFramework
//
//  Created by ZhangBob on 19/10/2016.
//  Copyright © 2016 Micker. All rights reserved.
//

#import "NewsCommentVoteRequest.h"

@implementation NewsCommentVoteDownRequest

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"v2/comments/%@/down",self.commentId];
}

- (id)requestArgument {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:self.commentId forKey:@"commentId"];
    return dict;
}

@end

@implementation NewsCommentVoteUpRequest

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"v2/comments/%@/up",self.commentId];
}

- (id)requestArgument {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:self.commentId forKey:@"commentId"];
    return dict;
}
@end
