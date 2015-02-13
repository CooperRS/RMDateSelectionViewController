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

typedef NS_ENUM(NSInteger, RMDateSelectionViewControllerStatusBarHiddenMode) {
    /** On iOS 7, the status bar is not hidden in any orientation. On iOS 8, the status is not hidden in portrait mode and hidden in landscape mode. */
    RMDateSelectionViewControllerStatusBarHiddenModeDefault,
    /** The status bar is always hidden, regardless of orientation and iOS version. */
    RMDateSelectionViewControllerStatusBarHiddenModeAlways,
    /** The status bar is never hidden, regardless of orientation and iOS version. */
    RMDateSelectionViewControllerStatusBarHiddenModeNever
};

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

/**
 *  These methods are used to inform the [delegate]([RMDateSelectionViewController delegate]) of an instance of RMDateSelectionViewController about the status of the date selection view controller.
 */
@protocol RMDateSelectionViewControllerDelegate <NSObject>

/// @name Cancel and Select

/**
 This method is called when the user selects a certain date.
 
 @param vc      The date selection view controller that just finished selecting a date.
 @param aDate   The selected date.
 */
- (void)dateSelectionViewController:(RMDateSelectionViewController *)vc didSelectDate:(NSDate *)aDate;

@optional

/**
 This method is called when the user selects the cancel button or taps the darkened background (if the property [backgroundTapsDisabled]([RMDateSelectionViewController backgroundTapsDisabled]) of RMDateSelectionViewController returns NO).
 
 @discussion Implementation of this method is optional. When the cancel button is pressed, the date selection view controller will be dismissed. This method can be implemented to do anything additional to the dismissal.

 @param vc  The date selection view controller that just canceled.
 */
- (void)dateSelectionViewControllerDidCancel:(RMDateSelectionViewController *)vc;

/// @name Additional Buttons

/**
 *  This method is called when the now button of the date selection view controller has been pressed.
 *  
 *  @warning Implementation of this method is optional. If you choose to implement it, you are responsible to do whatever should be done when the now button has been pressed. If you do not choose to implement it, the default behavior is to set the date selection control to the current date.
 *
 *  @param vc   The date selection view controller whose now button has been pressed.
 */
- (void)dateSelectionViewControllerNowButtonPressed:(RMDateSelectionViewController *)vc;

@end

/**
 *  RMDateSelectionViewController is an iOS control for selecting a date using UIDatePicker in a UIActionSheet like fashon. When a RMDateSelectionViewController is shown the user gets the opportunity to select a date using a UIDatePicker.
 *
 *  RMDateSelectionViewController supports bouncing effects when animating the date selection view controller. In addition, motion effects are supported while showing the date selection view controller. Both effects can be disabled by using the properties called disableBouncingWhenShowing and disableMotionEffects.
 *
 *  On iOS 8 and later Apple opened up their API for blurring the background of UIViews. RMDateSelectionViewController makes use of this API. The type of the blur effect can be changed by using the blurEffectStyle property. If you want to disable the blur effect you can do so by using the disableBlurEffects property.
 *
 *  @warning RMDateSelectionViewController is not designed to be reused. Each time you want to display a RMDateSelectionViewController a new instance should be created. If you want to set a specific date before displaying, you can do so by using the datePicker property.
 */
@interface RMDateSelectionViewController : UIViewController

/// @name Getting an Instance

/**
 *  This returns a new instance of RMDateSelectionViewController.
 *
 *  @warning Always use this class method to get an instance. Do not initialize an instance yourself.
 *
 *  @return  Returns a new instance of RMDateSelectionViewController
 */
+ (instancetype)dateSelectionController;

/// @name Localization

/**
 *  Set a localized title for the now button. Default title is 'Now'.
 *
 *  @param newLocalizedTitle    The new localized title for the now button.
 */
+ (void)setLocalizedTitleForNowButton:(NSString *)newLocalizedTitle;

/**
 *  Set a localized title for the cancel button. Default title is 'Cancel'.
 *
 *  @param newLocalizedTitle    The new localized title for the cancel button.
 */
+ (void)setLocalizedTitleForCancelButton:(NSString *)newLocalizedTitle;

/**
 *  Set a localized title for the select button. Default is 'Select'.
 *
 *  @param newLocalizedTitle    The new localized title for the select button.
 */
+ (void)setLocalizedTitleForSelectButton:(NSString *)newLocalizedTitle;

/// @name Delegate

/**
 *  Used to set the delegate.
 *
 *  The delegate must conform to the RMDateSelectionViewControllerDelegate protocol.
 */
@property (weak) id<RMDateSelectionViewControllerDelegate> delegate;

/// @name User Interface

/**
 *  Will return the instance of UIDatePicker that is used.
 */
@property (nonatomic, readonly) UIDatePicker *datePicker;

/**
 *  Will return the label that is used as a title for the picker. You can use this property to set a title and to customize the appearance of the title.
 *
 *  @warning If you want to set a title, be sure to set it before showing the picker view controller as otherwise the title will not be shown.
 */
@property (nonatomic, strong, readonly) UILabel *titleLabel;

/**
 *  When YES the now button is hidden. Default value is NO.
 *
 *  @warning If you want to change this property you must do this before showing the RMDateSelectionViewController or otherwise setting this property has no effect.
 */
@property (assign, nonatomic) BOOL hideNowButton;

/**
 *  When YES taps on the background view are ignored. Default value is NO.
 */
@property (assign, nonatomic) BOOL backgroundTapsDisabled;

/// @name Appearance

/**
 *  Used to set the preferred status bar style.
 */
@property (nonatomic, assign, readwrite) UIStatusBarStyle preferredStatusBarStyle;

/**
 *  Used to hide the status bar.
 */
@property (nonatomic, assign) RMDateSelectionViewControllerStatusBarHiddenMode statusBarHiddenMode;

/**
 *  Used to set the text color of the buttons but not the date picker.
 */
@property (strong, nonatomic) UIColor *tintColor;

/**
 *  Used to set the background color.
 */
@property (strong, nonatomic) UIColor *backgroundColor;

/**
 *  Used to set the background color when the user selets a button.
 */
@property (strong, nonatomic) UIColor *selectedBackgroundColor;

/// @name Effects

/**
 *  Used to enable or disable motion effects. Default value is NO.
 */
@property (assign, nonatomic) BOOL disableMotionEffects;

/**
 *  Used to enable or disable bouncing effects when sliding in the date selection view. Default value is NO.
 */
@property (assign, nonatomic) BOOL disableBouncingWhenShowing;

/**
 *  Used to enable or disable blurring the date selection view. Default value is NO.
 *
 *  @warning This property always returns NO if either UIBlurEffect, UIVibrancyEffect or UIVisualEffectView is not available on your system at runtime.
 */
@property (assign, nonatomic) BOOL disableBlurEffects;

/**
 *  Used to choose a particular blur effect style (default value is UIBlurEffectStyleExtraLight). The value ir ignored if blur effects are disabled.
 */
@property (assign, nonatomic) UIBlurEffectStyle blurEffectStyle;

/// @name Showing

/**
 *  This shows the date selection view controller on top of every other view controller using a new UIWindow. The RMDateSelectionViewController will be added as a child view controller of the UIWindows root view controller. The background of the root view controller is used to darken the views behind the RMDateSelectionViewController.
 *
 *  This method is the preferred method for showing a RMDateSelectionViewController on iPhones and iPads. Nevertheless, there are situations where this method is not sufficient on iPads. An example for this is that the RMDateSelectionViewController shall be shown within an UIPopover. This can be achieved by using [showFromViewController:]([RMDateSelectionViewController showFromViewController:]).
 *
 *  @warning Make sure the delegate property is assigned. Otherwise you will not get any calls when a date is selected or the selection has been canceled.
 */
- (void)show;

/**
 *  This shows the date selection view controller on top of every other view controller using a new UIWindow. The RMDateSelectionViewController will be added as a child view controller of the UIWindows root view controller. The background of the root view controller is used to darken the views behind the RMDateSelectionViewController.
 *
 *  After a date has been selected the selection block will be called. If the user choses to cancel the selection, the cancel block will be called. If you assigned a delegate the corresponding methods will be called, too.
 *
 *  This method is the preferred method for showing a RMDateSelectionViewController on iPhones and iPads when a block based API is preferred. Nevertheless, there are situations where this method is not sufficient on iPads. An example for this is that the RMDateSelectionViewController shall be shown within an UIPopover. This can be achieved by using [showFromViewController:withSelectionHandler:andCancelHandler:]([RMDateSelectionViewController showFromViewController:withSelectionHandler:andCancelHandler:]).
 *
 *  @param selectionBlock The block to call when the user selects a date.
 *  @param cancelBlock    The block to call when the user cancels the selection.
 */
- (void)showWithSelectionHandler:(RMDateSelectionBlock)selectionBlock andCancelHandler:(RMDateCancelBlock)cancelBlock;

/**
 *  This shows the date selection view controller as child view controller of the view controller you passed in as parameter. The content of this view controller will be darkened and the date selection view controller will be shown on top.
 *
 *  @warning This method should only be used on iPads in situations where [show]([RMDateSelectionViewController show]) is not sufficient (for example, when the RMDateSelectionViewController shoud be shown within an UIPopover). If [show]([RMDateSelectionViewController show]) is sufficient, please use it!
 *
 *  @warning Make sure the delegate property is assigned. Otherwise you will not get any calls when a date is selected or the selection has been canceled.
 *
 *  @param aViewController The parent view controller of the RMDateSelectionViewController.
 */
- (void)showFromViewController:(UIViewController *)aViewController;

/**
 *  This shows the date selection view controller as child view controller of the view controller you passed in as parameter. The content of this view controller will be darkened and the date selection view controller will be shown on top.
 *
 *  After a date has been selected the selection block will be called. If the user choses to cancel the selection, the cancel block will be called. If you assigned a delegate the corresponding methods will be called, too.
 *
 *  @warning This method should only be used on iPads in situations where [showWithSelectionHandler:andCancelHandler:]([RMDateSelectionViewController showWithSelectionHandler:andCancelHandler:]) is not sufficient (for example, when the RMDateSelectionViewController shoud be shown within an UIPopover). If [showWithSelectionHandler:andCancelHandler:]([RMDateSelectionViewController showWithSelectionHandler:andCancelHandler:]) is sufficient, please use it!
 *
 *  @param aViewController The parent view controller of the RMDateSelectionViewController.
 *  @param selectionBlock  The block to call when the user selects a date.
 *  @param cancelBlock     The block to call when the user cancels the selection.
 */
- (void)showFromViewController:(UIViewController *)aViewController withSelectionHandler:(RMDateSelectionBlock)selectionBlock andCancelHandler:(RMDateCancelBlock)cancelBlock;

/**
 *  This shows the date selection view controller within a popover. The popover is initialized with the date selection view controller as content view controller and then presented from the rect in the view given as parameters.
 *
 *  @warning Make sure the delegate property is assigned. Otherwise you will not get any calls when a date is selected or the selection has been canceled.
 *
 *  @warning This method should only be used on iPads. On iPhones please use [show]([RMDateSelectionViewController show]) or [showWithSelectionHandler:andCancelHandler:]([RMDateSelectionViewController showWithSelectionHandler:andCancelHandler:]) instead.
 *
 *  @param aRect The rect in the given view the popover should be presented from.
 *  @param aView The view the popover should be presented from.
 */
- (void)showFromRect:(CGRect)aRect inView:(UIView *)aView;

/**
 *  This shows the date selection view controller within a popover. The popover is initialized with the date selection view controller as content view controller and then presented from the rect in the view given as parameters.
 *
 *  After a date has been selected the selection block will be called. If the user choses to cancel the selection, the cancel block will be called. If you assigned a delegate the corresponding methods will be called, too.
 *
 *  @warning This method should only be used on iPads. On iPhones please use [show]([RMDateSelectionViewController show]) or [showWithSelectionHandler:andCancelHandler:]([RMDateSelectionViewController showWithSelectionHandler:andCancelHandler:]) instead.
 *
 *  @param aRect The rect in the given view the popover should be presented from.
 *  @param aView The view the popover should be presented from.
 *  @param selectionBlock The block to call when the user selects a date.
 *  @param cancelBlock    The block to call when the user cancels the selection.
 */
- (void)showFromRect:(CGRect)aRect inView:(UIView *)aView withSelectionHandler:(RMDateSelectionBlock)selectionBlock andCancelHandler:(RMDateCancelBlock)cancelBlock;

/// @name Dismissing

/**
 *  This will dismiss the date selection view controller and remove it from the view hierarchy.
 */
- (void)dismiss;

@end
