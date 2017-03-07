//
//  NewsCommentViewController.h
//  MNewsCommentFramework
//
//  Created by ZhangBob on 10/10/2016.
//  Copyright © 2016 Micker. All rights reserved.
//

#import <GoldBaseFramework/GoldBaseFramework.h>

@interface NewsCommentViewController : BaseViewController

@property (nonatomic, strong) UITableView *commentTableView;
@property (nonatomic, strong) NSMutableArray *hotComments;
@property (nonatomic, strong) NSMutableArray *normalComments;
@property (nonatomic, strong) NSMutableArray *allComments;

- (instancetype)initWitNewsId:(NSString *)newsId;

@end
