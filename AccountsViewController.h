//
//  AccountsViewController.h
//  SimpleBitcoinChecker
//
//  Created by Stephen on 2014-08-27.
//  Copyright (c) 2014 Stephen Ceresia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FUIButton.h"
#import "FUIAlertView.h"

@interface AccountsViewController : UIViewController <UITextFieldDelegate, FUIAlertViewDelegate>
{
    NSString *savedAddress;
}

//@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
//
//@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
//
//@property (weak, nonatomic) IBOutlet UILabel *convertedLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *btcBalance;
@property (weak, nonatomic) IBOutlet FUIButton *setAddressButton;

- (IBAction)setAddressButtonTapped:(id)sender;

@end
