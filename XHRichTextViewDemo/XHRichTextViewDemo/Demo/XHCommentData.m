//
//  CommentData.m
//  XHRichTextViewDemo
//
//  Created by duxuanhui on 15/7/17.
//  Copyright (c) 2015年 duxuanhui. All rights reserved.
//

#import "XHCommentData.h"

@implementation XHCommentData
-(CGRect)contentRect
{
    self.contentRect = [self.content boundingRectWithSize:CGSizeMake(RichWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes: nil context:nil];
    return [super contentRect];
}
@end
