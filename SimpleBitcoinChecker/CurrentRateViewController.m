//
//  CurrentRateViewController.m
//  SimpleBitcoinChecker
//
//  Created by Stephen on 2014-08-27.
//  Copyright (c) 2014 Stephen Ceresia. All rights reserved.
//

#import "CurrentRateViewController.h"
#import "BTCConvertedRate.h"
#import "SaveDataHelper.h"
#import "UIColorFromHex.h"
#import "CurrencyFormatHelper.h"

#import "FUIButton.h"
#import <FlatUIKit/UIColor+FlatUI.h>
#import "UIFont+FlatUI.h"
#import "FUIAlertView.h"

#import "Constants.h"

#define COINBASE_URL @"https://coinbase.com/api/v1/prices/spot_rate?currency="
//#define BITCOIN_AVERAGE_URL @"https://api.bitcoinaverage.com/ticker/"
#define FETCH_TIME_IN_SECONDS 60

@interface CurrentRateViewController ()

@end


@implementation CurrentRateViewController

@synthesize amount;
@synthesize btcButton;
@synthesize timeStamp;
//@synthesize tapRecognizer;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserver:self selector:@selector(keyboardWillShow:) name:
     UIKeyboardWillShowNotification object:nil];
    
    [nc addObserver:self selector:@selector(keyboardWillHide:) name:
     UIKeyboardWillHideNotification object:nil];
    
    // COLORS
    
    amount.font = [UIFont boldFlatFontOfSize:42];
    
    // FUIButton
    btcButton.buttonColor = [UIColor turquoiseColor];
    btcButton.shadowColor = [UIColor greenSeaColor];
    btcButton.shadowHeight = 3.0f;
    btcButton.cornerRadius = 6.0f;
    btcButton.titleLabel.font = [UIFont boldFlatFontOfSize:22];
    [btcButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [btcButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    // FUIButton
    
    // TIMESTAMP
    timeStamp.font = [UIFont lightFlatFontOfSize:10];
    timeStamp.textColor = [UIColor silverColor];
    
    // BG
    UIColor *bgColor = [UIColor wetAsphaltColor];
    self.view.backgroundColor = bgColor;
    
    
    
}

//-(void)dismissKeyboard {
//    //[aTextField resignFirstResponder];
//    //[self.view endEditing:YES];
//    NSLog(@"dismiss keyboard");
//}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void) viewDidAppear:(BOOL)animated
{
    isFetching = NO;
    
    amountToConvert = [btcButton.titleLabel.text doubleValue];

    [self updateRateForCurrency];
    
    // Check to update the rate every x seconds
    [self startTimer];
    
}

- (void) startTimer
{
    if (timer == nil)
    {
        timer = [NSTimer scheduledTimerWithTimeInterval:FETCH_TIME_IN_SECONDS target:self
                                               selector:@selector(updateRateForCurrency) userInfo:nil repeats:YES];
    }
}

- (void) stopTimer
{
    if (timer != nil)
    {
        [timer invalidate];
        timer = nil;
    }
}

- (void) updateRateForCurrency
{
    // do whatever you want to do with this UITextField.
    
    btcButton.titleLabel.text = [[NSString stringWithFormat:@"%.2f", amountToConvert] stringByAppendingString:@" BTC"];
    
    if (!isFetching)
    {
        NSLog(@"Attempting to fetch latest rate...");
        
        isFetching = YES;
        
        // Add an activity indicator when fetching rate
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        spinner.color = [UIColor whiteColor];
        spinner.center = CGPointMake(160, 380);
        spinner.hidesWhenStopped = YES;
        [self.view addSubview:spinner];
        [spinner startAnimating];
        
        dispatch_queue_t myQueue = dispatch_queue_create("My Queue",NULL);
        
        dispatch_async(myQueue, ^{
            
            // Fetch the JSON rate data from Coinbase API
            NSError *error = nil;
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", COINBASE_URL, [SaveDataHelper loadCurrencySetting]]];
            NSString *json = [NSString stringWithContentsOfURL:url
                                                      encoding:NSASCIIStringEncoding
                                                         error:&error];
            
            if(!error) {
                NSData *jsonData = [json dataUsingEncoding:NSASCIIStringEncoding];
                NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                         options:kNilOptions
                                                                           error:&error];
                NSLog(@"JSON: %@", jsonDict);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    // Update the UI
                    NSString *rate = [CurrencyFormatHelper getFormattedCurrencyString:[jsonDict objectForKey:@"amount"]];
                    
                    amount.text = [NSString stringWithFormat:@"%.2f %@", ([rate floatValue]*amountToConvert), [SaveDataHelper loadCurrencySetting]];
                    //
                    NSDate *currentDate = [NSDate date];
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    NSString *dateString = [dateFormatter stringFromDate:currentDate];
                    timeStamp.text = [NSString stringWithFormat:@"Last updated: %@", dateString];
                    
                    //
                    
                    [spinner stopAnimating];
                });
                
                isFetching = NO;
                
            }
            else
            {
                NSLog(@"\nJSON: %@ \n Error: %@", json, error);
                
                // handle error
                FUIAlertView *message = [[FUIAlertView alloc] initWithTitle:@"Error getting rate"
                                                                  message:@"We were unable to fetch the latest Bitcoin rate. Please try again later."
                                                                 delegate:self
                                                        cancelButtonTitle:@"Ok"
                                                        otherButtonTitles:nil];

                [self configFUIAlertView:message];

                [message show];
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    // Update the UI
                    [spinner stopAnimating];
                    
                });
                
                isFetching = NO;
                
                [self stopTimer];
            }
            
            
        });
    }
    
}

//- (void) viewDidLayoutSubviews {
//    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
//        
//    } else {
//        self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
//        if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
//            self.edgesForExtendedLayout = UIRectEdgeNone;   // iOS 7 specific
//        CGRect viewBounds = self.view.bounds;
//        CGFloat topBarOffset = self.topLayoutGuide.length;
//        viewBounds.origin.y = topBarOffset * -1;
//        self.view.bounds = viewBounds;
//        self.navigationController.navigationBar.translucent = NO;
//    }
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) keyboardWillShow:(NSNotification *) note
{
}

-(void) keyboardWillHide:(NSNotification *) note
{
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex > 0)
    {
        UITextField *alertTextField = [alertView textFieldAtIndex:0];
        alertTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter; // not working ????
        NSLog(@"alerttextfiled - %@",alertTextField.text);
        
        
        // Make sure we get a valid number as input
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        NSNumber *n = [f numberFromString:alertTextField.text];
        
        if (n != NULL)
        {
            // do whatever you want to do with this UITextField.
            amountToConvert = [alertTextField.text floatValue];            
            
            [btcButton setTitle:[alertTextField.text stringByAppendingString:@" BTC"] forState:UIControlStateNormal];
            [btcButton setTitle:[alertTextField.text stringByAppendingString:@" BTC"] forState:UIControlStateHighlighted];
            [btcButton setTitle:[alertTextField.text stringByAppendingString:@" BTC"] forState:UIControlStateSelected];
            [btcButton setTitle:[alertTextField.text stringByAppendingString:@" BTC"] forState:UIControlStateDisabled];
            
            
            [self updateRateForCurrency];
        }
        else
        {
            NSLog(@"invalid string!!!!");
        }
    }
    
}



- (IBAction)btcButtonTapped:(id)sender
{
    
    FUIAlertView *alertView = [[FUIAlertView alloc] initWithTitle:@"Enter a BTC amount to convert:"
                                                          message:@""
                                                         delegate:self cancelButtonTitle:@"Dismiss"
                                                otherButtonTitles:@"Convert", nil];
    alertView.tag = 2;
    alertView.alertViewStyle = FUIAlertViewStylePlainTextInput;
    alertView.maxHeight = 180;
    
    [[alertView textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeDecimalPad];
    [[alertView textFieldAtIndex:0] setTextColor:[UIColor cloudsColor]];
    [[alertView textFieldAtIndex:0] setFont:[UIFont boldFlatFontOfSize:22]];
    [[alertView textFieldAtIndex:0] addTarget:self
                  action:@selector(textFieldDidChange:)
        forControlEvents:UIControlEventEditingChanged];

    [self configFUIAlertView:alertView];

    [alertView show];
    
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

    alert.titleLabel.textColor = [UIColor silverColor];
    alert.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    alert.messageLabel.textColor = [UIColor silverColor];
    alert.messageLabel.font = [UIFont flatFontOfSize:14];
    alert.backgroundOverlay.backgroundColor = [[UIColor wetAsphaltColor] colorWithAlphaComponent:0.8];
    alert.alertContainer.backgroundColor = [UIColor midnightBlueColor];
    alert.defaultButtonColor = [UIColor cloudsColor];
    alert.defaultButtonShadowColor = [UIColor asbestosColor];
    alert.defaultButtonFont = [UIFont boldFlatFontOfSize:14];
    alert.defaultButtonTitleColor = [UIColor asbestosColor];

}

-(void)textFieldDidChange :(UITextField *) alertTextField
{
    NSLog( @"text changed: %@", alertTextField.text);
    
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    NSNumber *n = [f numberFromString:alertTextField.text];
    
    if (n != NULL)
    {
        // text is valid
        alertTextField.textColor = [UIColor cloudsColor];
    }
    else
    {
        // text is invalid
        alertTextField.textColor = [UIColor pomegranateColor];
    }
}


@end