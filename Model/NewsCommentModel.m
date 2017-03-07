//
//  NewsCommentModel.m
//  MNewsCommentFramework
//
//  Created by ZhangBob on 10/10/2016.
//  Copyright © 2016 Micker. All rights reserved.
//

#import "NewsCommentModel.h"

@implementation NewscommentUserBadge

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"badgeId" : @"id",
             @"imageUrl" : @"image"
             };
}

@end


@implementation NewsCommentUser

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"userId" : @"id",
             @"userName" : @"name"
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"badges" : [NewscommentUserBadge class]
             };
}


@end

@implementation NewsCommentParent

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"commentId" : @"id",
             @"comment_content" : @"content"
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"user" : [NewsCommentUser class],
             };
}

@end

@implementation NewsCommentModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"commentId" : @"id",
             @"comment_content" : @"content",
             @"reportStatus" : @"report"
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"user" : [NewsCommentUser class],
             @"parent" : [NewsCommentParent class]
             };
}

+ (NSString *) parentDeleteDescription {
    return @"[评论已删除]";
}

- (BOOL) isParentCommentDeleted{
    return ![self.parent.status isEqualToString:@"approved"];
}

//举报
- (BOOL)isReported {
    return self.reportStatus.intValue == 1;
}

- (void)setReportStatusReported {
    self.reportStatus = @1;
}

@end
