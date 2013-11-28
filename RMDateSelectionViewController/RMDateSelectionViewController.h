//
//  RMDateSelectionViewController.h
//  RMDateSelectionViewController
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

#import <UIKit/UIKit.h>

/**
 `RMDateSelectionViewController` is an iOS control for selecting a date using UIDatePicker in a UIActionSheet like fashon.
 */

@class RMDateSelectionViewController;

/**
 This block is called when the user selects a certain date if blocks are used.
 
 @param vc The date selection view controller that just finished selecting a date.
 
 @param aDate The selected date.
 */

typedef void (^RMDateSelectionBlock)(RMDateSelectionViewController *vc, NSDate *aDate);

/**
 This block is called when the user cancels if blocks are used.
 
 @param vc The date selection view controller that just got canceled.
  */
typedef void (^RMDateCancelBlock)(RMDateSelectionViewController *vc);

@protocol RMDateSelectionViewControllerDelegate <NSObject>

/**
 This delegate method is called when the user selects a certain date.
 
 @param vc The date selection view controller that just finished selecting a date.
 
 @param aDate The selected date.
 */
- (void)dateSelectionViewController:(RMDateSelectionViewController *)vc didSelectDate:(NSDate *)aDate;

/**
 This delegate method is called when the user selects the cancel button.
 
 @param vc The date selection view controller that just canceled.
 */
- (void)dateSelectionViewControllerDidCancel:(RMDateSelectionViewController *)vc;

@end

@interface RMDateSelectionViewController : UIViewController

/// @name Properties

/**
 Will return the instance of UIDatePicker that is used. This property will be nil until -[RMDateSelectionViewController show] or -[RMDateSelectionViewController showFromViewController:] is called.
 */
@property (weak, readonly) UIDatePicker *datePicker;

/**
 Used to set the delegate.
 
 The delegate must conform to the `RMDateSelectionViewControllerDelegate` protocol.
 */
@property (weak) id<RMDateSelectionViewControllerDelegate> delegate;

/**
 Used to set the text color of the buttons but not the date picker.
 */
@property (strong, nonatomic) UIColor *tintColor;

/**
 Used to set the background color.
 */
@property (strong, nonatomic) UIColor *backgroundColor;

/**
 Used to enable or disable motion effects. Default value is NO.
 */
@property (assign, nonatomic) BOOL disableMotionEffects;

/**
 Used to enable or disable bouncing effects when sliding in the date selection view. Default value is NO.
 */
@property (assign, nonatomic) BOOL disableBouncingWhenShowing;

/// @name Class Methods

/**
 This returns a new instance of `RMDateSelectionViewController`. Always use this class method to get an instance. Do not initialize an instance yourself.
 
 @return Returns a new instance of `RMDateSelectionViewController`
 */
+ (instancetype)dateSelectionController;

/// @name Instance Methods

/**
 This shows the date selection view controller as child view controller of the root view controller of the current key window.
 
 The content of the rootview controller will be darkened and the date selection view controller will be shown on top.
 
 Make sure the delegate property is assigned. Otherwise you will not get any calls when a date is selected or the selection has been canceled.
 */
- (void)show;

/**
 This shows the date selection view controller as child view controller of the root view controller of the current key window.
 
 The content of the rootview controller will be darkened and the date selection view controller will be shown on top.
 
 After a date has been selected the selectionBlock will be called. If you assigned a delegate the corresponding delegate method will be called, too. Keep in mind that when the user cancels selection you will only get calls if you assigned a delegate.
 
 @param selectionBlock The block to call when the user selects a date.
 */
- (void)showWithSelectionHandler:(RMDateSelectionBlock)selectionBlock;

/**
 This shows the date selection view controller as child view controller of the root view controller of the current key window.
 
 The content of the rootview controller will be darkened and the date selection view controller will be shown on top.
 
 After a date has been selected the selectionBlock will be called. If the user choses to cancel the selection, the cancel block will be called. If you assigned a delegate the corresponding delegate methods will be called, too.
 
 @param selectionBlock The block to call when the user selects a date.
 @param cancelBlock The block to call when the user cancels the selection.
 */
- (void)showWithSelectionHandler:(RMDateSelectionBlock)selectionBlock andCancelHandler:(RMDateCancelBlock)cancelBlock;

/**
 This shows the date selection view controller as child view controller of aViewController.
 
 The content of aViewController will be darkened and the date selection view controller will be shown on top.
 
 @param aViewController The date selection view controller will be displayed as a child view controller of this view controller.
 */
- (void)showFromViewController:(UIViewController *)aViewController;

/**
 This will remove the date selection view controller from whatever view controller it is currently shown in.
 */
- (void)dismiss;

@end
