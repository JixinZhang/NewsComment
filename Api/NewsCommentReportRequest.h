//
//  NewsCommentReportRequest.h
//  MNewsCommentFramework
//
//  Created by ZhangBob on 14/10/2016.
//  Copyright © 2016 Micker. All rights reserved.
//

#import <GoldRPCFramework/GoldRPCFramework.h>

@interface NewsCommentReportRequest : GoldRequest

@property (nonatomic, copy) NSString *commentId;

@end
