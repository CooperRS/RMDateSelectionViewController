//
//  RMDateSelectionViewController.m
//  Transrapid
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

#define RM_DATE_SELECTION_VIEW_HEIGHT_PORTAIT 330
#define RM_DATE_SELECTION_VIEW_HEIGHT_LANDSCAPE 275

#define RM_DATE_SELECTION_VIEW_WIDTH_PORTRAIT 300
#define RM_DATE_SELECTION_VIEW_WIDTH_LANDSCAPE 548

#define RM_DATE_SELECTION_VIEW_MARGIN 10

#define RM_DATE_PICKER_HEIGHT_PORTRAIT 216
#define RM_DATE_PICKER_HEIGHT_LANDSCAPE 162

#import "RMDateSelectionViewController.h"

@interface RMDateSelectionViewController ()

@property (nonatomic, weak) UIViewController *rootViewController;

@property (nonatomic, weak) NSLayoutConstraint *xConstraint;
@property (nonatomic, weak) NSLayoutConstraint *yConstraint;
@property (nonatomic, weak) NSLayoutConstraint *widthConstraint;
@property (nonatomic, weak) NSLayoutConstraint *heightConstraint;

@property (weak) IBOutlet UIButton *nowButton;

@property (weak) IBOutlet UIView *datePickerContainer;
@property (weak, readwrite) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *pickerHeightConstraint;

@property (weak) IBOutlet UIView *cancelAndSelectButtonContainer;
@property (weak) IBOutlet UIButton *cancelButton;
@property (weak) IBOutlet UIButton *selectButton;

@property (nonatomic, strong) UIView *backgroundView;

@end

@implementation RMDateSelectionViewController

#pragma mark - Class
+ (instancetype)dateSelectionController {
    return [[RMDateSelectionViewController alloc] initWithNibName:@"RMDateSelectionViewController" bundle:nil];
}

+ (void)showDateSelectionViewController:(RMDateSelectionViewController *)aViewController fromViewController:(UIViewController *)rootViewController {
    aViewController.backgroundView.alpha = 0;
    [rootViewController.view addSubview:aViewController.backgroundView];
    
    [rootViewController.view addConstraint:[NSLayoutConstraint constraintWithItem:aViewController.backgroundView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:rootViewController.view attribute:NSLayoutAttributeTop multiplier:0 constant:0]];
    [rootViewController.view addConstraint:[NSLayoutConstraint constraintWithItem:aViewController.backgroundView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:rootViewController.view attribute:NSLayoutAttributeLeading multiplier:0 constant:0]];
    [rootViewController.view addConstraint:[NSLayoutConstraint constraintWithItem:aViewController.backgroundView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:rootViewController.view attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [rootViewController.view addConstraint:[NSLayoutConstraint constraintWithItem:aViewController.backgroundView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:rootViewController.view attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    
    [aViewController willMoveToParentViewController:rootViewController];
    [aViewController viewWillAppear:YES];
    
    [rootViewController addChildViewController:aViewController];
    [rootViewController.view addSubview:aViewController.view];
    
    [aViewController viewDidAppear:YES];
    [aViewController didMoveToParentViewController:rootViewController];
    
    CGFloat height = RM_DATE_SELECTION_VIEW_HEIGHT_PORTAIT;
    //CGFloat width = aViewController.view.frame.size.width-20;
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        if(UIInterfaceOrientationIsLandscape(rootViewController.interfaceOrientation)) {
            height = RM_DATE_SELECTION_VIEW_HEIGHT_LANDSCAPE;
            //width = RM_DATE_SELECTION_VIEW_WIDTH_LANDSCAPE;
            
            aViewController.pickerHeightConstraint.constant = RM_DATE_PICKER_HEIGHT_LANDSCAPE;
        } else {
            height = RM_DATE_SELECTION_VIEW_HEIGHT_PORTAIT;
            //width = RM_DATE_SELECTION_VIEW_WIDTH_PORTRAIT;
            
            aViewController.pickerHeightConstraint.constant = RM_DATE_PICKER_HEIGHT_PORTRAIT;
        }
    }
    
    aViewController.xConstraint = [NSLayoutConstraint constraintWithItem:aViewController.view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:rootViewController.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    aViewController.yConstraint = [NSLayoutConstraint constraintWithItem:aViewController.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:rootViewController.view attribute:NSLayoutAttributeBottom multiplier:1 constant:height];
    //aViewController.widthConstraint = [NSLayoutConstraint constraintWithItem:aViewController.view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:width];
    aViewController.widthConstraint = [NSLayoutConstraint constraintWithItem:aViewController.view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:rootViewController.view attribute:NSLayoutAttributeWidth multiplier:1 constant:-20];
    aViewController.heightConstraint = [NSLayoutConstraint constraintWithItem:aViewController.view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:height];
    
    [rootViewController.view addConstraint:aViewController.xConstraint];
    [rootViewController.view addConstraint:aViewController.yConstraint];
    [rootViewController.view addConstraint:aViewController.widthConstraint];
    [rootViewController.view addConstraint:aViewController.heightConstraint];
    
    [rootViewController.view setNeedsUpdateConstraints];
    [rootViewController.view layoutIfNeeded];
    
    aViewController.yConstraint.constant = -10;
    [rootViewController.view setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:0.3 animations:^{
        aViewController.backgroundView.alpha = 1;
        
        [rootViewController.view layoutIfNeeded];
    }];
}

+ (void)dismissDateSelectionViewController:(RMDateSelectionViewController *)aViewController fromViewController:(UIViewController *)rootViewController {
    aViewController.yConstraint.constant = RM_DATE_SELECTION_VIEW_HEIGHT_PORTAIT;
    [rootViewController.view setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:0.3 animations:^{
        aViewController.backgroundView.alpha = 0;
        
        [rootViewController.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [aViewController willMoveToParentViewController:nil];
        [aViewController viewWillDisappear:YES];
        
        [aViewController.view removeFromSuperview];
        [aViewController removeFromParentViewController];
        
        [aViewController didMoveToParentViewController:nil];
        [aViewController viewDidDisappear:YES];
        
        [aViewController.backgroundView removeFromSuperview];
    }];
}

#pragma mark - Init and Dealloc
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    self.view.backgroundColor = [UIColor clearColor];
    
    self.view.layer.masksToBounds = YES;
    
    self.nowButton.layer.cornerRadius = 5;
    
    self.datePickerContainer.layer.cornerRadius = 5;
    self.datePicker.layer.cornerRadius = 5;
    
    self.cancelAndSelectButtonContainer.layer.cornerRadius = 5;
    self.cancelButton.layer.cornerRadius = 5;
    self.selectButton.layer.cornerRadius = 5;
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
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        if(UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
            self.heightConstraint.constant = RM_DATE_SELECTION_VIEW_HEIGHT_LANDSCAPE;
            //self.widthConstraint.constant = RM_DATE_SELECTION_VIEW_WIDTH_LANDSCAPE;
            
            self.pickerHeightConstraint.constant = RM_DATE_PICKER_HEIGHT_LANDSCAPE;
        } else {
            self.heightConstraint.constant = RM_DATE_SELECTION_VIEW_HEIGHT_PORTAIT;
            //self.widthConstraint.constant = RM_DATE_SELECTION_VIEW_WIDTH_PORTRAIT;
            
            self.pickerHeightConstraint.constant = RM_DATE_PICKER_HEIGHT_PORTRAIT;
        }
        
        [self.datePicker setNeedsUpdateConstraints];
        [self.datePicker layoutIfNeeded];
        
        [self.rootViewController.view setNeedsUpdateConstraints];
        __weak RMDateSelectionViewController *blockself = self;
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [blockself.rootViewController.view layoutIfNeeded];
        } completion:^(BOOL finished) {
        }];
    }
}

#pragma mark - Properties
- (UIView *)backgroundView {
    if(!_backgroundView) {
        self.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        _backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        _backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    return _backgroundView;
}

#pragma mark - Presenting
- (void)show {
    [self showFromViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

- (void)showFromViewController:(UIViewController *)aViewController {
    self.rootViewController = aViewController;
    [RMDateSelectionViewController showDateSelectionViewController:self fromViewController:aViewController];
}

- (void)dismiss {
    [RMDateSelectionViewController dismissDateSelectionViewController:self fromViewController:self.rootViewController];
}

#pragma mark - Actions
- (IBAction)doneButtonPressed:(id)sender {
    [self.delegate dateSelectionViewController:self didSelectDate:self.datePicker.date];
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.1];
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self.delegate dateSelectionViewControllerDidCancel:self];
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.1];
}

- (IBAction)nowButtonPressed:(id)sender {
    [self.datePicker setDate:[NSDate date] animated:YES];
}

@end
