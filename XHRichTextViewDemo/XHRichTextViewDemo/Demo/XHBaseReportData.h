//
//  XHBaseReportData.h
//  XHRichTextViewDemo
//
//  Created by duxuanhui on 15/7/17.
//  Copyright (c) 2015年 duxuanhui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface XHBaseReportData : NSObject
@property(nonatomic,copy)NSString * content;
@property(nonatomic,assign)CGRect contentRect;
@property(nonatomic,assign)CGFloat rowHeight;
@end
