//
//  NewsCommentThreadModel.m
//  MNewsCommentFramework
//
//  Created by ZhangBob on 14/10/2016.
//  Copyright © 2016 Micker. All rights reserved.
//

#import "NewsCommentThreadModel.h"

@implementation NewsCommentThreadModel

- (id)initWithContent:(id)content {
    self = [super init];
    if (self) {
        self = [NewsCommentThreadModel yy_modelWithJSON:content];
    }
    return self;
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"threadId" : @"id",
             @"newsTitle" : @"title"
             };
}

@end
