//
//  CurrencySelectViewController.m
//  SimpleBitcoinChecker
//
//  Created by Stephen on 2014-08-27.
//  Copyright (c) 2014 Stephen Ceresia. All rights reserved.
//

#import "CurrencySelectViewController.h"
#import "SaveDataHelper.h"
#import "UIColorFromHex.h"

#import "UIFont+FlatUI.h"
#import <FlatUIKit/UIColor+FlatUI.h>
#import "FlatUIKit.h"

@interface CurrencySelectViewController ()

@end

static NSString * const FUITableViewControllerCellReuseIdentifier = @"FUITableViewControllerCellReuseIdentifier";

@implementation CurrencySelectViewController

@synthesize currencies;
@synthesize selectedIndex;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //[self setClearsSelectionOnViewWillAppear:NO ];
    
    self.view.backgroundColor = [UIColor wetAsphaltColor];
	// Do any additional setup after loading the view, typically from a nib.
    
    // TODO: alphabetical sort
    self.currencies = @[@"AUD", @"CAD", @"CHF", @"CNY", @"EUR", @"GBP",  @"JPY", @"MXN", @"NZD", @"RUB", @"SEK", @"TRY", @"USD"];
    
    // FUI
    //Set the separator color
    self.tableView.separatorColor = [UIColor cloudsColor];
    //Set the background color
    self.tableView.backgroundColor = [UIColor wetAsphaltColor];
    self.tableView.backgroundView = nil;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:FUITableViewControllerCellReuseIdentifier];
    
    // FUI
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.currencies count];
    
}


// This is where we create the cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // SET UP TABLE, STYlE CELL ///////////
    
    UIRectCorner corners = 0;
    if (tableView.style == UITableViewStyleGrouped) {
        if ([tableView numberOfRowsInSection:indexPath.section] == 1) {
            corners = UIRectCornerAllCorners;
        } else if (indexPath.row == 0) {
            corners = UIRectCornerTopLeft | UIRectCornerTopRight;
        } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section] - 1) {
            corners = UIRectCornerBottomLeft | UIRectCornerBottomRight;
        }
    }
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:FUITableViewControllerCellReuseIdentifier];
    [cell configureFlatCellWithColor:[UIColor wetAsphaltColor]
                       selectedColor:[UIColor greenSeaColor]
                     roundingCorners:corners];
    
//    NSString *currency = [self.currencies objectAtIndex:indexPath.row];
//    cell.textLabel.text = currency;
//    cell.textLabel.font = [UIFont lightFlatFontOfSize:24];
//    cell.textLabel.textColor = [UIColor silverColor];
//    
//    // Set and scale flag image
//    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", cell.textLabel.text]];
//    CGFloat widthScale = 43 / cell.imageView.image.size.width;
//    CGFloat heightScale = 30 / cell.imageView.image.size.height;
//    cell.imageView.transform = CGAffineTransformMakeScale(widthScale, heightScale);
//    
//    // SET UP TABLE, STYlE CELL ///////////
//
//    
//    // Set the checked currency as last selected, otherwise use USD as default
//    NSString *savedCurrencySetting = [SaveDataHelper loadCurrencySetting];
//    
//    if ([currency isEqualToString:savedCurrencySetting])
//    {
//        [cell setSelected:YES animated:NO];
//        selectedIndex = indexPath;
//        lastSavedCurrency = currency;
//        [SaveDataHelper saveCurrencySetting:lastSavedCurrency];
//        NSLog(@"selected currency is %@", savedCurrencySetting);
//    }
//    else
//    {
//        [cell setSelected:NO animated:NO];
//    }
    
//    
//    if ([indexPath isEqual:selectedIndex])
//    {
//        [cell setSelected:YES animated:NO];
//        //[cell setHighlighted:YES];
//    }
//    else {
//        [cell setSelected:NO animated:NO];
//        //[cell setHighlighted:NO];
//    }
    
    return cell;
    // FUI
    
}

// This is where the cell content should be added
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *currency = [self.currencies objectAtIndex:indexPath.row];
    cell.textLabel.text = currency;
    cell.textLabel.font = [UIFont lightFlatFontOfSize:24];
    cell.textLabel.textColor = [UIColor silverColor];
    
    // Set and scale flag image
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", cell.textLabel.text]];
    CGFloat widthScale = 43 / cell.imageView.image.size.width;
    CGFloat heightScale = 30 / cell.imageView.image.size.height;
    cell.imageView.transform = CGAffineTransformMakeScale(widthScale, heightScale);
    
    // Set the checked currency as last selected, otherwise use USD as default
    NSString *savedCurrencySetting = [SaveDataHelper loadCurrencySetting];
    
    if ([currency isEqualToString:savedCurrencySetting])
    {
        [cell setSelected:YES animated:NO];
        selectedIndex = indexPath;
        lastSavedCurrency = currency;
        [SaveDataHelper saveCurrencySetting:lastSavedCurrency];
        NSLog(@"selected currency is %@", savedCurrencySetting);
    }
    else
    {
        [cell setSelected:NO animated:NO];
    }
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // Un-highlight the previously selected cell
    UITableViewCell *lastCell = [tableView cellForRowAtIndexPath:selectedIndex];
    [lastCell setSelected:NO animated:NO];
    
    // Highlight the new cell
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:YES animated:NO];
    
    lastSavedCurrency = cell.textLabel.text;
    selectedIndex = indexPath;
    [SaveDataHelper saveCurrencySetting:lastSavedCurrency];

    NSLog(@"selected currency is now %@", lastSavedCurrency);
    
}

- (void) viewWillAppear:(BOOL)animated
{
//    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:animated];
//    [super viewWillAppear:animated];
    
    // Highlight the last selected cell
//    if (selectedIndex != nil)
//    {
//        UITableViewCell *lastCell = [self.tableView cellForRowAtIndexPath:selectedIndex];
//        [lastCell setSelected:YES animated:NO];
//    }
//    [super viewWillAppear:animated];
//    
}

- (void) viewDidAppear:(BOOL)animated
{
    if (selectedIndex != nil)
    {
        UITableViewCell *lastCell = [self.tableView cellForRowAtIndexPath:selectedIndex];
        [lastCell setSelected:YES animated:NO];
        //[lastCell setHighlighted:YES];
        [super viewDidAppear:animated];

    }
}


- (void)viewWillDisappear:(BOOL)animated
{
    [SaveDataHelper saveCurrencySetting:lastSavedCurrency];
    
    //[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:animated];
    //[super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
