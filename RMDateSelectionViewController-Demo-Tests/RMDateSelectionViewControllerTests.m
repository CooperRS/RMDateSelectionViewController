//
//  RMDateSelectionViewController_Demo_Tests.m
//  RMDateSelectionViewController-Demo-Tests
//
//  Created by Roland Moers on 21.06.15.
//  Copyright (c) 2015 Roland Moers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "RMDateSelectionViewController.h"

@interface RMDateSelectionViewControllerTests : XCTestCase

@end

@implementation RMDateSelectionViewControllerTests

#pragma mark - Helper
- (RMDateSelectionViewController *)createDateSelectionViewControllerWithStyle:(RMActionControllerStyle)aStyle {
    RMAction *selectAction = [RMAction actionWithTitle:@"Select" style:RMActionStyleDone andHandler:nil];
    RMAction *cancelAction = [RMAction actionWithTitle:@"Cancel" style:RMActionStyleCancel andHandler:nil];
    
    RMDateSelectionViewController *dateSelectionController = [RMDateSelectionViewController actionControllerWithStyle:aStyle];
    dateSelectionController.title = @"Test";
    dateSelectionController.message = @"This is a test message.\nPlease choose a date and press 'Select' or 'Cancel'.";
    
    [dateSelectionController addAction:selectAction];
    [dateSelectionController addAction:cancelAction];
    
    RMAction *nowAction = [RMAction actionWithTitle:@"Now" style:RMActionStyleAdditional andHandler:nil];
    nowAction.dismissesActionController = NO;
    
    [dateSelectionController addAction:nowAction];
    
    return dateSelectionController;
}

- (void)presentAndDismissController:(RMActionController *)aController {
    XCTestExpectation *expectation = [self expectationWithDescription:@"PresentationCompleted"];
    
    BOOL catchedException = NO;
    @try {
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:aController animated:YES completion:^{
            [expectation fulfill];
        }];
    }
    @catch (NSException *exception) {
        catchedException = YES;
    }
    @finally {
        XCTAssertFalse(catchedException);
    }
    
    [self waitForExpectationsWithTimeout:2 handler:nil];
    
    expectation = [self expectationWithDescription:@"DismissalCompleted"];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:YES completion:^{
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:2 handler:nil];
}

#pragma mark - Tests
- (void)testPresentingDateSelectionViewController {
    RMDateSelectionViewController *controller = [self createDateSelectionViewControllerWithStyle:RMActionControllerStyleWhite];
    
    XCTAssertNotNil(controller.contentView);
    XCTAssertEqual(controller.contentView, controller.datePicker);
    XCTAssertTrue([controller.contentView isKindOfClass:[UIDatePicker class]]);
    
    [self presentAndDismissController:controller];
}

@end
