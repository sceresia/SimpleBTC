//
//  SaveDataHelper.h
//  BTCRate
//
//  Created by Stephen on 12/12/2013.
//  Copyright (c) 2013 Stephen Ceresia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SaveDataHelper : NSObject

+ (NSString *) loadCurrencySetting;
+ (void) saveCurrencySetting:(NSString *) currency;

+ (NSString *) loadSavedAddress;
+ (void) saveAddress:(NSString *) address;

@end


