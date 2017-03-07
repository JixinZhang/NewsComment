//
//  NewsCommentUtil.h
//  MNewsCommentFramework
//
//  Created by ZhangBob on 11/10/2016.
//  Copyright © 2016 Micker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YAccountFramework/YAccountFramework.h>
#import "NewsCommentColorTool.h"

@interface NewsCommentUtil : NSObject

/**
 判断是否登陆见闻账户
 
 @return 登陆：返回YES；未登陆：NO。
 */
+ (BOOL)isWSCNUserLogined;

/**
 获取当前登陆的见闻账户信息
 
 @return UserInfoResponse
 */
//+ (UserInfoResponse *)getCurrentWSCNUserInfo;


/**
 图片压缩

 @param url    图片的url
 @param width  所需要的width
 @param height 所需要的hight

 @return NSString
 */
+ (NSString *) qiniuFormatImageUrlFromUrl:(NSString *)url width:(int)width height:(int)height;

/**
 见闻登陆界面
 
 @return 返回BOOL型数据
 */
+ (BOOL)loginWSCNAccount;

@end
