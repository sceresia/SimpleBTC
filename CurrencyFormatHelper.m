//
//  CurrencyFormatHelper.m
//  BTCRate
//
//  Created by Stephen on 2014-03-16.
//  Copyright (c) 2014 Stephen Ceresia. All rights reserved.
//

#import "CurrencyFormatHelper.h"

@implementation CurrencyFormatHelper

+ (NSString *) getFormattedCurrencyString:(NSString *) str
{
    float f = [str floatValue];
    return [NSString stringWithFormat:@"%.2f", f];
}


@end
