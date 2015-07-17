# XHRichTextView
## 这是什么?
- 这是一个富文本显示类,继承自UIVew,核心通过NSAttributedString 和CoreText 来实现,它可以帮助你快速的显示多属性文本,设置文本响应部分,例如文本中超链接,用户名,它还可以在文本指定位置插入图片,将指定文本替换成图片,替换表情字符串.

---
## 属性说明
- `@property(nonatomic,copy)TextClick textClick`  属性文本被点击时的回调,类型:`void(^TextClick)(NSString *)` 
- `@property(nonatomic,copy)ImageClick imageClick` 图片被点击时的回调,类型:`void(^ImageClick)(NSString *)` 
- @property(nonatomic,copy)RegularCallBack regularCallBack 正则回调,类型:`NSString *(^RegularCallBack)(NSString *)`
- //@property(nonatomic,assign)XHImageDisplayMode imageMode 没有实现
- `@property(nonatomic,strong)NSString *text` 要显示的文本
- `@property(nonatomic,strong)UIColor *textColor` 文本的颜色
- `@property(nonatomic,strong)UIColor *responderColor` 响应文本颜色
- `@property(nonatomic,strong)UIColor *highlightColor` 被点击时背景颜色,默认为灰色
- `@property(nonatomic,strong)UIColor *highlightTextColor`响应文本被点击时背景颜色,默认为灰色
- `@property(nonatomic,strong)UIFont *textFont`文本字体
- `@property(nonatomic,strong)UIFont *responderFont`响应文本字体
- `@property(nonatomic,copy)NSString * replaceRegular`替换正则表达式

---
## 具体用法 
`在使用以下方法时,你应当确定你已经设置了该类的text属性`

##### `-(void)insertImageAtIndex:(NSUInteger)index withImageName:(NSString*)imageName`
- 通过这个方法你可以在文本的指定位置插入图片

##### `-(void)addTextResponderRange:(NSRange)range`
##### `-(void)addTextResponderRanges:(NSArray *)ranges`
##### `-(void)addTextResponderWithString:(NSString *)string`
##### `-(void)addTextResponderWithStrings:(NSArray *)strings`

- 你可以通过这四个个方法设置要响应的文字,如果需要点击该段文字时响应,你应当给该类的`textClick`属性赋值 这是一个`void(^TextClick)(NSString *)`Block,当touchUpInside发生时,该block将被回调,被点击文字将被传递
- 默认的响应文字显示为蓝色,你可以通过设置`responderColor`来设置它


##### `-(void)addRegularString:(NSString *)replaceRegular WithCallBack:(RegularCallBack)callBack`
- 这个方法是通过正则表达式来进行替换符合规则的字符串,你需要提供一个字符串的正则表达式,并且设置callBack的Block,这是一个`NSString *(^RegularCallBack)(NSString *)`的block,该类将根据正则对字符串进行遍历,并每次匹配时回调callback,你应该在该block中根据接受的值来返回一个图片名称,如果返回nil,则匹配到得字符串将被设置为响应文本


 **该方法有bug,如果你返回nil 请不要再调用-(void)insertImageAtIndex:(NSUInteger)index withImageName:(NSString*)imageName**

---

## END
#####该类功能尚未完善,存在bug,我会在持续更新,你也可以对该类进行修改和完善,你可以通过邮件来联系我
#####duxuanhui@vip.qq.com;
