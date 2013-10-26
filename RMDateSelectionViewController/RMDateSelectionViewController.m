//
//  RMDateSelectionViewController.m
//  Transrapid
//
//  Created by Roland Moers on 26.10.13.
//  Copyright (c) 2013 Roland Moers. All rights reserved.
//

#define RM_DATE_SELECTION_VIEW_HEIGHT_PORTAIT 303
#define RM_DATE_SELECTION_VIEW_HEIGHT_LANDSCAPE 248
#define RM_DATE_SELECTION_VIEW_WIDTH 300
#define RM_DATE_SELECTION_VIEW_MARGIN 10

#import "RMDateSelectionViewController.h"

@interface RMDateSelectionViewController ()

@property (nonatomic, weak) UIViewController *rootViewController;

@property (weak) IBOutlet UIDatePicker *datePicker;

@property (nonatomic, weak) NSLayoutConstraint *xConstraint;
@property (nonatomic, weak) NSLayoutConstraint *yConstraint;
@property (nonatomic, weak) NSLayoutConstraint *widthConstraint;
@property (nonatomic, weak) NSLayoutConstraint *heightConstraint;

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
    
    aViewController.view.layer.cornerRadius = 5;
    aViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    
    [aViewController willMoveToParentViewController:rootViewController];
    [aViewController viewWillAppear:YES];
    
    [rootViewController addChildViewController:aViewController];
    [rootViewController.view addSubview:aViewController.view];
    
    [aViewController viewDidAppear:YES];
    [aViewController didMoveToParentViewController:rootViewController];
    
    CGFloat height = RM_DATE_SELECTION_VIEW_HEIGHT_PORTAIT;
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        height = UIInterfaceOrientationIsLandscape(rootViewController.interfaceOrientation) ? RM_DATE_SELECTION_VIEW_HEIGHT_LANDSCAPE : RM_DATE_SELECTION_VIEW_HEIGHT_PORTAIT;
    }
    
    aViewController.xConstraint = [NSLayoutConstraint constraintWithItem:aViewController.view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:rootViewController.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    aViewController.yConstraint = [NSLayoutConstraint constraintWithItem:aViewController.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:rootViewController.view attribute:NSLayoutAttributeBottom multiplier:1 constant:height];
    aViewController.widthConstraint = [NSLayoutConstraint constraintWithItem:aViewController.view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:RM_DATE_SELECTION_VIEW_WIDTH];
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
    
    self.datePicker.datePickerMode = self.mode;
    self.datePicker.date = self.originalDate;
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
