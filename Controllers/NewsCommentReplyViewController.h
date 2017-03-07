//
//  NewsCommentReplyViewController.h
//  MNewsCommentFramework
//
//  Created by WSCN on 07/11/2016.
//  Copyright © 2016 Micker. All rights reserved.
//

#import <GoldBaseFramework/GoldBaseFramework.h>
#import "NewsCommentModel.h"
#import "NewsCommentBaseViewModel.h"

typedef void (^NewsCommentReplyVCBlock)(BOOL ,NewsCommentBaseViewModel *);

@interface NewsCommentReplyViewController : BaseViewController

@property (nonatomic, copy) NSString *threadId;
@property (nonatomic, copy) NSString *newsId;
@property (nonatomic, strong) NewsCommentModel *commentModel;
@property (nonatomic, copy) NewsCommentReplyVCBlock commentReplyVCBlock;

- (void)setReplyVCPlaceholderWithString:(NSString *)placeholder;

@end
