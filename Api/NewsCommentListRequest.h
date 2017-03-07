//
//  NewsCommentListRequest.h
//  MNewsCommentFramework
//
//  Created by ZhangBob on 10/10/2016.
//  Copyright © 2016 Micker. All rights reserved.
//

#import <GoldRPCFramework/GoldRPCFramework.h>

@interface NewsCommentListRequest : GoldRequest

@property (nonatomic, copy) NSString *channel;
@property (nonatomic, copy) NSString *count;
@property (nonatomic, copy) NSString *newsId;
@property (nonatomic, copy) NSString *downId;
@property (nonatomic, copy) NSString *upId;

@end
