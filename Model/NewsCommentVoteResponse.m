//
//  NewsCommentVoteResponse.m
//  MNewsCommentFramework
//
//  Created by ZhangBob on 19/10/2016.
//  Copyright © 2016 Micker. All rights reserved.
//

#import "NewsCommentVoteResponse.h"

@implementation NewsCommentVoteResponse

- (id)initWithContent:(id)content {
    self = [super init];
    if (self) {
        self.vid = [content valueForKey:@"id"];
        self.commentId = [content valueForKey:@"commentId"];
        self.userId = [content valueForKey:@"userId"];
        self.action = [content valueForKey:@"action"];
        self.createdAt = [content valueForKey:@"createdAt"];
        self.total = [content valueForKey:@"total"];
        self.voted = [content valueForKey:@"voted"];
        self.num = [content valueForKey:@"num"];
    }
    return self;
}

@end
