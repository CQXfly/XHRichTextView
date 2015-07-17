//
//  CommentData.h
//  XHRichTextViewDemo
//
//  Created by duxuanhui on 15/7/17.
//  Copyright (c) 2015年 duxuanhui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XHBaseReportData.h"
@interface XHCommentData :XHBaseReportData
@property(nonatomic,copy)NSString * sender;
@property(nonatomic,copy)NSString * receiver;
@property(nonatomic,copy)NSString * emjoyReplace;

@end
