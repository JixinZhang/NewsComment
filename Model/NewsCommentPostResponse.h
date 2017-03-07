//
//  NewsCommentPostResponse.h
//  MNewsCommentFramework
//
//  Created by ZhangBob on 14/10/2016.
//  Copyright © 2016 Micker. All rights reserved.
//

#import <GoldRPCFramework/GoldRPCFramework.h>
#import "NewsCommentBaseViewModel.h"

@interface NewsCommentPostResponse : GoldBaseReponse

/**
 用户发送评论后返回的一条完整的评论，用于添加到评论列表中
 */
@property (nonatomic, strong) NewsCommentBaseViewModel *commentModel;

@end
