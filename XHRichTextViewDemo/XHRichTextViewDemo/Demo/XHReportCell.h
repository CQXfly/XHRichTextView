//
//  XHTableViewCell.h
//  XHRichTextViewDemo
//
//  Created by duxuanhui on 15/7/17.
//  Copyright (c) 2015年 duxuanhui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHReportData.h"
@interface XHReportCell : UITableViewCell
@property(nonatomic,strong)XHReportData* report;

+(instancetype)reportCell:(UITableView*)tableView;
@end
