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
 Used to set the block which will be used when a date is selected (when set).
 */
@property (nonatomic, copy) RMDateSelectionBlock selectedDateBlock;

/**
 Used to set the block which will be used when a date is selected (when set).
 */
@property (nonatomic, copy) RMDateCancelBlock cancelBlock;

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

/**
 This returns a new instance of `RMDateSelectionViewController`. Always use this class method to get an instance. Do not initialize an instance yourself.
 This is an optional method to insert the handler block when a date is selected.
 
 @return Returns a new instance of `RMDateSelectionViewController`
 */
+ (instancetype) dateSelectionControllerWithHandlerBlock:(RMDateSelectionBlock)dateSelectionBlock;

/**
 This returns a new instance of `RMDateSelectionViewController`. Always use this class method to get an instance. Do not initialize an instance yourself.
 This is an optional method to insert the handler (when the date is selected) and cancel block.
 
 @return Returns a new instance of `RMDateSelectionViewController`
 */
+ (instancetype) dateSelectionControllerWithHandlerBlock:(RMDateSelectionBlock)dateSelectionBlock cancelBlock:(RMDateCancelBlock)cancelBlock;

/// @name Instance Methods

/**
 This shows the date selection view controller as child view controller of the root view controller of the current key window.
 
 The content of the rootview controller will be darkened and the date selection view controller will be shown on top.
 */
- (void)show;

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
