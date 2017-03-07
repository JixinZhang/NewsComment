//
//  NewsCommentTextView.h
//  MNewsCommentFramework
//
//  Created by ZhangBob on 13/10/2016.
//  Copyright © 2016 Micker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ANPlaceholderTextView.h"
#import "NewsCommentBaseViewModel.h"

typedef void (^NewsCommentTextViewBlock)(BOOL ,NewsCommentBaseViewModel *);

@interface NewsCommentTextView : UIView

@property (nonatomic, strong) UIView *panelView;    //回复评论面板
@property (nonatomic, strong) UIView *maskView;     //遮罩
@property (nonatomic, strong) UIButton *sendButton; //发送按钮
@property (nonatomic, strong) ANPlaceholderTextView *contentTextView;  //输入框
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, copy) NSString *threadId;
@property (nonatomic, copy) NSString *parentId;
@property (nonatomic, copy) NewsCommentTextViewBlock commentTextViewBlock;

- (void)newsCommentTextBeginEditing;
- (void)newsCommentTextEndEditing;

@end
