//
//  RMDateSelectionViewController.m
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

#import "RMDateSelectionViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface NSDate (Rounding)

- (NSDate *)dateByRoundingToMinutes:(NSInteger)minutes;

@end

@implementation NSDate (Rounding)

- (NSDate *)dateByRoundingToMinutes:(NSInteger)minutes {
    NSTimeInterval absoluteTime = floor([self timeIntervalSinceReferenceDate]);
    NSTimeInterval minuteInterval = minutes*60;
    
    NSTimeInterval remainder = (absoluteTime - (floor(absoluteTime/minuteInterval)*minuteInterval));
    if(remainder < 60) {
        return self;
    } else {
        NSTimeInterval remainingSeconds = minuteInterval - remainder;
        return [self dateByAddingTimeInterval:remainingSeconds];
    }
}

@end

/*
 * We need RMNonRotatingDateSelectionViewController because Apple decided that a UIWindow adds a black background while rotating.
 * ( http://stackoverflow.com/questions/19782944/blacked-out-interface-rotation-when-using-second-uiwindow-with-rootviewcontrolle )
 *
 * To work around this problem, the root view controller of our window is a RMNonRotatingDateSelectionViewController which cannot rotate.
 * In this case, UIWindow does not add a black background (as it is not rotating any more) and we handle the rotation
 * ourselves.
 */
@interface RMNonRotatingDateSelectionViewController : UIViewController

@property (nonatomic, assign) UIInterfaceOrientation mutableInterfaceOrientation;
@property (nonatomic, assign, readwrite) UIStatusBarStyle preferredStatusBarStyle;
@property (nonatomic, assign) RMDateSelectionViewControllerStatusBarHiddenMode statusBarHiddenMode;

@end

@implementation RMNonRotatingDateSelectionViewController

#pragma mark - Init and Dealloc
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRotate) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    
    [super viewDidDisappear:animated];
}

#pragma mark - Orientation
- (BOOL)shouldAutorotate {
    return NO;
}

- (void)didRotate {
    [self updateUIForInterfaceOrientation:[UIApplication sharedApplication].statusBarOrientation animated:YES];
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)updateUIForInterfaceOrientation:(UIInterfaceOrientation)newOrientation animated:(BOOL)animated {
    CGFloat duration = ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad ? 0.4f : 0.3f);
    BOOL doubleDuration = NO;
    
    CGFloat angle = 0.f;
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    
    if(newOrientation == UIInterfaceOrientationPortrait) {
        angle = 0;
        if(self.mutableInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
            doubleDuration = YES;
    } else if(newOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        angle = M_PI;
        if(self.mutableInterfaceOrientation == UIInterfaceOrientationPortrait)
            doubleDuration = YES;
    } else if(newOrientation == UIInterfaceOrientationLandscapeLeft) {
        angle = -M_PI_2;
        if(self.mutableInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
            doubleDuration = YES;
    } else if(newOrientation == UIInterfaceOrientationLandscapeRight) {
        angle = M_PI_2;
        if(self.mutableInterfaceOrientation == UIInterfaceOrientationLandscapeLeft)
            doubleDuration = YES;
    }
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 && UIInterfaceOrientationIsLandscape(newOrientation) && animated) {
        screenBounds = CGRectMake(0, 0, screenBounds.size.height, screenBounds.size.width);
    }
    
    if(animated) {
        __weak RMNonRotatingDateSelectionViewController *blockself = self;
        [UIView animateWithDuration:(doubleDuration ? duration*2 : duration) delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            blockself.view.transform = CGAffineTransformMakeRotation(angle);
            blockself.view.frame = screenBounds;
        } completion:^(BOOL finished) {
        }];
    } else {
        self.view.transform = CGAffineTransformMakeRotation(angle);
        self.view.frame = screenBounds;
    }
    
    self.mutableInterfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
}

#pragma mark - Status Bar
- (BOOL)prefersStatusBarHidden {
    if(self.statusBarHiddenMode == RMDateSelectionViewControllerStatusBarHiddenModeNever) {
        return NO;
    } else if(self.statusBarHiddenMode == RMDateSelectionViewControllerStatusBarHiddenModeAlways) {
        return YES;
    } else {
        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 && [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
            if(UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation))
                return YES;
            
            return NO;
        } else {
            return NO;
        }
    }
}

@end

#define RM_DATE_PICKER_HEIGHT_PORTRAIT 216
#define RM_DATE_PICKER_HEIGHT_LANDSCAPE 162

typedef enum {
    RMDateSelectionViewControllerPresentationTypeWindow,
    RMDateSelectionViewControllerPresentationTypeViewController,
    RMDateSelectionViewControllerPresentationTypePopover
} RMDateSelectionViewControllerPresentationType;

@interface RMDateSelectionViewController () <UIPopoverControllerDelegate>

@property (nonatomic, assign) RMDateSelectionViewControllerPresentationType presentationType;
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UIViewController *rootViewController;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIPopoverController *popover;

@property (nonatomic, weak) NSLayoutConstraint *xConstraint;
@property (nonatomic, weak) NSLayoutConstraint *yConstraint;
@property (nonatomic, weak) NSLayoutConstraint *widthConstraint;

@property (nonatomic, strong) UIView *titleLabelContainer;
@property (nonatomic, strong, readwrite) UILabel *titleLabel;

@property (nonatomic, strong) UIView *nowButtonContainer;
@property (nonatomic, strong) UIButton *nowButton;

@property (nonatomic, strong) UIView *datePickerContainer;
@property (nonatomic, readwrite, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) NSLayoutConstraint *pickerHeightConstraint;

@property (nonatomic, strong) UIView *cancelAndSelectButtonContainer;
@property (nonatomic, strong) UIView *cancelAndSelectButtonSeperator;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *selectButton;

@property (nonatomic, strong) UIMotionEffectGroup *motionEffectGroup;

@property (nonatomic, copy) RMDateSelectionBlock selectedDateBlock;
@property (nonatomic, copy) RMDateCancelBlock cancelBlock;

@property (nonatomic, assign) BOOL hasBeenDismissed;

@end

@implementation RMDateSelectionViewController

@synthesize selectedBackgroundColor = _selectedBackgroundColor;

#pragma mark - Class
+ (instancetype)dateSelectionController {
    return [[RMDateSelectionViewController alloc] init];
}

static NSString *_localizedNowTitle = @"Now";
static NSString *_localizedCancelTitle = @"Cancel";
static NSString *_localizedSelectTitle = @"Select";

+ (NSString *)localizedTitleForNowButton {
    return _localizedNowTitle;
}

+ (NSString *)localizedTitleForCancelButton {
    return _localizedCancelTitle;
}

+ (NSString *)localizedTitleForSelectButton {
    return _localizedSelectTitle;
}

+ (void)setLocalizedTitleForNowButton:(NSString *)newLocalizedTitle {
    _localizedNowTitle = newLocalizedTitle;
}

+ (void)setLocalizedTitleForCancelButton:(NSString *)newLocalizedTitle {
    _localizedCancelTitle = newLocalizedTitle;
}

+ (void)setLocalizedTitleForSelectButton:(NSString *)newLocalizedTitle {
    _localizedSelectTitle = newLocalizedTitle;
}

+ (void)showDateSelectionViewController:(RMDateSelectionViewController *)aDateSelectionViewController animated:(BOOL)animated {
    if(aDateSelectionViewController.presentationType == RMDateSelectionViewControllerPresentationTypeWindow) {
        [(RMNonRotatingDateSelectionViewController *)aDateSelectionViewController.rootViewController updateUIForInterfaceOrientation:[UIApplication sharedApplication].statusBarOrientation animated:NO];
        [aDateSelectionViewController.window makeKeyAndVisible];
        
        // If we start in landscape mode also update the windows frame to be accurate
        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 && UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
            aDateSelectionViewController.window.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width);
        }
    }
    
    if(aDateSelectionViewController.presentationType != RMDateSelectionViewControllerPresentationTypePopover) {
        aDateSelectionViewController.backgroundView.alpha = 0;
        [aDateSelectionViewController.rootViewController.view addSubview:aDateSelectionViewController.backgroundView];
        
        [aDateSelectionViewController.rootViewController.view addConstraint:[NSLayoutConstraint constraintWithItem:aDateSelectionViewController.backgroundView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:aDateSelectionViewController.rootViewController.view attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
        [aDateSelectionViewController.rootViewController.view addConstraint:[NSLayoutConstraint constraintWithItem:aDateSelectionViewController.backgroundView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:aDateSelectionViewController.rootViewController.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
        [aDateSelectionViewController.rootViewController.view addConstraint:[NSLayoutConstraint constraintWithItem:aDateSelectionViewController.backgroundView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:aDateSelectionViewController.rootViewController.view attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
        [aDateSelectionViewController.rootViewController.view addConstraint:[NSLayoutConstraint constraintWithItem:aDateSelectionViewController.backgroundView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:aDateSelectionViewController.rootViewController.view attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    }
    
    [aDateSelectionViewController willMoveToParentViewController:aDateSelectionViewController.rootViewController];
    [aDateSelectionViewController viewWillAppear:YES];
    
    [aDateSelectionViewController.rootViewController addChildViewController:aDateSelectionViewController];
    [aDateSelectionViewController.rootViewController.view addSubview:aDateSelectionViewController.view];
    
    [aDateSelectionViewController viewDidAppear:YES];
    [aDateSelectionViewController didMoveToParentViewController:aDateSelectionViewController.rootViewController];
    
    //CGFloat height = RM_DATE_SELECTION_VIEW_HEIGHT_PORTAIT;
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        if(UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
            //height = RM_DATE_SELECTION_VIEW_HEIGHT_LANDSCAPE;
            aDateSelectionViewController.pickerHeightConstraint.constant = RM_DATE_PICKER_HEIGHT_LANDSCAPE;
        } else {
            //height = RM_DATE_SELECTION_VIEW_HEIGHT_PORTAIT;
            aDateSelectionViewController.pickerHeightConstraint.constant = RM_DATE_PICKER_HEIGHT_PORTRAIT;
        }
    }
    
    aDateSelectionViewController.xConstraint = [NSLayoutConstraint constraintWithItem:aDateSelectionViewController.view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:aDateSelectionViewController.rootViewController.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    aDateSelectionViewController.yConstraint = [NSLayoutConstraint constraintWithItem:aDateSelectionViewController.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:aDateSelectionViewController.rootViewController.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    aDateSelectionViewController.widthConstraint = [NSLayoutConstraint constraintWithItem:aDateSelectionViewController.view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:aDateSelectionViewController.rootViewController.view attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
    
    [aDateSelectionViewController.rootViewController.view addConstraint:aDateSelectionViewController.xConstraint];
    [aDateSelectionViewController.rootViewController.view addConstraint:aDateSelectionViewController.yConstraint];
    [aDateSelectionViewController.rootViewController.view addConstraint:aDateSelectionViewController.widthConstraint];
    
    [aDateSelectionViewController.rootViewController.view setNeedsUpdateConstraints];
    [aDateSelectionViewController.rootViewController.view layoutIfNeeded];
    
    [aDateSelectionViewController.rootViewController.view removeConstraint:aDateSelectionViewController.yConstraint];
    aDateSelectionViewController.yConstraint = [NSLayoutConstraint constraintWithItem:aDateSelectionViewController.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:aDateSelectionViewController.rootViewController.view attribute:NSLayoutAttributeBottom multiplier:1 constant:-10];
    [aDateSelectionViewController.rootViewController.view addConstraint:aDateSelectionViewController.yConstraint];
    
    [aDateSelectionViewController.rootViewController.view setNeedsUpdateConstraints];
    
    if(animated) {
        CGFloat damping = 1.0f;
        CGFloat duration = 0.3f;
        if(!aDateSelectionViewController.disableBouncingWhenShowing) {
            damping = 0.6f;
            duration = 1.0f;
        }
        
        [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:damping initialSpringVelocity:1 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
            aDateSelectionViewController.backgroundView.alpha = 1;
            
            [aDateSelectionViewController.rootViewController.view layoutIfNeeded];
        } completion:^(BOOL finished) {
        }];
    } else {
        aDateSelectionViewController.backgroundView.alpha = 0;
        
        [aDateSelectionViewController.rootViewController.view layoutIfNeeded];
    }
}

+ (void)dismissDateSelectionViewController:(RMDateSelectionViewController *)aDateSelectionViewController {
    [aDateSelectionViewController.rootViewController.view removeConstraint:aDateSelectionViewController.yConstraint];
    aDateSelectionViewController.yConstraint = [NSLayoutConstraint constraintWithItem:aDateSelectionViewController.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:aDateSelectionViewController.rootViewController.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    [aDateSelectionViewController.rootViewController.view addConstraint:aDateSelectionViewController.yConstraint];
    
    [aDateSelectionViewController.rootViewController.view setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        aDateSelectionViewController.backgroundView.alpha = 0;
        
        [aDateSelectionViewController.rootViewController.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [aDateSelectionViewController willMoveToParentViewController:nil];
        [aDateSelectionViewController viewWillDisappear:YES];
        
        [aDateSelectionViewController.view removeFromSuperview];
        [aDateSelectionViewController removeFromParentViewController];
        
        [aDateSelectionViewController didMoveToParentViewController:nil];
        [aDateSelectionViewController viewDidDisappear:YES];
        
        [aDateSelectionViewController.backgroundView removeFromSuperview];
        aDateSelectionViewController.window = nil;
        aDateSelectionViewController.hasBeenDismissed = NO;
    }];
}

#pragma mark - Init and Dealloc
- (id)init {
    self = [super init];
    if(self) {
        self.blurEffectStyle = UIBlurEffectStyleExtraLight;
        
        [self setupUIElements];
    }
    return self;
}

- (void)setupUIElements {
    //Instantiate elements
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.nowButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
    
    self.cancelAndSelectButtonSeperator = [[UIView alloc] initWithFrame:CGRectZero];
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.selectButton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    //Setup properties of elements
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textColor = [UIColor grayColor];
    self.titleLabel.font = [UIFont systemFontOfSize:12];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.numberOfLines = 0;
    
    [self.nowButton setTitle:[RMDateSelectionViewController localizedTitleForNowButton] forState:UIControlStateNormal];
    [self.nowButton addTarget:self action:@selector(nowButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.nowButton.titleLabel.font = [UIFont systemFontOfSize:[UIFont buttonFontSize]];
    self.nowButton.backgroundColor = [UIColor clearColor];
    self.nowButton.layer.cornerRadius = 4;
    self.nowButton.clipsToBounds = YES;
    self.nowButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.datePicker.layer.cornerRadius = 4;
    self.datePicker.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.cancelButton setTitle:[RMDateSelectionViewController localizedTitleForCancelButton] forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:[UIFont buttonFontSize]];
    self.cancelButton.layer.cornerRadius = 4;
    self.cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.cancelButton setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    
    [self.selectButton setTitle:[RMDateSelectionViewController localizedTitleForSelectButton] forState:UIControlStateNormal];
    [self.selectButton addTarget:self action:@selector(doneButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.selectButton.titleLabel.font = [UIFont boldSystemFontOfSize:[UIFont buttonFontSize]];
    self.selectButton.layer.cornerRadius = 4;
    self.selectButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.selectButton setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
}

- (void)setupContainerElements {
    if(!self.disableBlurEffects) {
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:self.blurEffectStyle];
        UIVibrancyEffect *vibrancy = [UIVibrancyEffect effectForBlurEffect:blur];
        
        UIVisualEffectView *vibrancyView = [[UIVisualEffectView alloc] initWithEffect:vibrancy];
        vibrancyView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        self.titleLabelContainer = [[UIVisualEffectView alloc] initWithEffect:blur];
        [((UIVisualEffectView *)self.titleLabelContainer).contentView addSubview:vibrancyView];
    } else {
        self.titleLabelContainer = [[UIView alloc] initWithFrame:CGRectZero];
    }
    
    if(!self.disableBlurEffects) {
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:self.blurEffectStyle];
        UIVibrancyEffect *vibrancy = [UIVibrancyEffect effectForBlurEffect:blur];
        
        UIVisualEffectView *vibrancyView = [[UIVisualEffectView alloc] initWithEffect:vibrancy];
        vibrancyView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        self.nowButtonContainer = [[UIVisualEffectView alloc] initWithEffect:blur];
        [((UIVisualEffectView *)self.nowButtonContainer).contentView addSubview:vibrancyView];
    } else {
        self.nowButtonContainer = [[UIView alloc] initWithFrame:CGRectZero];
    }
    
    if(!self.disableBlurEffects) {
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:self.blurEffectStyle];
        UIVibrancyEffect *vibrancy = [UIVibrancyEffect effectForBlurEffect:blur];
        
        UIVisualEffectView *vibrancyView = [[UIVisualEffectView alloc] initWithEffect:vibrancy];
        vibrancyView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        self.datePickerContainer = [[UIVisualEffectView alloc] initWithEffect:blur];
        [((UIVisualEffectView *)self.datePickerContainer).contentView addSubview:vibrancyView];
    } else {
        self.datePickerContainer = [[UIView alloc] initWithFrame:CGRectZero];
    }
    
    if(!self.disableBlurEffects) {
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:self.blurEffectStyle];
        UIVibrancyEffect *vibrancy = [UIVibrancyEffect effectForBlurEffect:blur];
        
        UIVisualEffectView *vibrancyView = [[UIVisualEffectView alloc] initWithEffect:vibrancy];
        vibrancyView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        self.cancelAndSelectButtonContainer = [[UIVisualEffectView alloc] initWithEffect:blur];
        [((UIVisualEffectView *)self.cancelAndSelectButtonContainer).contentView addSubview:vibrancyView];
    } else {
        self.cancelAndSelectButtonContainer = [[UIView alloc] initWithFrame:CGRectZero];
    }
    
    if(!self.disableBlurEffects) {
        [[[[[(UIVisualEffectView *)self.titleLabelContainer contentView] subviews] objectAtIndex:0] contentView] addSubview:self.titleLabel];
        [[[[[(UIVisualEffectView *)self.nowButtonContainer contentView] subviews] objectAtIndex:0] contentView] addSubview:self.nowButton];
        [[[[[(UIVisualEffectView *)self.datePickerContainer contentView] subviews] objectAtIndex:0] contentView] addSubview:self.datePicker];
        
        [[[[[(UIVisualEffectView *)self.cancelAndSelectButtonContainer contentView] subviews] objectAtIndex:0] contentView] addSubview:self.cancelAndSelectButtonSeperator];
        [[[[[(UIVisualEffectView *)self.cancelAndSelectButtonContainer contentView] subviews] objectAtIndex:0] contentView] addSubview:self.cancelButton];
        [[[[[(UIVisualEffectView *)self.cancelAndSelectButtonContainer contentView] subviews] objectAtIndex:0] contentView] addSubview:self.selectButton];
        
        self.titleLabelContainer.backgroundColor = [UIColor clearColor];
        self.nowButtonContainer.backgroundColor = [UIColor clearColor];
        self.datePickerContainer.backgroundColor = [UIColor clearColor];
        self.cancelAndSelectButtonContainer.backgroundColor = [UIColor clearColor];
    } else {
        [self.titleLabelContainer addSubview:self.titleLabel];
        [self.nowButtonContainer addSubview:self.nowButton];
        [self.datePickerContainer addSubview:self.datePicker];
        
        [self.cancelAndSelectButtonContainer addSubview:self.cancelAndSelectButtonSeperator];
        [self.cancelAndSelectButtonContainer addSubview:self.cancelButton];
        [self.cancelAndSelectButtonContainer addSubview:self.selectButton];
        
        self.titleLabelContainer.backgroundColor = [UIColor whiteColor];
        self.nowButtonContainer.backgroundColor = [UIColor whiteColor];
        self.datePickerContainer.backgroundColor = [UIColor whiteColor];
        self.cancelAndSelectButtonContainer.backgroundColor = [UIColor whiteColor];
    }
    
    self.titleLabelContainer.layer.cornerRadius = 4;
    self.titleLabelContainer.clipsToBounds = YES;
    self.titleLabelContainer.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.nowButtonContainer.layer.cornerRadius = 4;
    self.nowButtonContainer.clipsToBounds = YES;
    self.nowButtonContainer.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.datePickerContainer.layer.cornerRadius = 4;
    self.datePickerContainer.clipsToBounds = YES;
    self.datePickerContainer.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.cancelAndSelectButtonContainer.layer.cornerRadius = 4;
    self.cancelAndSelectButtonContainer.clipsToBounds = YES;
    self.cancelAndSelectButtonContainer.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.cancelAndSelectButtonSeperator.backgroundColor = [UIColor lightGrayColor];
    self.cancelAndSelectButtonSeperator.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)setupConstraints {
    UIView *pickerContainer = self.datePickerContainer;
    UIView *cancelSelectContainer = self.cancelAndSelectButtonContainer;
    UIView *seperator = self.cancelAndSelectButtonSeperator;
    UIButton *cancel = self.cancelButton;
    UIButton *select = self.selectButton;
    UIDatePicker *picker = self.datePicker;
    UIView *labelContainer = self.titleLabelContainer;
    UILabel *label = self.titleLabel;
    UIButton *now = self.nowButton;
    UIView *nowContainer = self.nowButtonContainer;
    
    NSDictionary *bindingsDict = NSDictionaryOfVariableBindings(cancelSelectContainer, seperator, pickerContainer, cancel, select, picker, labelContainer, label, now, nowContainer);
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(10)-[pickerContainer]-(10)-|" options:0 metrics:nil views:bindingsDict]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(10)-[cancelSelectContainer]-(10)-|" options:0 metrics:nil views:bindingsDict]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[pickerContainer]-(10)-[cancelSelectContainer(44)]-(0)-|" options:0 metrics:nil views:bindingsDict]];
    self.pickerHeightConstraint = [NSLayoutConstraint constraintWithItem:self.datePickerContainer attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:RM_DATE_PICKER_HEIGHT_PORTRAIT];
    [self.view addConstraint:self.pickerHeightConstraint];
    
    [self.datePickerContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[picker]-(0)-|" options:0 metrics:nil views:bindingsDict]];
    [self.cancelAndSelectButtonContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[cancel]-(0)-[seperator(0.5)]-(0)-[select]-(0)-|" options:0 metrics:nil views:bindingsDict]];
    [self.cancelAndSelectButtonContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.cancelAndSelectButtonSeperator attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.cancelAndSelectButtonContainer attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    [self.datePickerContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[picker]-(0)-|" options:0 metrics:nil views:bindingsDict]];
    [self.cancelAndSelectButtonContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[cancel]-(0)-|" options:0 metrics:nil views:bindingsDict]];
    [self.cancelAndSelectButtonContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[seperator]-(0)-|" options:0 metrics:nil views:bindingsDict]];
    [self.cancelAndSelectButtonContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[select]-(0)-|" options:0 metrics:nil views:bindingsDict]];
    
    BOOL showTitle = self.titleLabel.text && self.titleLabel.text.length != 0;
    BOOL showNowButton = !self.hideNowButton;
    
    if(showNowButton) {
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(10)-[nowContainer]-(10)-|" options:0 metrics:nil views:bindingsDict]];
        
        [self.nowButtonContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[now]-(0)-|" options:0 metrics:nil views:bindingsDict]];
        [self.nowButtonContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[now]-(0)-|" options:0 metrics:nil views:bindingsDict]];
    }
    
    if(showTitle) {
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(10)-[labelContainer]-(10)-|" options:0 metrics:nil views:bindingsDict]];
        
        [self.titleLabelContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(10)-[label]-(10)-|" options:0 metrics:nil views:bindingsDict]];
        [self.titleLabelContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(10)-[label]-(10)-|" options:0 metrics:nil views:bindingsDict]];
    }
    
    NSDictionary *metricsDict = @{@"TopMargin": @(self.presentationType == RMDateSelectionViewControllerPresentationTypePopover ? 10 : 0)};
    
    if(showNowButton && showTitle) {
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(TopMargin)-[labelContainer]-(10)-[now(44)]-(10)-[pickerContainer]" options:0 metrics:metricsDict views:bindingsDict]];
    } else if(showNowButton && !showTitle) {
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(TopMargin)-[nowContainer(44)]-(10)-[pickerContainer]" options:0 metrics:metricsDict views:bindingsDict]];
    } else if(!showNowButton && showTitle) {
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(TopMargin)-[labelContainer]-(10)-[pickerContainer]" options:0 metrics:metricsDict views:bindingsDict]];
    } else if(!showNowButton && !showTitle) {
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(TopMargin)-[pickerContainer]" options:0 metrics:metricsDict views:bindingsDict]];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    self.view.backgroundColor = [UIColor clearColor];
    self.view.layer.masksToBounds = YES;
    
    [self setupContainerElements];
    
    if(self.titleLabel.text && self.titleLabel.text.length != 0)
        [self.view addSubview:self.titleLabelContainer];
    
    if(!self.hideNowButton)
        [self.view addSubview:self.nowButtonContainer];
    
    [self.view addSubview:self.datePickerContainer];
    [self.view addSubview:self.cancelAndSelectButtonContainer];
    
    [self setupConstraints];
    
    if(self.disableBlurEffects) {
        if(self.tintColor) {
            self.nowButton.tintColor = self.tintColor;
            self.cancelButton.tintColor = self.tintColor;
            self.selectButton.tintColor = self.tintColor;
        } else {
            self.nowButton.tintColor = [UIColor colorWithRed:0 green:122./255. blue:1 alpha:1];
            self.cancelButton.tintColor = [UIColor colorWithRed:0 green:122./255. blue:1 alpha:1];
            self.selectButton.tintColor = [UIColor colorWithRed:0 green:122./255. blue:1 alpha:1];
        }
    }
    
    if(self.backgroundColor) {
        if(!self.disableBlurEffects) {
            [((UIVisualEffectView *)self.titleLabelContainer).contentView setBackgroundColor:self.backgroundColor];
            [((UIVisualEffectView *)self.nowButtonContainer).contentView setBackgroundColor:self.backgroundColor];
            [((UIVisualEffectView *)self.datePickerContainer).contentView setBackgroundColor:self.backgroundColor];
            [((UIVisualEffectView *)self.cancelAndSelectButtonContainer).contentView setBackgroundColor:self.backgroundColor];
        } else {
            self.titleLabelContainer.backgroundColor = self.backgroundColor;
            self.nowButtonContainer.backgroundColor = self.backgroundColor;
            self.datePickerContainer.backgroundColor = self.backgroundColor;
            self.cancelAndSelectButtonContainer.backgroundColor = self.backgroundColor;
        }
    }
    
    if(self.selectedBackgroundColor) {
        if(!self.disableBlurEffects) {
            [self.nowButton setBackgroundImage:[self imageWithColor:[self.selectedBackgroundColor colorWithAlphaComponent:0.3]] forState:UIControlStateHighlighted];
            [self.cancelButton setBackgroundImage:[self imageWithColor:[self.selectedBackgroundColor colorWithAlphaComponent:0.3]] forState:UIControlStateHighlighted];
            [self.selectButton setBackgroundImage:[self imageWithColor:[self.selectedBackgroundColor colorWithAlphaComponent:0.3]] forState:UIControlStateHighlighted];
        } else {
            [self.nowButton setBackgroundImage:[self imageWithColor:self.selectedBackgroundColor] forState:UIControlStateHighlighted];
            [self.cancelButton setBackgroundImage:[self imageWithColor:self.selectedBackgroundColor] forState:UIControlStateHighlighted];
            [self.selectButton setBackgroundImage:[self imageWithColor:self.selectedBackgroundColor] forState:UIControlStateHighlighted];
        }
    }
    
    if(!self.disableMotionEffects)
        [self addMotionEffects];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRotate) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    
    [super viewDidDisappear:animated];
}

#pragma mark - Orientation
- (void)didRotate {
    NSTimeInterval duration = 0.4;
    
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        duration = 0.3;
        
        if(UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
            self.pickerHeightConstraint.constant = RM_DATE_PICKER_HEIGHT_LANDSCAPE;
        } else {
            self.pickerHeightConstraint.constant = RM_DATE_PICKER_HEIGHT_PORTRAIT;
        }
        
        [self.datePicker setNeedsUpdateConstraints];
        [self.datePicker layoutIfNeeded];
    }
    
    [self.rootViewController.view setNeedsUpdateConstraints];
    __weak RMDateSelectionViewController *blockself = self;
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        [blockself.rootViewController.view layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}

#pragma mark - Helper
- (void)addMotionEffects {
    [self.view addMotionEffect:self.motionEffectGroup];
}

- (void)removeMotionEffects {
    [self.view removeMotionEffect:self.motionEffectGroup];
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - Properties
- (BOOL)disableBlurEffects {
    if(NSClassFromString(@"UIBlurEffect") && NSClassFromString(@"UIVibrancyEffect") && NSClassFromString(@"UIVisualEffectView") && !_disableBlurEffects) {
        return NO;
    }
    
    return YES;
}

- (void)setDisableMotionEffects:(BOOL)newDisableMotionEffects {
    if(_disableMotionEffects != newDisableMotionEffects) {
        _disableMotionEffects = newDisableMotionEffects;
        
        if([self isViewLoaded]) {
            if(newDisableMotionEffects) {
                [self removeMotionEffects];
            } else {
                [self addMotionEffects];
            }
        }
    }
}

- (UIMotionEffectGroup *)motionEffectGroup {
    if(!_motionEffectGroup) {
        UIInterpolatingMotionEffect *verticalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
        verticalMotionEffect.minimumRelativeValue = @(-10);
        verticalMotionEffect.maximumRelativeValue = @(10);
        
        UIInterpolatingMotionEffect *horizontalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
        horizontalMotionEffect.minimumRelativeValue = @(-10);
        horizontalMotionEffect.maximumRelativeValue = @(10);
        
        _motionEffectGroup = [UIMotionEffectGroup new];
        _motionEffectGroup.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];
    }
    
    return _motionEffectGroup;
}

- (UIWindow *)window {
    if(!_window) {
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        _window.windowLevel = UIWindowLevelStatusBar;
        
        RMNonRotatingDateSelectionViewController *rootViewController = [[RMNonRotatingDateSelectionViewController alloc] init];
        rootViewController.preferredStatusBarStyle = self.preferredStatusBarStyle;
        rootViewController.statusBarHiddenMode = self.statusBarHiddenMode;
        _window.rootViewController = rootViewController;
    }
    
    return _window;
}

- (UIView *)backgroundView {
    if(!_backgroundView) {
        self.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        _backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        _backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewTapped:)];
        [_backgroundView addGestureRecognizer:tapRecognizer];
    }
    
    return _backgroundView;
}

- (void)setTintColor:(UIColor *)newTintColor {
    if(_tintColor != newTintColor) {
        _tintColor = newTintColor;
        
        if(!self.disableBlurEffects) {
            self.datePicker.tintColor = newTintColor;
        }
        
        self.nowButton.tintColor = newTintColor;
        self.cancelButton.tintColor = newTintColor;
        self.selectButton.tintColor = newTintColor;
    }
}

- (void)setBackgroundColor:(UIColor *)newBackgroundColor {
    if(_backgroundColor != newBackgroundColor) {
        _backgroundColor = newBackgroundColor;
        
        if([self isViewLoaded]) {
            if(!self.disableBlurEffects &&
               [self.titleLabelContainer isKindOfClass:[UIVisualEffectView class]] &&
               [self.nowButtonContainer isKindOfClass:[UIVisualEffectView class]] &&
               [self.datePickerContainer isKindOfClass:[UIVisualEffectView class]] &&
               [self.cancelAndSelectButtonContainer isKindOfClass:[UIVisualEffectView class]]) {
                [((UIVisualEffectView *)self.titleLabelContainer).contentView setBackgroundColor:newBackgroundColor];
                [((UIVisualEffectView *)self.nowButtonContainer).contentView setBackgroundColor:newBackgroundColor];
                [((UIVisualEffectView *)self.datePickerContainer).contentView setBackgroundColor:newBackgroundColor];
                [((UIVisualEffectView *)self.cancelAndSelectButtonContainer).contentView setBackgroundColor:newBackgroundColor];
            } else {
                self.titleLabelContainer.backgroundColor = newBackgroundColor;
                self.nowButtonContainer.backgroundColor = newBackgroundColor;
                self.datePickerContainer.backgroundColor = newBackgroundColor;
                self.cancelAndSelectButtonContainer.backgroundColor = newBackgroundColor;
            }
        }
    }
}

- (UIColor *)selectedBackgroundColor {
    if(!_selectedBackgroundColor) {
        self.selectedBackgroundColor = [UIColor colorWithWhite:230./255. alpha:1];
    }
    
    return _selectedBackgroundColor;
}

- (void)setSelectedBackgroundColor:(UIColor *)newSelectedBackgroundColor {
    if(_selectedBackgroundColor != newSelectedBackgroundColor) {
        _selectedBackgroundColor = newSelectedBackgroundColor;
        
        if(!self.disableBlurEffects) {
            [self.nowButton setBackgroundImage:[self imageWithColor:[newSelectedBackgroundColor colorWithAlphaComponent:0.3]] forState:UIControlStateHighlighted];
            [self.cancelButton setBackgroundImage:[self imageWithColor:[newSelectedBackgroundColor colorWithAlphaComponent:0.3]] forState:UIControlStateHighlighted];
            [self.selectButton setBackgroundImage:[self imageWithColor:[newSelectedBackgroundColor colorWithAlphaComponent:0.3]] forState:UIControlStateHighlighted];
        } else {
            [self.nowButton setBackgroundImage:[self imageWithColor:newSelectedBackgroundColor] forState:UIControlStateHighlighted];
            [self.cancelButton setBackgroundImage:[self imageWithColor:newSelectedBackgroundColor] forState:UIControlStateHighlighted];
            [self.selectButton setBackgroundImage:[self imageWithColor:newSelectedBackgroundColor] forState:UIControlStateHighlighted];
        }
    }
}

#pragma mark - Presenting
- (void)show {
    [self showWithSelectionHandler:nil andCancelHandler:nil];
}

- (void)showWithSelectionHandler:(RMDateSelectionBlock)selectionBlock andCancelHandler:(RMDateCancelBlock)cancelBlock {
    self.selectedDateBlock = selectionBlock;
    self.cancelBlock = cancelBlock;
    
    self.presentationType = RMDateSelectionViewControllerPresentationTypeWindow;
    self.rootViewController = self.window.rootViewController;
    
    [RMDateSelectionViewController showDateSelectionViewController:self animated:YES];
}

- (void)showFromViewController:(UIViewController *)aViewController {
    [self showFromViewController:aViewController withSelectionHandler:nil andCancelHandler:nil];
}

- (void)showFromViewController:(UIViewController *)aViewController withSelectionHandler:(RMDateSelectionBlock)selectionBlock andCancelHandler:(RMDateCancelBlock)cancelBlock {
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        if([aViewController isKindOfClass:[UITableViewController class]]) {
            if(aViewController.navigationController) {
                NSLog(@"Warning: -[RMDateSelectionViewController %@] has been called with an instance of UITableViewController as argument. Trying to use the navigation controller of the UITableViewController instance instead.", NSStringFromSelector(_cmd));
                aViewController = aViewController.navigationController;
            } else {
                NSLog(@"Error: -[RMDateSelectionViewController %@] has been called with an instance of UITableViewController as argument. Showing the date selection view controller from an instance of UITableViewController is not possible due to some internals of UIKit. To prevent your app from crashing, showing the date selection view controller will be canceled.", NSStringFromSelector(_cmd));
                return;
            }
        }
        
        self.selectedDateBlock = selectionBlock;
        self.cancelBlock = cancelBlock;
        
        self.presentationType = RMDateSelectionViewControllerPresentationTypeViewController;
        self.rootViewController = aViewController;
        
        [RMDateSelectionViewController showDateSelectionViewController:self animated:YES];
    } else {
        NSLog(@"Warning: -[RMDateSelectionViewController %@] has been called on an iPhone. This method is iPad only so we will use -[RMDateSelectionViewController %@] instead.", NSStringFromSelector(_cmd), NSStringFromSelector(@selector(showWithSelectionHandler:andCancelHandler:)));
        [self showWithSelectionHandler:selectionBlock andCancelHandler:cancelBlock];
    }
}

- (void)showFromRect:(CGRect)aRect inView:(UIView *)aView {
    [self showFromRect:aRect inView:aView withSelectionHandler:nil andCancelHandler:nil];
}

- (void)showFromRect:(CGRect)aRect inView:(UIView *)aView withSelectionHandler:(RMDateSelectionBlock)selectionBlock andCancelHandler:(RMDateCancelBlock)cancelBlock {
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.selectedDateBlock = selectionBlock;
        self.cancelBlock = cancelBlock;
        
        self.presentationType = RMDateSelectionViewControllerPresentationTypePopover;
        CGSize fittingSize = [self.view systemLayoutSizeFittingSize:CGSizeMake(0, 0)];
        
        self.popover = [[UIPopoverController alloc] initWithContentViewController:self];
        self.popover.delegate = self;
        self.popover.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        self.popover.popoverContentSize = CGSizeMake(fittingSize.width, fittingSize.height+10);
        
        [self.popover presentPopoverFromRect:aRect inView:aView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    } else {
        NSLog(@"Warning: -[RMDateSelectionViewController %@] has been called on an iPhone. This method is iPad only so we will use -[RMDateSelectionViewController %@] instead.", NSStringFromSelector(_cmd), NSStringFromSelector(@selector(showWithSelectionHandler:andCancelHandler:)));
        [self showWithSelectionHandler:selectionBlock andCancelHandler:cancelBlock];
    }
}

- (void)dismiss {
    if(self.presentationType == RMDateSelectionViewControllerPresentationTypePopover && [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.popover.delegate = nil;
        
        [self.popover dismissPopoverAnimated:YES];
        self.popover = nil;
    } else {
        [RMDateSelectionViewController dismissDateSelectionViewController:self];
    }
}

#pragma mark - Actions
- (IBAction)doneButtonPressed:(id)sender {
    if(!self.hasBeenDismissed) {
        self.hasBeenDismissed = YES;
        
        [self.delegate dateSelectionViewController:self didSelectDate:self.datePicker.date];
        if (self.selectedDateBlock) {
            self.selectedDateBlock(self, self.datePicker.date);
        }
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.1];
    }
}

- (IBAction)cancelButtonPressed:(id)sender {
    if(!self.hasBeenDismissed) {
        self.hasBeenDismissed = YES;
        
        if ([self.delegate respondsToSelector:@selector(dateSelectionViewControllerDidCancel:)]) {
          [self.delegate dateSelectionViewControllerDidCancel:self];
        }
      
        if (self.cancelBlock) {
            self.cancelBlock(self);
        }
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.1];
    }
}

- (IBAction)nowButtonPressed:(id)sender {
    if([self.delegate respondsToSelector:@selector(dateSelectionViewControllerNowButtonPressed:)]) {
        [self.delegate dateSelectionViewControllerNowButtonPressed:self];
    } else {
        [self.datePicker setDate:[[NSDate date] dateByRoundingToMinutes:self.datePicker.minuteInterval]];
    }
}

- (IBAction)backgroundViewTapped:(UIGestureRecognizer *)sender {
    if(!self.backgroundTapsDisabled && !self.hasBeenDismissed) {
        self.hasBeenDismissed = YES;
      
        if ([self.delegate respondsToSelector:@selector(dateSelectionViewControllerDidCancel:)]) {
            [self.delegate dateSelectionViewControllerDidCancel:self];
        }
      
        if (self.cancelBlock) {
            self.cancelBlock(self);
        }
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.1];
    }
}

#pragma mark - UIPopoverController Delegates
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    if(!self.hasBeenDismissed) {
        self.hasBeenDismissed = YES;
        
        if ([self.delegate respondsToSelector:@selector(dateSelectionViewControllerDidCancel:)]) {
          [self.delegate dateSelectionViewControllerDidCancel:self];
        }
        if (self.cancelBlock) {
            self.cancelBlock(self);
        }
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.1];
    }
    
    self.popover = nil;
}

@end
