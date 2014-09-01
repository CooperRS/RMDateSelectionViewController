//
//  RMViewController.m
//  RMDateSelectionViewController-Demo
//
//  Created by Roland Moers on 26.10.13.
//  Copyright (c) 2013 Roland Moers
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "RMViewController.h"

@interface RMViewController () <RMDateSelectionViewControllerDelegate>

@property (nonatomic, weak) IBOutlet UISwitch *blackSwitch;
@property (nonatomic, weak) IBOutlet UISwitch *blurSwitch;
@property (nonatomic, weak) IBOutlet UISwitch *motionSwitch;
@property (nonatomic, weak) IBOutlet UISwitch *bouncingSwitch;

@end

@implementation RMViewController

#pragma mark - Actions
- (IBAction)openDateSelectionController:(id)sender {
    RMDateSelectionViewController *dateSelectionVC = [RMDateSelectionViewController dateSelectionController];
    dateSelectionVC.delegate = self;
    dateSelectionVC.titleLabel.text = @"This is an example title.\n\nPlease choose a date and press 'Select' or 'Cancel'.";
    
    //You can enable or disable blur, bouncing and motion effects
    dateSelectionVC.disableBouncingWhenShowing = !self.bouncingSwitch.on;
    dateSelectionVC.disableMotionEffects = !self.motionSwitch.on;
    dateSelectionVC.disableBlurEffects = !self.blurSwitch.on;
    
    //You can also adjust colors (enabling the following line will result in a black version of RMDateSelectionViewController)
    if(self.blackSwitch.on)
        dateSelectionVC.blurEffectStyle = UIBlurEffectStyleDark;
    
    //Enable the following lines if you want a black version of RMDateSelectionViewController but also disabled blur effects (or run on iOS 7)
    //dateSelectionVC.tintColor = [UIColor whiteColor];
    //dateSelectionVC.backgroundColor = [UIColor colorWithWhite:0.25 alpha:1];
    //dateSelectionVC.selectedBackgroundColor = [UIColor colorWithWhite:0.4 alpha:1];
    
    //You can access the actual UIDatePicker via the datePicker property
    dateSelectionVC.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    dateSelectionVC.datePicker.minuteInterval = 5;
    dateSelectionVC.datePicker.date = [NSDate dateWithTimeIntervalSinceReferenceDate:0];
    
    //The example project is universal. So we first need to check whether we run on an iPhone or an iPad.
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        //OK, running on an iPhone. The following lines demonstrate the two ways to show the date selection view controller on iPhones:
        //(Note: These two methods also work an iPads.)
        
        // 1. Just show the date selection view controller (make sure the delegate property is assigned)
        [dateSelectionVC show];
        
        // 2. Instead of using a delegate you can also pass blocks when showing the date selection view controller
        //[dateSelectionVC showWithSelectionHandler:^(RMDateSelectionViewController *vc, NSDate *aDate) {
        //    NSLog(@"Successfully selected date: %@ (With block)", aDate);
        //} andCancelHandler:^(RMDateSelectionViewController *vc) {
        //    NSLog(@"Date selection was canceled (with block)");
        //}];
    } else if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        //OK, running on an iPad. The following lines demonstrate the four special ways of showing the date selection view controller on iPads:
        
        // 1. Show the date selection view controller from a particular view controller (make sure the delegate property is assigned).
        //    This method can be used to show the date selection view controller within popovers.
        //    (Note: We do not use self as the view controller, as showing a date selection view controller from a table view controller
        //           is not supported due to UIKit limitations.)
        //[dateSelectionVC showFromViewController:self.navigationController];
        
        // 2. As with the two ways of showing the date selection view controller on iPhones, we can also use a blocks based API.
        //[dateSelectionVC showFromViewController:self.navigationController withSelectionHandler:^(RMDateSelectionViewController *vc, NSDate *aDate) {
        //    NSLog(@"Successfully selected date: %@ (With block)", aDate);
        //} andCancelHandler:^(RMDateSelectionViewController *vc) {
        //    NSLog(@"Date selection was canceled (with block)");
        //}];
        
        // 3. Show the date selection view controller using a UIPopoverController. The rect and the view are used to tell the
        //    UIPopoverController where to show up.
        [dateSelectionVC showFromRect:[self.tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] inView:self.view];
        
        // 4. The date selectionview controller can also be shown within a popover while also using blocks based API.
        //[dateSelectionVC showFromRect:[self.tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] inView:self.view withSelectionHandler:^(RMDateSelectionViewController *vc, NSDate *aDate) {
        //    NSLog(@"Successfully selected date: %@ (With block)", aDate);
        //} andCancelHandler:^(RMDateSelectionViewController *vc) {
        //    NSLog(@"Date selection was canceled (with block)");
        //}];
    }
}

#pragma mark - UITableView Delegates
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0 && indexPath.row == 0) {
        [self openDateSelectionController:self];
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - RMDAteSelectionViewController Delegates
- (void)dateSelectionViewController:(RMDateSelectionViewController *)vc didSelectDate:(NSDate *)aDate {
    NSLog(@"Successfully selected date: %@", aDate);
}

- (void)dateSelectionViewControllerDidCancel:(RMDateSelectionViewController *)vc {
    NSLog(@"Date selection was canceled");
}

@end
