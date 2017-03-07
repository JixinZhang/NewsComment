//
//  NewsCommentHotListRequest.h
//  MNewsCommentFramework
//
//  Created by ZhangBob on 10/10/2016.
//  Copyright © 2016 Micker. All rights reserved.
//

#import <GoldRPCFramework/GoldRPCFramework.h>

@interface NewsCommentHotListRequest : GoldRequest

@property (nonatomic, copy) NSString *channel;
@property (nonatomic, copy) NSString *count;
@property (nonatomic, copy) NSString *newsId;

@end
