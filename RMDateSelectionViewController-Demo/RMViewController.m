//
//  RMViewController.m
//  RMDateSelectionViewController-Demo
//
//  Created by Roland Moers on 26.10.13.
//  Copyright (c) 2013-2015 Roland Moers
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

@interface RMViewController ()

@property (nonatomic, weak) IBOutlet UISwitch *blackSwitch;
@property (nonatomic, weak) IBOutlet UISwitch *blurSwitch;
@property (nonatomic, weak) IBOutlet UISwitch *motionSwitch;
@property (nonatomic, weak) IBOutlet UISwitch *bouncingSwitch;

@end

@implementation RMViewController

#pragma mark - Actions
- (IBAction)openDateSelectionController:(id)sender {
    RMActionControllerStyle style = RMActionControllerStyleWhite;
    if(self.blackSwitch.on) {
        style = RMActionControllerStyleBlack;
    }
    
    RMAction *selectAction = [RMAction actionWithTitle:@"Select" style:RMActionStyleDone andHandler:^(RMActionController *controller) {
        NSLog(@"Successfully selected date: %@", ((UIDatePicker *)controller.contentView).date);
    }];
    
    RMAction *cancelAction = [RMAction actionWithTitle:@"Cancel" style:RMActionStyleCancel andHandler:^(RMActionController *controller) {
        NSLog(@"Date selection was canceled");
    }];
    
    RMDateSelectionViewController *dateSelectionController = [RMDateSelectionViewController actionControllerWithStyle:style];
    dateSelectionController.title = @"Test";
    dateSelectionController.message = @"This is a test message.\nPlease choose a date and press 'Select' or 'Cancel'.";
    
    [dateSelectionController addAction:selectAction];
    [dateSelectionController addAction:cancelAction];
    
    RMAction *in15MinAction = [RMAction actionWithTitle:@"15 Min" style:RMActionStyleAdditional andHandler:^(RMActionController *controller) {
        ((UIDatePicker *)controller.contentView).date = [NSDate dateWithTimeIntervalSinceNow:15*60];
        NSLog(@"15 Min button tapped");
    }];
    in15MinAction.dismissesActionController = NO;
    
    RMAction *in30MinAction = [RMAction actionWithTitle:@"30 Min" style:RMActionStyleAdditional andHandler:^(RMActionController *controller) {
        ((UIDatePicker *)controller.contentView).date = [NSDate dateWithTimeIntervalSinceNow:30*60];
        NSLog(@"30 Min button tapped");
    }];
    in30MinAction.dismissesActionController = NO;
    
    RMAction *in45MinAction = [RMAction actionWithTitle:@"45 Min" style:RMActionStyleAdditional andHandler:^(RMActionController *controller) {
        ((UIDatePicker *)controller.contentView).date = [NSDate dateWithTimeIntervalSinceNow:45*60];
        NSLog(@"45 Min button tapped");
    }];
    in45MinAction.dismissesActionController = NO;
    
    RMAction *in60MinAction = [RMAction actionWithTitle:@"60 Min" style:RMActionStyleAdditional andHandler:^(RMActionController *controller) {
        ((UIDatePicker *)controller.contentView).date = [NSDate dateWithTimeIntervalSinceNow:60*60];
        NSLog(@"60 Min button tapped");
    }];
    in60MinAction.dismissesActionController = NO;
    
    RMGroupedAction *groupedAction = [RMGroupedAction actionWithStyle:RMActionStyleAdditional andActions:@[in15MinAction, in30MinAction, in45MinAction, in60MinAction]];
    
    [dateSelectionController addAction:groupedAction];
    
    RMAction *nowAction = [RMAction actionWithTitle:@"Now" style:RMActionStyleAdditional andHandler:^(RMActionController *controller) {
        ((UIDatePicker *)controller.contentView).date = [NSDate date];
        NSLog(@"Now button tapped");
    }];
    nowAction.dismissesActionController = NO;
    
    [dateSelectionController addAction:nowAction];
    
    //You can enable or disable blur, bouncing and motion effects
    dateSelectionController.disableBouncingEffects = !self.bouncingSwitch.on;
    dateSelectionController.disableMotionEffects = !self.motionSwitch.on;
    dateSelectionController.disableBlurEffects = !self.blurSwitch.on;
    
    //You can access the actual UIDatePicker via the datePicker property
    dateSelectionController.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    dateSelectionController.datePicker.minuteInterval = 5;
    dateSelectionController.datePicker.date = [NSDate dateWithTimeIntervalSinceReferenceDate:0];
    
    //On the iPad we want to show the date selection view controller within a popover. Fortunately, we can use iOS 8 API for this! :)
    //(Of course only if we are running on iOS 8 or later)
    if([dateSelectionController respondsToSelector:@selector(popoverPresentationController)] && [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        //First we set the modal presentation style to the popover style
        dateSelectionController.modalPresentationStyle = UIModalPresentationPopover;
        
        //Then we tell the popover presentation controller, where the popover should appear
        dateSelectionController.popoverPresentationController.sourceView = self.tableView;
        dateSelectionController.popoverPresentationController.sourceRect = [self.tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    }
    
    //Now just present the date selection controller using the standard iOS presentation method
    [self presentViewController:dateSelectionController animated:YES completion:nil];
}

#pragma mark - UITableView Delegates
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0 && indexPath.row == 0) {
        [self openDateSelectionController:self];
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
