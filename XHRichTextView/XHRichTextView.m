//
//  XHView.m
//  CoreText&AttributedString
//
//  Created by duxuanhui on 15/7/13.
//  Copyright (c) 2015年 duxuanhui. All rights reserved.
//


#import "XHRichTextView.h"
#import <CoreText/CoreText.h>
#define CFRangeZero CFRangeMake(0, 0)
#define CallBlock(block,obj) if(block) block(obj)

NSString *const XHImageAttributeName = @"XHImageAttributeName";
NSString *const XHTextResponderAttributeName = @"XHTextResponderAttributeName";

typedef enum
{
    XHResponderTypeText,
    XHResponderTypeImage
}XHResponderType;
@interface XHResponderInfo : NSObject
@property(nonatomic,copy)NSString *name;
@property(nonatomic,assign)CGRect rect;
@property(nonatomic,assign)CGRect drawRect;
@property(nonatomic,assign) XHResponderType type;


-(instancetype)initWithName:(NSString *)name rect:(CGRect)rect type:(XHResponderType)type;
@end
@implementation XHResponderInfo
-(instancetype)initWithName:(NSString *)name rect:(CGRect)rect type:(XHResponderType)type
{
    if (self=[super init])
    {
        self.name = name;
        self.rect = rect;
        self.type = type;
    }
    return self;
}
@end


#pragma mark - 回调函数
CGFloat getWidth(void * refCon)
{
    NSString *imageName =(__bridge NSString *)refCon;
    UIImage * image = [UIImage imageNamed:imageName];
    return image.size.width;
}
CGFloat getDescent(void* refCon)
{
    return 0;
}
CGFloat getAscent(void *refCon)
{

    NSString *imageName =(__bridge NSString *)refCon;
    UIImage * image = [UIImage imageNamed:imageName];
    return image.size.height;
    
}

@interface XHRichTextView ()
@property(nonatomic,strong)NSAttributedString *attributedText;
@property(nonatomic,strong)NSMutableArray *responderRanges;
@property(nonatomic,strong)NSMutableDictionary *insertImages;
@property(nonatomic,strong)NSMutableArray *responders;
@property(nonatomic,strong)XHResponderInfo *currentResponder;
@property(nonatomic,assign,getter=isHighlight)BOOL highlight;
@end
@implementation XHRichTextView
#pragma mark - 懒加载


-(NSMutableArray *)responderRanges
{
    if (!_responderRanges)
    {
        self.responderRanges = [NSMutableArray array];
    }
    return _responderRanges;
}
-(NSAttributedString *)attributedText
{
    if (!_attributedText)
    {
        _attributedText = [self prepareAttributedText];
    }
    return _attributedText;
}

-(NSMutableDictionary *)insertImages
{
    if (!_insertImages)
    {
        _insertImages = [NSMutableDictionary dictionary];
    }
    return _insertImages;
}

-(NSMutableArray *)responders
{
    if (!_responders)
    {
        _responders = [NSMutableArray array];
    }
    return _responders;
}
#pragma mark - 绘制方法
-(void)drawRect:(CGRect)rect {
    

    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(contextRef, 0, rect.size.height);
    CGContextScaleCTM(contextRef, 1,-1);
    CGContextSetTextMatrix(contextRef, CGAffineTransformIdentity);
    
    if (self.isHighlight)
    {
        [self.highlightColor set];
        if (self.currentResponder)
        {
            CGContextFillRect(contextRef, self.currentResponder.drawRect);
        }else
        {
            CGContextFillRect(contextRef, rect);
        }
//        return;
    }
    
    
    CTFramesetterRef framesetterRef =CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self.attributedText);
    
    CGPathRef path =CGPathCreateWithRect(rect, &CGAffineTransformIdentity);

    CFRange textRange = CFRangeMake(0, self.attributedText.length);
    
    CTFrameRef frame =  CTFramesetterCreateFrame(framesetterRef, textRange, path, NULL);
    CTFrameDraw(frame, contextRef);
    
#pragma mark 计算响应Textrect imageRect 绘制image;
    
    
    CFArrayRef lineArray = CTFrameGetLines(frame);
    CGPoint lineOrigins[CFArrayGetCount(lineArray)];
    
    //此处获取的事本行开头的坐标点;
    CTFrameGetLineOrigins(frame, CFRangeZero, lineOrigins);
    
    for(int lineIndex = 0;lineIndex < CFArrayGetCount(lineArray);lineIndex ++ )
    {
        CTLineRef lineRef = CFArrayGetValueAtIndex(lineArray, lineIndex);

        CFArrayRef runArray = CTLineGetGlyphRuns(lineRef);

        for (int runIndex = 0;runIndex < CFArrayGetCount(runArray); runIndex ++)
        {
            CTRunRef run = CFArrayGetValueAtIndex(runArray, runIndex);
            NSDictionary * attributes =(NSDictionary*) CTRunGetAttributes(run);
            if (attributes[XHTextResponderAttributeName]||attributes[XHImageAttributeName])
            {
//                CGFloat lineAscent;
//                CGFloat lineDescent;
//                CGFloat lineLeading;
//                CTLineGetTypographicBounds(lineRef, &lineAscent, &lineDescent, &lineLeading);
                CGFloat runAscent;
                CGFloat runDescent;
//                CGFloat runLeading;
                
                CGPoint lineHeadPoint = lineOrigins[lineIndex];
                

                //此处获取的是相对于lineHeadPoint的x坐标的偏移量
                CGFloat runOffsetX = CTLineGetOffsetForStringIndex(lineRef, CTRunGetStringRange(run).location, NULL);
                
                CGFloat runWidth = CTRunGetTypographicBounds(run, CFRangeZero, &runAscent, &runDescent, NULL);
                
                CGFloat runHeight = runDescent + runAscent;
                
                //此时runOffsetX就是该run的x坐标
                CGRect runRect = CGRectMake(runOffsetX,lineHeadPoint.y-runDescent, runWidth, runHeight);
                
                CGRect responderRect = CGRectMake(runRect.origin.x, self.frame.size.height - runRect.origin.y -runRect.size.height , runRect.size.width, runRect.size.height);
//                responderRect = [self convertRect:responderRect toView:self];
                
                //run的类型为TextResponder
                if(attributes[XHTextResponderAttributeName])
                {
//                    NSString * responderText = attributes[XHTextResponderAttributeName];
                    CFRange cfRange = CTRunGetStringRange(run);
                    
                    NSString *responderText = [self.attributedText.string substringWithRange:NSMakeRange(cfRange.location, cfRange.length)];
                    
                    XHResponderInfo *responderInfo = [[XHResponderInfo alloc]initWithName:responderText rect:responderRect type:XHResponderTypeText];
                    responderInfo.drawRect = runRect;
                    [self.responders addObject:responderInfo];
                }
                //run的类型为Image
                if (attributes[XHImageAttributeName])
                {
                    
                    NSString *imageName = attributes[XHImageAttributeName];
                    
                    XHResponderInfo *responderInfo = [[XHResponderInfo alloc]initWithName:imageName rect:responderRect type:XHResponderTypeImage];
                    responderInfo.drawRect = runRect;
                    [self.responders addObject:responderInfo];
                    
                    UIImage *image = [UIImage imageNamed:imageName];
                    CGContextDrawImage(contextRef, runRect, image.CGImage);
                }
                
            }
        }
        
    }
    CFRelease(path);
    CFRelease(frame);
    CFRelease(framesetterRef);
}

#pragma mark - 初始化
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self =[super initWithFrame:frame])
    {
        [self textAttributedInit];
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self textAttributedInit];
    }
    return self;
}

-(void)textAttributedInit
{
    self.textColor = [UIColor blackColor];
    self.textFont = [UIFont systemFontOfSize:20];
    self.responderColor = [UIColor blueColor];
    self.highlightColor = [UIColor grayColor];
    self.backgroundColor = [UIColor clearColor];
}

#pragma  mark - 实现公开方法

#pragma mark 重写setTextFont方法

-(void)setTextFont:(UIFont *)textFont
{
    _textFont = textFont;
    self.responderFont = textFont;
}

#pragma mark 添加文本响应字符串的range

-(void)addTextResponderRange:(NSRange)range
{
    NSValue *rangeValue = [NSValue valueWithRange:range];
    [self.responderRanges addObject:rangeValue];
}

-(void)addTextResponderRanges:(NSArray *)ranges
{
    [self.responderRanges addObjectsFromArray:ranges];
}

#pragma mark 添加文本响应字符串
-(void)addTextResponderWithString:(NSString *)string
{
    NSAssert(self.text, @"你必须先要设置text属性的值");
    NSRange range = [self.text rangeOfString:string];
    if (range.length)
    {
        [self addTextResponderRange:range];
    }
}

-(void)addTextResponderWithStrings:(NSArray *)strings
{
    for (NSString * string in strings)
    {
        [self addTextResponderWithString:string];
    }
}

#pragma mark 设置插入图片位置
-(void)insertImageAtIndex:(NSUInteger)index withImageName:(NSString *)imageName
{
    self.insertImages[imageName] = @(index);
}

#pragma 设置正则和回调
-(void)addRegularString:(NSString *)replaceRegular WithCallBack:(RegularCallBack)callBack
{
    self.replaceRegular = replaceRegular;
    self.regularCallBack = callBack;
}

#pragma mark - 图片占位
/**
 *  这个函数通过imageName将根据图片名称来返回一个占位符(空格符),通过CTRunDelegate的回调,来给将要显示的图片进行站位
 *
 */
-(NSAttributedString *)insertImageWithImageName:(NSString *)imageName
{
    CTRunDelegateCallbacks callBacks;
    callBacks.getWidth = getWidth;
    callBacks.getAscent = getAscent;
    callBacks.getDescent = getDescent;
    callBacks.version = kCTRunDelegateVersion1;
    CTRunDelegateRef delegateRef = CTRunDelegateCreate(&callBacks, (__bridge void *)(imageName));
    NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)(delegateRef),(NSString*)kCTRunDelegateAttributeName,imageName,XHImageAttributeName, nil];
    
    
    NSAttributedString *imageHolder = [[NSAttributedString alloc]initWithString:@" "attributes:attributeDict];
    
    CFRelease(delegateRef);
    return imageHolder;
}

#pragma mark - 准备AttributedText
-(NSAttributedString *)prepareAttributedText
{

#pragma  mark  设置Text属性
    NSMutableAttributedString * attributedText = [[NSMutableAttributedString alloc]initWithString:self.text];
    
    NSRange textRange = NSMakeRange(0, self.text.length);
    [attributedText addAttribute:NSFontAttributeName value:self.textFont range:textRange];
    [attributedText addAttribute:NSForegroundColorAttributeName value:self.textColor range:textRange];
    
#pragma  mark  设置响应文本的属性
    
    if (self.responderRanges.count)
    {
        for (NSValue *rangeValue in self.responderRanges)
        {
            NSRange range = [rangeValue rangeValue];
            [self addTextAttributed:attributedText withRange:range];
        }
    }
#pragma mark 设置图片属性

    if (self.insertImages.count)
    {
        NSArray * imageNames = [self.insertImages allKeys];
        for (NSString *imageName in imageNames)
        {
            NSUInteger index = [self.insertImages[imageName] integerValue];
            [self insertImageHolder:attributedText imageName:imageName atIndex:index];
        }
    }

#pragma mark 根据正则设置属性
    if (self.replaceRegular&&self.regularCallBack)
    {
       
        NSRegularExpression * regularExp = [[NSRegularExpression alloc]initWithPattern:self.replaceRegular options:NSRegularExpressionAllowCommentsAndWhitespace error:NULL];
        [regularExp enumerateMatchesInString:attributedText.string options:0 range:NSMakeRange(0, attributedText.string.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            NSRange range  = result.range;
            NSString * string  = [attributedText.string substringWithRange:range];
            NSString *replaceName = self.regularCallBack(string);
           
#warning 此处有bug
            if (replaceName == nil)
            {
                [self addTextAttributed:attributedText withRange:range];
            }else
            {
                [attributedText replaceCharactersInRange:range withString:@""];
                [self insertImageHolder:attributedText imageName:replaceName atIndex:range.location];
            }
        }];
    }
    return attributedText;
}
#pragma mark 添加文字属性
-(void)addTextAttributed:(NSMutableAttributedString * )attributedText withRange:(NSRange)range
{
    NSString *responderText = [self.text substringWithRange:range];
    [attributedText addAttribute:XHTextResponderAttributeName value:responderText range:range];
    [attributedText addAttribute:NSForegroundColorAttributeName value:self.responderColor range:range];
    [attributedText addAttribute:NSFontAttributeName value:self.responderFont range:range];
}
#pragma mark 添加图片占位
-(void)insertImageHolder:(NSMutableAttributedString *)attributedText imageName:(NSString *)imageName atIndex:(NSUInteger)index
{
    NSAttributedString * imageHolder = [self insertImageWithImageName:imageName];
    [attributedText insertAttributedString:imageHolder atIndex:index];
}

#pragma mark - 点击事件响应
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.textClick&&!self.imageClick) return;
    UITouch *touch =[touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    self.highlight = YES;
    if (self.responders.count)
    {
        for (XHResponderInfo * responderInfo in self.responders)
        {
            if (CGRectContainsPoint(responderInfo.rect, touchPoint))
            {
                self.currentResponder = responderInfo;
                break;
            }
        }
    }
    [self setNeedsDisplay];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.textClick&&!self.imageClick) return;
    if(self.highlight) self.highlight = NO;
    UITouch *touch =[touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    if (CGRectContainsPoint(self.currentResponder.rect, touchPoint))
    {
        if (self.currentResponder.type == XHResponderTypeText)
        {
            CallBlock(self.textClick,self.currentResponder.name);
        }else
        {
            CallBlock(self.imageClick,self.currentResponder.name);
        }
    }
    self.currentResponder = nil;
    [self setNeedsDisplay];
}
@end


