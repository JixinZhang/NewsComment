//
//  NewsCommentListRequest.m
//  MNewsCommentFramework
//
//  Created by ZhangBob on 10/10/2016.
//  Copyright © 2016 Micker. All rights reserved.
//

#import "NewsCommentListRequest.h"

@implementation NewsCommentListRequest

- (NSString *)requestUrl {
    return @"v2/comments";
}

- (GOLD_REQUEST_CACHE_TYPE) cacheType {
    return GOLD_REQUEST_CACHE_DISK_AND_REMOTE;
}

- (NSInteger)cacheTimeInSeconds {
    return 5 * 60;  //5 minutes
}

- (id)requestArgument {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (self.newsId) {
        [dict setValue:self.channel forKey:@"channel"];
        [dict setValue:self.count forKey:@"count"];
        [dict setValue:self.newsId forKey:@"id"];
        [dict setValue:self.downId forKey:@"down_id"];
        [dict setValue:self.upId forKey:@"up_id"];
        return dict;
    } else {
        return nil;
    }
}

@end
