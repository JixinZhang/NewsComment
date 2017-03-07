//
//  NewsCommentListResponse.m
//  MNewsCommentFramework
//
//  Created by ZhangBob on 12/10/2016.
//  Copyright © 2016 Micker. All rights reserved.
//

#import "NewsCommentListResponse.h"
#import "NewsCommentBaseViewModel.h"
#import "NewsCommentThreadModel.h"

@implementation NewsCommentListResponse

- (id)initWithContent:(id)content {
    self = [super init];
    if (self) {
        self.comments = [NSMutableArray array];
        [self appendContent:content];
    }
    return self;
}

- (void)appendContent:(id)content {
    self.threadId = [content valueForKey:@"threadId"];
    self.threadModel = [[NewsCommentThreadModel alloc] initWithContent:[content valueForKey:@"thread"]];
    NSArray *comments = [content valueForKey:@"comments"];
    @autoreleasepool {
        __weak __typeof__(self) weakSelf = self;
        Class clss = [NewsCommentBaseViewModel class];
        if (clss) {
            [comments enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NewsCommentBaseViewModel *item = [[NewsCommentBaseViewModel alloc] initWithContent:obj];
                [weakSelf.comments addObject:item];
            }];
        }
    }
}

@end
