//
//  NewsCommentPostRequest.m
//  MNewsCommentFramework
//
//  Created by ZhangBob on 14/10/2016.
//  Copyright © 2016 Micker. All rights reserved.
//

#import "NewsCommentPostRequest.h"

@implementation NewsCommentPostRequest

- (NSString *)requestUrl {
    return @"v2/comments";
}

- (GoldRequestMethod)requestMethod {
    return GoldRequestMethodPost;
}

- (id)requestArgument {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:self.threadId forKey:@"threadId"];
    [dict setValue:self.content forKey:@"content"];
    [dict setValue:self.parentId forKey:@"parentId"];
    return dict;
}

@end
