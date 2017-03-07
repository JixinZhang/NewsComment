//
//  NewsCommentStoreVoteModel.h
//  MNewsCommentFramework
//
//  Created by ZhangBob on 18/10/2016.
//  Copyright © 2016 Micker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoldDataFramework/GoldDataFramework.h>

@interface NewsCommentVoteUpModel : NSObject <GoldDataBaseProtocol>

@property (nonatomic, copy) NSString *commentIdUserId;
@property (nonatomic, copy) NSString *type;

@end

@interface NewsCommentVoteDownModel : NSObject <GoldDataBaseProtocol>

@property (nonatomic, copy) NSString *commentIdUserId;
@property (nonatomic, copy) NSString *type;

@end
