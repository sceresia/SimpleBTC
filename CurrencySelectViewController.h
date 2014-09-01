//
//  CurrencySelectViewController.h
//  SimpleBitcoinChecker
//
//  Created by Stephen on 2014-08-27.
//  Copyright (c) 2014 Stephen Ceresia. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CurrencySelectViewController : UITableViewController {
    
    NSArray *currencies;
    
    NSString *lastSavedCurrency;
    
    NSIndexPath *selectedIndex;
    
}

@property (strong, nonatomic) NSArray *currencies;

@property (strong, nonatomic) NSIndexPath *selectedIndex;


@end

