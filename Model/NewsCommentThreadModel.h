//
//  NewsCommentThreadModel.h
//  MNewsCommentFramework
//
//  Created by ZhangBob on 14/10/2016.
//  Copyright © 2016 Micker. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsCommentThreadModel : NSObject

@property (nonatomic, copy) NSString *threadId;
@property (nonatomic, copy) NSString *permalink;
@property (nonatomic, copy) NSString *newsTitle;
@property (nonatomic, copy) NSString *numComments;
@property (nonatomic, copy) NSString *lastCommentAt;
@property (nonatomic, copy) NSString *channel;
@property (nonatomic, copy) NSString *commentStatus;

- (id)initWithContent:(id)content;

@end
