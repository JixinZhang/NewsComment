//
//  NewsCommentVoteModel.m
//  MNewsCommentFramework
//
//  Created by ZhangBob on 18/10/2016.
//  Copyright © 2016 Micker. All rights reserved.
//

#import "NewsCommentStoreVoteModel.h"

@implementation NewsCommentVoteUpModel

- (NSString *) dbTableName {
    return @"NewsCommentVoteUpTable";
}

- (NSString *) dbTablePrimaryKey {
    return @"commentIdUserId";
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.commentIdUserId forKey:@"commentIdUserId"];
    [aCoder encodeObject:self.type forKey:@"type"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        if (aDecoder == nil) {
            return self;
        }
        self.commentIdUserId = [aDecoder decodeObjectForKey:@"commentIdUserId"];
        self.type = [aDecoder decodeObjectForKey:@"type"];
    }
    return self;
}


@end

@implementation NewsCommentVoteDownModel

- (NSString *) dbTableName {
    return @"NewsCommentVoteDownTable";
}

- (NSString *) dbTablePrimaryKey {
    return @"commentIdUserId";
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.commentIdUserId forKey:@"commentIdUserId"];
    [aCoder encodeObject:self.type forKey:@"type"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        if (aDecoder == nil) {
            return self;
        }
        self.commentIdUserId = [aDecoder decodeObjectForKey:@"commentIdUserId"];
        self.type = [aDecoder decodeObjectForKey:@"type"];
    }
    return self;
}


@end
