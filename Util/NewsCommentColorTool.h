//
//  NewsCommentColorTool.h
//  MNewsCommentFramework
//
//  Created by ZhangBob on 11/10/2016.
//  Copyright © 2016 Micker. All rights reserved.
//

#ifndef NewsCommentColorTool_h
#define NewsCommentColorTool_h

//十六进制色值
#define kUIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define kUIColorFromRGBWithTransparent(rgbValue,transparentValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:transparentValue]

//RGB色值
#define kColourWithRGB(r,g,b) [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:1.0]

#endif /* NewsCommentColorTool_h */
