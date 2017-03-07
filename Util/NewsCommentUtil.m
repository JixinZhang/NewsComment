//
//  NewsCommentUtil.m
//  MNewsCommentFramework
//
//  Created by ZhangBob on 11/10/2016.
//  Copyright © 2016 Micker. All rights reserved.
//

#import "NewsCommentUtil.h"

@implementation NewsCommentUtil

+ (BOOL)isWSCNUserLogined {
    return [YAccountService() isLogined];
}



+ (NSString *) qiniuFormatImageUrlFromUrl:(NSString *)url width:(int)width height:(int)height{
    return [url stringByAppendingFormat:@"?imageView2/1/h/%ld/w/%ld/q/100", (long)height, (long)width];
}

+ (BOOL)loginWSCNAccount {
    BOOL result = [[MRouter sharedRouter] handleURL:[NSURL URLWithString:@"https://passport.wallstreetcn.com/login"] userInfo:nil];
    return result;
}

@end
