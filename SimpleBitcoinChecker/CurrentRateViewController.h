//
//  CurrentRateViewController.h
//  SimpleBitcoinChecker
//
//  Created by Stephen on 2014-08-27.
//  Copyright (c) 2014 Stephen Ceresia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FUIButton.h"
#import "FUIAlertView.h"


@interface CurrentRateViewController : UIViewController <FUIAlertViewDelegate>
{
    bool isFetching;
    NSTimer *timer;
    float amountToConvert;
}

//@property (strong, nonatomic) UITapGestureRecognizer *tapRecognizer;


@property (weak, nonatomic) IBOutlet UILabel *amount;
@property (weak, nonatomic) IBOutlet UILabel *timeStamp;
@property (weak, nonatomic) IBOutlet FUIButton *btcButton;

- (IBAction)btcButtonTapped:(id)sender;
@end
