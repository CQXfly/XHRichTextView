//
//  XHTableViewCell.m
//  XHRichTextViewDemo
//
//  Created by duxuanhui on 15/7/17.
//  Copyright (c) 2015年 duxuanhui. All rights reserved.
//

#import "XHReportCell.h"
#import "XHRichTextView.h"
@interface XHReportCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *sender;
@property(nonatomic,weak)XHRichTextView* richTextView;
@end
@implementation XHReportCell
-(void)setReport:(XHReportData *)report
{
    self.iconView.image = [UIImage imageNamed:report.icon];
    self.sender.text = report.name;
    _report = report;
    CGRect iconFrame  = self.iconView.frame;
    CGFloat richY = CGRectGetMaxY(iconFrame) + 10;
    CGFloat richX = iconFrame.origin.x + 20;
    CGRect frame =CGRectMake(richX, richY, report.contentRect.size.width, report.contentRect.size.height);
    XHRichTextView * richText = [[XHRichTextView alloc]init];
    richText.frame =frame;
    richText.frame =frame;
    richText.text = report.content;
    if (report.responders)
    {
       [richText addTextResponderWithStrings:report.responders];
    }
    richText.textClick = ^(NSString *name)
    {
        NSLog(@"%@",name);
    };
    self.richTextView =richText;
    [self.richTextView addRegularString:report.responderRegular WithCallBack:^NSString *(NSString * name) {
        return nil;
    }];
//    [self.richTextView insertImageAtIndex:10 withImageName:@"test"];
    [self addSubview:richText];
}
+(instancetype)reportCell:(UITableView *)tableView
{
    static NSString * ID=@"report";
    XHReportCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XHReportCell" owner:nil options:nil] lastObject];
    }
    return cell;
}
@end
