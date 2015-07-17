//
//  ReportData.m
//  XHRichTextViewDemo
//
//  Created by duxuanhui on 15/7/17.
//  Copyright (c) 2015年 duxuanhui. All rights reserved.
//

#import "XHReportData.h"
@implementation XHReportData

-(CGRect)contentRect
{
    CGRect contentRect = [super contentRect];
    contentRect = [self.content boundingRectWithSize:CGSizeMake(RichWidth, CGFLOAT_MAX) options:NSStringDrawingUsesDeviceMetrics attributes: nil context:nil];
    contentRect.size.width =RichWidth;
    if(contentRect.size.height<20) contentRect.size.height =20;
    self.contentRect = contentRect;

    return contentRect;
}
-(CGFloat)rowHeight
{
    CGFloat rowHeight = [super rowHeight];
    rowHeight = self.contentRect.size.height + 80;
    self.rowHeight = rowHeight;
    return rowHeight;
}
@end
