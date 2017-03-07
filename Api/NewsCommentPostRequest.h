//
//  NewsCommentPostRequest.h
//  MNewsCommentFramework
//
//  Created by ZhangBob on 14/10/2016.
//  Copyright © 2016 Micker. All rights reserved.
//

#import <GoldRPCFramework/GoldRPCFramework.h>

@interface NewsCommentPostRequest : GoldRequest

@property (nonatomic, copy) NSString *threadId;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *parentId;
@property (nonatomic, copy) NSString *uniqueKey;    //接口提供的参数，zeus中没有使用

@end
