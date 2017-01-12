//
//  Header.h
//  WRKit
//
//  Created by jfy on 16/10/25.
//  Copyright © 2016年 jfy. All rights reserved.
//



#ifndef Header_h
#define Header_h

#define WIDTH  [[UIScreen mainScreen] bounds].size.width
#define HEIGHT [[UIScreen mainScreen] bounds].size.height

#define RGBColor(red,green,blue,alpha) [UIColor colorWithRed:red green:green blue:blue alpha:alpha]

#define UDS [NSUserDefaults standardUserDefaults]


#import "NSDate+WRDate.h"
#import "NSObject+WRObject.h"
#import "NSString+WRString.h"
#import "UIColor+WRColor.h"
#import "UIView+WRView.h"
#import "UIImage+WRImage.h"
#import "UIButton+WRButton.h"
#import "UILabel+WRLabel.h"
#import "UIImageView+WRIV.h"
#import "UIViewController+WRVC.h"
#import "UIScrollView+WRScrollView.h"

#undef	AS_SINGLETON
#define AS_SINGLETON( __class ) \
+ (__class *)sharedInstance;

#undef	DEF_SINGLETON
#define DEF_SINGLETON( __CLASS) \
+(__CLASS *)sharedInstance \
{ \
static dispatch_once_t once; \
static __CLASS *__singleton__; \
dispatch_once(&once,^{ __singleton__ = [[self alloc] init]; }); \
return __singleton__;\
}


/**
 *  限制只能输入数字字符
 *
 *  @param __length 字符长度
 *
 *  @return 是否可以输入，布尔值
 */
#undef ALLOW_NO_INPUT
#define ALLOW_NO_INPUT(__length) \
const char * _char = [string cStringUsingEncoding:NSUTF8StringEncoding]; \
int isBackSpace = strcmp(_char, "\b"); \
if (isBackSpace == -8) return YES;\
if ([string isPureNumber]) {\
if (textField.text.length >= __length) { \
return NO; \
} else { \
return YES;\
} \
}

/**
 *  限制输入字符的长度，不包含中文
 *
 *  @param __length 可以输入的字符长度
 *
 *  @return 是否可以输入，布尔值
 */
#undef ALLOW_CHAR_INPUT
#define ALLOW_CHAR_INPUT(__length) \
if (textField.text.length <= __length) { \
return YES; \
}


/*当输入模式为中文输入法时，每次都要先选择字符，然后点击键盘才可触发UITextField的响应输入事件，所以如果一直点击推荐的字的话就一直可以输入，无法控制场面。可以用下面的方法限制中文输入长度就稍微麻烦点
 */
//第一步：注册监听
#undef ADD_OBSERVER_FOR_TEXTFIELD
#define ADD_OBSERVER_FOR_TEXTFIELD(__tf) \
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldEditChanged:) \
name:@"UITextFieldTextDidChangeNotification" \
object:__tf]

//第二步，实现监听方法
#undef ALLOW_CHINESE_INPUT
#define ALLOW_CHINESE_INPUT(__tf,__len) \
if (__tf == textField) { \
NSString *toBeString = textField.text; \
NSString *lang = textField.textInputMode.primaryLanguage; \
if([lang isEqualToString:@"zh-Hans"]) { \
UITextRange *selectedRange = [textField markedTextRange];/*获取高亮部分*/ \
UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0]; \
if(!position) { /*没有高亮选择的字，则对已输入的文字进行字数统计和限制*/\
if(toBeString.length > __len) { \
textField.text = [toBeString substringToIndex:__len]; \
} \
} \
} \
else{ /*中文输入法以外的直接对其统计限制即可，不考虑其他语种情况*/\
if(toBeString.length > __len) { \
textField.text= [toBeString substringToIndex:__len]; \
} \
}\
}

//第三步：取消监听
#undef REMOVE_OBSERVER_FOR_TEXTFIELD
#define REMOVE_OBSERVER_FOR_TEXTFIELD(__tf) \
[[NSNotificationCenter defaultCenter] removeObserver:self \
name:@"UITextFieldTextDidChangeNotification" \
object:__tf];

#define WRDebug(__msg) NSLog(@"\n__________________\n__________________\nDebugAt :line%d\nfunction:%s\ncontent :%@\n__________________\n__________________",__LINE__,__FUNCTION__,__msg)

#endif /* Header_h */
