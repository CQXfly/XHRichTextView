//
//  XHView.h
//  CoreText&AttributedString
//
//  Created by duxuanhui on 15/7/13.
//  Copyright (c) 2015年 duxuanhui. All rights reserved.
//

#import <UIKit/UIKit.h>
//typedef enum
//{
//    XHImageDisplayModeTop,
//    XHImageDisplayModeMiddle,
//    XHImageDisplayModeBottom,
//}XHImageDisplayMode;
typedef void(^TextClick)(NSString *);
typedef void(^ImageClick)(NSString *);
typedef NSString *(^RegularCallBack)(NSString *);

@interface XHRichTextView : UIView

@property(nonatomic,copy)TextClick textClick;
@property(nonatomic,copy)ImageClick imageClick;
@property(nonatomic,copy)RegularCallBack regularCallBack;

//@property(nonatomic,assign)XHImageDisplayMode imageMode;
@property(nonatomic,strong)NSString *text;
@property(nonatomic,strong)UIColor *textColor;
@property(nonatomic,strong)UIColor *responderColor;
@property(nonatomic,strong)UIColor *highlightColor;
@property(nonatomic,strong)UIColor *highlightTextColor;
@property(nonatomic,strong)UIFont *textFont;
@property(nonatomic,strong)UIFont *responderFont;
@property(nonatomic,copy)NSString * replaceRegular;

-(void)insertImageAtIndex:(NSUInteger)index withImageName:(NSString*)imageName;
-(void)addTextResponderRange:(NSRange)range;
-(void)addTextResponderRanges:(NSArray *)ranges;
-(void)addTextResponderWithString:(NSString *)string;
-(void)addTextResponderWithStrings:(NSArray *)strings;
/**
 *  设置正则和正则匹配后的回调函数
 *
 *  @param replaceRegular 正则字符串
 *  @param callBack       回调函数,该函数需要返回一个你是string
 */
-(void)addRegularString:(NSString *)replaceRegular WithCallBack:(RegularCallBack)callBack;
@end
