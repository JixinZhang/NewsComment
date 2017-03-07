//
//  NewsCommentPostResponse.m
//  MNewsCommentFramework
//
//  Created by ZhangBob on 14/10/2016.
//  Copyright © 2016 Micker. All rights reserved.
//

#import "NewsCommentPostResponse.h"

@implementation NewsCommentPostResponse

- (id)initWithContent:(id)content {
    self = [super init];
    if (self) {
        self.commentModel = [[NewsCommentBaseViewModel alloc] initWithContent:content];
    }
    return self;
}

@end
