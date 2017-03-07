//
//  NewsCommentListResponse.h
//  MNewsCommentFramework
//
//  Created by ZhangBob on 12/10/2016.
//  Copyright © 2016 Micker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsCommentThreadModel.h"

@interface NewsCommentListResponse : GoldBaseReponse

@property (nonatomic, copy) NSString *threadId;
@property (nonatomic, strong) NSMutableArray *comments;
@property (nonatomic, strong) NewsCommentThreadModel *threadModel;

@end
