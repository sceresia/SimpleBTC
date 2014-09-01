//
//  UIColorFromHex.m
//  SimpleBitcoin
//
//  Created by Stephen on 2014-03-16.
//  Copyright (c) 2014 Stephen Ceresia. All rights reserved.
//

#import "UIColorFromHex.h"

@implementation UIColorFromHex

// Assumes input like "#00FF00" (#RRGGBB).
+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

@end
