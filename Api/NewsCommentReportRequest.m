//
//  NewsCommentReportRequest.m
//  MNewsCommentFramework
//
//  Created by ZhangBob on 14/10/2016.
//  Copyright © 2016 Micker. All rights reserved.
//

#import "NewsCommentReportRequest.h"

@implementation NewsCommentReportRequest

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"/v2/comment/%@/report",self.commentId];
}

- (GoldRequestMethod)requestMethod {
    return GoldRequestMethodPost;
}

@end
