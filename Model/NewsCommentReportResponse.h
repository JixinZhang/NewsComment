//
//  NewsCommentReportResponse.h
//  MNewsCommentFramework
//
//  Created by ZhangBob on 14/10/2016.
//  Copyright © 2016 Micker. All rights reserved.
//

#import <GoldRPCFramework/GoldRPCFramework.h>
#import "NewsCommentModel.h"

@interface NewsCommentReportResponse : GoldBaseReponse

@property (nonatomic, strong) NewsCommentModel *commentModel;

@end
