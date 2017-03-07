//
//  NewsCommentReportResponse.m
//  MNewsCommentFramework
//
//  Created by ZhangBob on 14/10/2016.
//  Copyright © 2016 Micker. All rights reserved.
//

#import "NewsCommentReportResponse.h"

@implementation NewsCommentReportResponse

- (id)initWithContent:(id)content {
    self = [super init];
    if (self) {
        self.commentModel = [[NewsCommentModel alloc] init];
        self.commentModel.commentId = [content valueForKey:@"commentId"];
        self.commentModel.createdAt = [content valueForKey:@"createdAt"];
    }
    return self;
}

@end
