//
//  ReportData.h
//  XHRichTextViewDemo
//
//  Created by duxuanhui on 15/7/17.
//  Copyright (c) 2015年 duxuanhui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XHBaseReportData.h"
@interface XHReportData : XHBaseReportData
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *icon;
@property(nonatomic,strong)NSArray *responders;
@property(nonatomic,copy)NSString * responderRegular;



@end
