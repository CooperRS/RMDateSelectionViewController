//
//  RMViewController.m
//  RMDateSelectionViewController-Demo
//
//  Created by Roland Moers on 26.10.13.
//  Copyright (c) 2013 Roland Moers. All rights reserved.
//

#import "RMViewController.h"

#import "RMDateSelectionViewController.h"

@interface RMViewController () <RMDateSelectionViewControllerDelegate>

@end

@implementation RMViewController

- (IBAction)openDateSelectionController:(id)sender {
    RMDateSelectionViewController *dateSelectionVC = [RMDateSelectionViewController dateSelectionController];
    dateSelectionVC.delegate = self;
    
    //You can also set what the user can select (default is time)
    dateSelectionVC.mode = UIDatePickerModeDateAndTime;
    
    //You can also set the minuteInterval (default is 5)
    dateSelectionVC.minuteInterval = 5;
    
    //You can also set an original date (default is the current date)
    dateSelectionVC.originalDate = [NSDate dateWithTimeIntervalSinceReferenceDate:0];
    
    [dateSelectionVC show];
}

#pragma mark - RMDAteSelectionViewController Delegates
- (void)dateSelectionViewController:(RMDateSelectionViewController *)vc didSelectDate:(NSDate *)aDate {
    NSLog(@"Successfully selected date: %@", aDate);
}

- (void)dateSelectionViewControllerDidCancel:(RMDateSelectionViewController *)vc {
    NSLog(@"Date selection was canceled");
}

@end
