//
//  NewsCommentMenuView.h
//  MNewsCommentFramework
//
//  Created by ZhangBob on 12/10/2016.
//  Copyright © 2016 Micker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsCommentModel.h"

@interface NewsCommentMenuView : UIView

@property (nonatomic, strong) UIButton *replyButton;
@property (nonatomic, strong) UIButton *contentCopyButton;
@property (nonatomic, strong) UIButton *reportButton;
@property (nonatomic, strong) NewsCommentModel *commentModel;

- (void)showPanelView;
- (void)hidePanelView;

@end
