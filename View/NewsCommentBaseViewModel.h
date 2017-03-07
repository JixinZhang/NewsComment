//
//  NewsCommentBaseViewModel.h
//  MNewsCommentFramework
//
//  Created by ZhangBob on 11/10/2016.
//  Copyright © 2016 Micker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsCommentModel.h"

@interface NewsCommentBaseViewModel : NSObject

@property (nonatomic, strong) NewsCommentModel *data;

@property (nonatomic, assign) CGFloat shrinkCellHeight;
@property (nonatomic, assign) CGFloat expandCellHeight;

@property (nonatomic, assign) CGFloat shrinkContentHeight;
@property (nonatomic, assign) CGFloat expandContentHeight;

@property (nonatomic, assign) BOOL expandable;
@property (nonatomic, assign) BOOL expanded;

//optional
@property (nonatomic, assign) BOOL isLocal;//评论后手动加入的，不是从评论列表中获取
@property (nonatomic, strong) NSAttributedString* attributedContent;
@property (nonatomic, strong) NSDictionary* attributedContentArguments;
@property (nonatomic, strong) NSString* content;
@property (nonatomic, strong) NSString* dateText;
@property (nonatomic, assign) CGSize variableSize;
@property (nonatomic, strong) NSAttributedString* attributedTitle;

- (id)initWithContent:(id)content;

- (CGFloat) cellHeight;
- (CGFloat) contentHeight;

- (void)descriptionFromCommentModel:(NewsCommentModel *)commentModel
                          cellWidth:(CGFloat)cellWidth;
+ (NSAttributedString *)attributedContentWithCommentModel:(NewsCommentModel *)commentModel;

@end
