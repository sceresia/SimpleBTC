//
//  SaveDataHelper.m
//  BTCRate
//
//  Created by Stephen on 12/12/2013.
//  Copyright (c) 2013 Stephen Ceresia. All rights reserved.
//

#import "SaveDataHelper.h"

@implementation SaveDataHelper

+ (NSString *) loadCurrencySetting
{
    
    NSString *savedCurrency = [[NSUserDefaults standardUserDefaults] stringForKey:@"SavedCurrencyType"];
    
    if (savedCurrency != nil)
    {
        return savedCurrency;
    }
    else
    {
        return @"USD";
    }
}

+ (void) saveCurrencySetting:(NSString *) currency
{
    [[NSUserDefaults standardUserDefaults] setObject:currency forKey:@"SavedCurrencyType"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *) loadSavedAddress
{
    NSString *savedAddress = [[NSUserDefaults standardUserDefaults] stringForKey:@"SavedAddress"];
    
    if (savedAddress != nil)
    {
        return savedAddress;
    }
    else
    {
        return nil;
    }
}

+ (void) saveAddress:(NSString *) address
{
    [[NSUserDefaults standardUserDefaults] setObject:address forKey:@"SavedAddress"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
