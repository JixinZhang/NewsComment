//
//  NewsCommentBaseViewModel.m
//  MNewsCommentFramework
//
//  Created by ZhangBob on 11/10/2016.
//  Copyright © 2016 Micker. All rights reserved.
//

#import "NewsCommentBaseViewModel.h"

#define kContentFontSize 16.f
#define kMaxShrinkContentHeight 70.f
#define kDifferenceCellByExpandableContent 102.f
#define kDifferenceCellByUnexpandableContent 72.f

@implementation NewsCommentBaseViewModel

- (id)initWithContent:(id)content {
    self = [super init];
    if (self) {
        NewsCommentModel *commentModel = [NewsCommentModel yy_modelWithJSON:content];
        [self appendContent:commentModel];
    }
    return self;
}

- (void)appendContent:(id)content {
    NewsCommentModel *commentModel = content;
    if (commentModel.commentId.length > 0) {
        if (commentModel.parent != nil && [commentModel isParentCommentDeleted]) {
            commentModel.parent.comment_content = [NewsCommentModel parentDeleteDescription];
        }
        NSString *comment_content = [commentModel.comment_content stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        commentModel.comment_content = comment_content;
        
        [self descriptionFromCommentModel:commentModel cellWidth:KScreenWidth];
    }
}

- (CGFloat)cellHeight {
    return self.expanded ? self.expandCellHeight : self.shrinkCellHeight;
}

- (CGFloat)contentHeight {
    return self.expanded ? self.expandContentHeight : self.shrinkContentHeight;
}

+ (NSAttributedString *)attributedContentWithCommentModel:(NewsCommentModel *)commentModel {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:3];//调整行间距
    
    NSMutableAttributedString* attributedContent = [[NSMutableAttributedString alloc] initWithString:commentModel.comment_content attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:kContentFontSize], NSForegroundColorAttributeName : [UIColor getColor:@"333333"],NSParagraphStyleAttributeName : paragraphStyle}];;
    if (commentModel.parent != nil ){
        //0x688fdb
        
        NSAttributedString* replyString = [[NSAttributedString alloc] initWithString:@" // " attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:kContentFontSize], NSForegroundColorAttributeName : [UIColor getColor:@"688fdb"], NSParagraphStyleAttributeName : paragraphStyle}];
        [attributedContent appendAttributedString:replyString];
        
        NSAttributedString* repliedCommentContent = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@: %@", commentModel.parent.user.userName, commentModel.parent.comment_content] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:kContentFontSize], NSForegroundColorAttributeName :  [UIColor getColor:@"666666"], NSParagraphStyleAttributeName : paragraphStyle}];
        [attributedContent appendAttributedString:repliedCommentContent];
        
        
    }
    return attributedContent;
}

- (void)descriptionFromCommentModel:(NewsCommentModel *)commentModel
                                                cellWidth:(CGFloat)cellWidth {
    self.data = commentModel;
    
    self.attributedContent = [[self class] attributedContentWithCommentModel:commentModel];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ",commentModel.user.userName]];
    self.attributedTitle = string;
    
    CGRect contentFrame = [self.attributedContent boundingRectWithSize:CGSizeMake((cellWidth - 75), INT16_MAX)
                                                                      options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine
                                                                      context:nil];
    if (kMaxShrinkContentHeight < contentFrame.size.height){
        self.expandable = YES;
        self.expanded = NO;
        
        self.expandContentHeight = contentFrame.size.height + 1.f;
        self.shrinkContentHeight = kMaxShrinkContentHeight;
        
        self.expandCellHeight = self.expandContentHeight + kDifferenceCellByExpandableContent + 5;
        self.shrinkCellHeight = self.shrinkContentHeight + kDifferenceCellByExpandableContent + 5;
    }
    else{
        self.expandable = NO;
        self.expanded = NO;
        
        self.expandContentHeight = contentFrame.size.height + 1.f;
        self.shrinkContentHeight = contentFrame.size.height + 1.f;
        
        self.expandCellHeight = self.expandContentHeight + kDifferenceCellByUnexpandableContent + 12;
        self.shrinkCellHeight = self.shrinkContentHeight + kDifferenceCellByUnexpandableContent + 12;
    }
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[commentModel.createdAt doubleValue]];
    self.dateText = [date relativeDateStringWithFormat:@"yyyy-MM-dd HH:mm"];
    
}

@end
