//
//  RMDateSelectionViewController.h
//  Transrapid
//
//  Created by Roland Moers on 26.10.13.
//  Copyright (c) 2013 Roland Moers. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RMDateSelectionViewController;

@protocol RMDateSelectionViewControllerDelegate <NSObject>

- (void)dateSelectionViewController:(RMDateSelectionViewController *)vc didSelectDate:(NSDate *)aDate;
- (void)dateSelectionViewControllerDidCancel:(RMDateSelectionViewController *)vc;

@end

@interface RMDateSelectionViewController : UIViewController

@property (weak) id<RMDateSelectionViewControllerDelegate> delegate;

@property (nonatomic, strong) NSDate *originalDate;
@property (nonatomic, assign) UIDatePickerMode mode;

+ (instancetype)dateSelectionController;

- (void)show;
- (void)showFromViewController:(UIViewController *)aViewController;

- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)doneButtonPressed:(id)sender;

- (IBAction)nowButtonPressed:(id)sender;

@end
