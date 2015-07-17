//
//  ViewController.m
//  XHRichTextViewDemo
//
//  Created by duxuanhui on 15/7/17.
//  Copyright (c) 2015年 duxuanhui. All rights reserved.
//

#import "ViewController.h"
#import "XHReportCell.h"
@interface ViewController ()
@property(nonatomic,strong)NSArray *reports;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSMutableArray *reportSuolong = [NSMutableArray array];

    XHReportData *report1 =[[XHReportData alloc]init];
    report1.content = @"我要成为世界第一大剑豪!!!@路飞 @娜美 @鲁索普 @山治 @罗宾 @乔巴 @弗兰奇 @布鲁克 @鹰眼";
    report1.name = @"索隆";
    report1.icon = @"suolong";
    report1.responders = @[@"@路飞"];
    
    [reportSuolong addObject:report1];
    
    NSMutableArray * reports = [NSMutableArray array];
    [reports addObjectsFromArray: @[reportSuolong]];
    self.reports =reports;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.reports.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.reports[section] count];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray * report = self.reports [indexPath.section];
    XHBaseReportData * data = report[indexPath.row];
    return data.rowHeight;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XHReportCell * cell = [XHReportCell reportCell:tableView];
    cell.report = self.reports[indexPath.section][indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"push" sender:nil];
}
@end
