//
//  XHViewController.m
//  XHRichTextViewDemo
//
//  Created by duxuanhui on 15/7/17.
//  Copyright (c) 2015年 duxuanhui. All rights reserved.
//

#import "XHViewController.h"
#import "XHRichTextView.h"
@interface XHViewController ()
@property (weak, nonatomic) IBOutlet XHRichTextView *richView;


@end

@implementation XHViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.richView.text = @"   罗罗诺亚·索隆（Roronoa Zoro）日本漫画《海贼王》中的男二号，草帽海贼团中的战斗员，是悬赏过亿武艺高强的三刀流剑士，超新星11人之一，能够自由操纵三把刀战斗。爱喝酒，爱睡觉，讲义气，海贼第一超级大路痴。为了小时候与挚友的约定而踏上了前往世界第一剑士的道路，随后成为主角蒙奇·D·路飞的第一个伙伴。在初次败给世界第一剑士“鹰眼米霍克”后向路飞发誓永不再败，并且更加努力的锻炼自己。两年后的他成功与伙伴们汇合，并且为了实现自己的梦想，奔赴强者如云的新世界。";
    [self.richView insertImageAtIndex:50 withImageName:@"test"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
