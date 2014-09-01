//
//  AccountsViewController.m
//  SimpleBitcoinChecker
//
//  Created by Stephen on 2014-08-27.
//  Copyright (c) 2014 Stephen Ceresia. All rights reserved.
//

#import "AccountsViewController.h"
#import "UIColorFromHex.h"
#import <FlatUIKit/UIColor+FlatUI.h>
#import "UIFont+FlatUI.h"
#import "FUIButton.h"
#import "SaveDataHelper.h"

#define BLOCKCHAIN_URL @"https://blockchain.info/q/addressbalance/"
#define BLOCKCHAIN_URL_CONFIRMATION @"?confirmations=6"
#define TEST_ADDRESS_1 @"1F1tAaz5x1HUXrCNLbtMDqcw6o5GNn4xqX"
#define TEST_ADDRESS_2 @"18Uyi6jtAsUcFgxLmtzFdGmMYVFQZGWike"

#import "Constants.h"

@interface AccountsViewController ()

@end

@implementation AccountsViewController

//@synthesize addressLabel;
@synthesize addressLabel;
@synthesize btcBalance;
@synthesize setAddressButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor wetAsphaltColor];

    //TODO: save/load address
    
    addressLabel.textColor = [UIColor silverColor];
    addressLabel.font = [UIFont flatFontOfSize:14];
    btcBalance.textColor = [UIColor cloudsColor];
    btcBalance.font = [UIFont boldFlatFontOfSize:22];
    
    // FUIButton
    setAddressButton.buttonColor = [UIColor turquoiseColor];
    setAddressButton.shadowColor = [UIColor greenSeaColor];
    setAddressButton.shadowHeight = 3.0f;
    setAddressButton.cornerRadius = 6.0f;
    setAddressButton.titleLabel.font = [UIFont boldFlatFontOfSize:22];
    [setAddressButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [setAddressButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    // FUIButton
    
    savedAddress = [SaveDataHelper loadSavedAddress];
    
    if (savedAddress != nil)
    {
        addressLabel.text = savedAddress;
        [self fetchBalanceForAddress:savedAddress];
    }
    else
    {
        addressLabel.text = @"<Enter an address>";
    }

}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(void) keyboardWillShow:(NSNotification *) note {
    //[self.view addGestureRecognizer:tapRecognizer];
}

-(void) keyboardWillHide:(NSNotification *) note
{
    //[self.view removeGestureRecognizer:tapRecognizer];
}

- (void) fetchBalanceForAddress:(NSString *) address
{
    dispatch_queue_t myQueue = dispatch_queue_create("My Queue",NULL);
    
    dispatch_async(myQueue, ^{
        
        // Fetch the JSON wallet balance data from Blockchain API
        NSError *error = nil;
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", BLOCKCHAIN_URL, address, BLOCKCHAIN_URL_CONFIRMATION]];
        NSString *json = [NSString stringWithContentsOfURL:url
                                                  encoding:NSASCIIStringEncoding
                                                     error:&error];
        
        // check for an error and if the address is valid. if returns an int value, it should be valid
        if(!error) {
            
            // VALID ADDRESS, SAVE IT
            [SaveDataHelper saveAddress:address];
            NSLog(@"JSON: %@", json);
            
            float amount = [json floatValue];
            amount /= 100000000;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
                //addressLabel.text = address;
                btcBalance.text = [NSString stringWithFormat:@"%.04f BTC", amount];
            });
            
        }
        else
        {
            NSLog(@"\nJSON: %@ \n Error: %@", json, error);
            
            // handle error
//            FUIAlertView *message = [[FUIAlertView alloc] initWithTitle:@"Error fetching address info"
//                                                              message:@"We were unable to fetch the balance for this wallet address. Please check the address and try again."
//                                                             delegate:nil
//                                                    cancelButtonTitle:@"Ok"
//                                                    otherButtonTitles:nil];
//            [self configFUIAlertView:message];
//            
//            [message show];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
                //[spinner stopAnimating];
                btcBalance.text = [NSString stringWithFormat:@"This address is not valid."];
                
            });
            
            
        }
        
        
    });
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex > 0)
    {
        UITextField *alertTextField = [alertView textFieldAtIndex:0];
        alertTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter; // not working ????
        NSLog(@"alerttextfiled - %@",alertTextField.text);
        
        // do whatever you want to do with this UITextField.
        //addressLabel = [alertTextField.text floatValue];
        addressLabel.text = alertTextField.text;
        
        //[self updateRateForCurrency];
        
        // TODO:
        // - validate text input. limit to 6 figures and 4 decimal places
        // - display error if input is not ok
        // - keep 2 decimal places minimum
        // - do a new conversion check
        
        [self fetchBalanceForAddress:addressLabel.text];
    }
    
}

// Disables OK if no text entered
//- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
//{
//    UITextField *textField = [alertView textFieldAtIndex:0];
//    if ([textField.text length] == 0)
//    {
//        return NO;
//    }
//    return YES;
//}

//

- (IBAction)setAddressButtonTapped:(id)sender
{
    FUIAlertView *alertView = [[FUIAlertView alloc] initWithTitle:@"Type or paste a Bitcoin wallet address." message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil] ;
    alertView.tag = 2;
    alertView.alertViewStyle = FUIAlertViewStylePlainTextInput;
    alertView.maxHeight = 180;
    
    [[alertView textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNamePhonePad];
    [[alertView textFieldAtIndex:0] setTextColor:[UIColor cloudsColor]];
    [[alertView textFieldAtIndex:0] setFont:[UIFont boldFlatFontOfSize:22]];
    
    [self configFUIAlertView:alertView];
    
    
    // HACK: Delay bringing up the keyboard, otherwise the keyboard hides the alert. Bug in FUIAlert?
    if (!isiPhone5)
    {
        [alertView show];
        [self performSelector:@selector(showAlert:) withObject:alertView afterDelay:0.01];
    }
    else
    {
        [[alertView textFieldAtIndex:0]becomeFirstResponder];
        [alertView show];
    }

}

- (void) showAlert:(FUIAlertView*) alert
{
    [[alert textFieldAtIndex:0]becomeFirstResponder];
}

- (void) configFUIAlertView:(FUIAlertView *) alert
{
    
    alert.titleLabel.textColor = [UIColor cloudsColor];
    alert.titleLabel.font = [UIFont boldFlatFontOfSize:14];
    alert.messageLabel.textColor = [UIColor cloudsColor];
    alert.messageLabel.font = [UIFont flatFontOfSize:14];
    alert.backgroundOverlay.backgroundColor = [[UIColor wetAsphaltColor] colorWithAlphaComponent:0.8];
    alert.alertContainer.backgroundColor = [UIColor midnightBlueColor];
    alert.defaultButtonColor = [UIColor cloudsColor];
    alert.defaultButtonShadowColor = [UIColor asbestosColor];
    alert.defaultButtonFont = [UIFont boldFlatFontOfSize:16];
    alert.defaultButtonTitleColor = [UIColor asbestosColor];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
