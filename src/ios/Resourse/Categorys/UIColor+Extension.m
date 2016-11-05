//
//  UIColor+Extension.m
//  ZiChanBao
//
//  Created by liujinliang on 15/6/11.
//  Copyright (c) 2015年 WorldUnion. All rights reserved.
//

#import "UIColor+Extension.h"

@implementation UIColor (Extension)

#pragma mark - 计算色值
/**
 *  传入十六进制值，以0x开头
 */
+ (instancetype)hexValue:(NSInteger)hexValue
{
    return [UIColor hexValue:hexValue alpha:1.0];
}

+ (instancetype)hexValue:(NSInteger)hexValue alpha:(CGFloat)alpha {
    return  [UIColor colorWithRed:(((hexValue) & 0xFF0000) >> 16) / 255.0 green:(((hexValue) & 0xFF00) >> 8) / 255.0 blue:(((hexValue) & 0xFF)) / 255.0 alpha:alpha];;
}

/**
 *  传入十进制的红绿蓝三色值
 */
+ (instancetype)red:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue
{
    return [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:1.0];
}

+ (UIColor *)colorWithHexadecimalString:(NSString *)colorValue withColorAlpha:(float)alpha
{
    UIColor *color = [UIColor clearColor];
    if ([[colorValue substringToIndex:1] isEqualToString:@"#"]) {
        if ([colorValue length] == 7) {
            NSRange range = NSMakeRange(1, 2);
            NSString *redString = [colorValue substringWithRange:range];
            range.location = 3;
            NSString *greenString = [colorValue substringWithRange:range];
            range.location = 5;
            NSString *blueString = [colorValue substringWithRange:range];

            float r = [UIColor getIntegerFromString:redString];
            float g = [UIColor getIntegerFromString:greenString];
            float b = [UIColor getIntegerFromString:blueString];

            color = [UIColor colorWithRed:r/255 green:g/255 blue:b/255 alpha:alpha];
        }
    }
    return color;
}

+ (int) getIntegerFromString:(NSString *)str
{
    int nValue = 0;
    for (int i = 0; i < [str length]; i++)
    {
        int nLetterValue = 0;

        if ([str characterAtIndex:i] >='0' && [str characterAtIndex:i] <='9') {
            nLetterValue += ([str characterAtIndex:i] - '0');
        }
        else{
            switch ([str characterAtIndex:i])
            {
                case 'a':case 'A':
                    nLetterValue = 10;break;
                case 'b':case 'B':
                    nLetterValue = 11;break;
                case 'c': case 'C':
                    nLetterValue = 12;break;
                case 'd':case 'D':
                    nLetterValue = 13;break;
                case 'e': case 'E':
                    nLetterValue = 14;break;
                case 'f': case 'F':
                    nLetterValue = 15;break;
                default:nLetterValue = '0';
            }
        }

        nValue = nValue * 16 + nLetterValue; //16进制
    }
    return nValue;
}

#pragma mark - 背景颜色
/**
 *  页面背景色efefef
 */
+ (instancetype)backgroundColor
{
    return [self hexValue:0xefefef];
}

/**
 *  主颜色，红色0x9932CC
 */
+ (instancetype)mainColor
{
    return [self hexValue:0x9932CC];
}

/**
 *  分隔线d4d4d4
 */
+ (instancetype)borderColor
{
    return [self hexValue:0xd4d4d4];
}

#pragma mark - 文字颜色
/**
 *  文字,黑色4c4948
 */
+ (instancetype)fontBlack
{
    return [self hexValue:0x4c4948];
}

/**
 *  文字,灰色8b8b8b
 */
+ (instancetype)fontGray
{
    return [self hexValue:0x8b8b8b];
}

/**
 *  文字,浅灰cccccc
 */
+ (instancetype)fontLightGray
{
    return [self hexValue:0x84899d];
}

/**
 *  文字,链接dc2e24
 价格颜色
 */
+ (instancetype)priceColor
{
    return [self hexValue:0xdc2e24];
}

#pragma mark - 按钮颜色
/**
 *  按钮,普通状态ec2355
 */
+ (instancetype)buttonNormal
{
    return [self hexValue:0xec2355];
}

/**
 *  按钮,高亮状态d41f4c
 */
+ (instancetype)buttonHighlight
{
    return [self hexValue:0xd41f4c];
}

/**
 *  按钮,不可点击cccccc
 */
+ (instancetype)buttonDisable
{
    return [self hexValue:0xcccccc];
}

/**
 *  文本默认内容颜色848a9e
 */
+ (instancetype)placeholderColor{
    return [self hexValue:0x848a9e];
}

/**
 *  按钮shenhuise 343e61
 */
+ (instancetype)btnDarkGrayColor
{
    return [self hexValue:0x343e61];
}

/**
 *  按钮确认红色 da1f28
 */
+ (instancetype)btnSureRedColor{
    return [self hexValue:0xda1f28];
}

/**
 *  圈红色 cc3228
 */
+ (instancetype)circleRedColor{
    return [self hexValue:0xcc3228];
}

/**
 *  圈红色 890300
 */
+ (instancetype)circleDarkRedColor{
    return [self hexValue:0x890300];
}

/**
* 背景灰色
*/
+ (instancetype)backgroundGrayColor{
    return [self hexValue:0xf1f1f2];
}

/**
* app主色调
*/
+ (instancetype)appMainColor{
    return [UIColor hexValue:0x16AAA2];
}

/**
* app主色调
*/
+ (instancetype)appMainColor_orange{
    return [self hexValue:0xF4691D];
}


+ (instancetype)scrollviewTopBb {
    return [self hexValue:0xffffff];
}

+ (instancetype)tableviewBorderColor {
    return [self hexValue:0xffffff];
}

+ (instancetype)uiPageControlIndicatorTintColor {
    return [self darkGrayColor];
}

+ (instancetype)uiPageControlIndicatorCurrentTintColor {
    return [UIColor appMainColor];
}


@end
