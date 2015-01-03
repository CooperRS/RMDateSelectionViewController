//
//  RMPresentationTests.m
//  RMDateSelectionViewController-Demo
//
//  Created by Roland Moers on 03.01.15.
//  Copyright (c) 2015 Roland Moers. All rights reserved.
//

#import <KIF/KIF.h>

@interface NSDate (Rounding)

- (NSDate *)dateByRoundingToMinutes:(NSInteger)minutes;

@end

@interface RMPresentationTests : KIFTestCase

@end

@implementation RMPresentationTests

- (void)beforeEach {
    [tester setOn:NO forSwitchWithAccessibilityLabel:@"BlackVersion"];
    
    [tester setOn:YES forSwitchWithAccessibilityLabel:@"BlurEffects"];
    [tester setOn:YES forSwitchWithAccessibilityLabel:@"MotionEffects"];
    [tester setOn:YES forSwitchWithAccessibilityLabel:@"BouncingEffects"];
    
    UIView *selectedDateLabelAsUIView = [tester waitForViewWithAccessibilityLabel:@"SelectedDate"];
    XCTAssertTrue([selectedDateLabelAsUIView isKindOfClass:[UILabel class]]);
    if([selectedDateLabelAsUIView isKindOfClass:[UILabel class]]) {
        UILabel *selectedDateLabel = (UILabel *)selectedDateLabelAsUIView;
        selectedDateLabel.text = @"1/1/01, 1:00 AM";
    }
}

- (void)testSelectingDate {
    [tester tapViewWithAccessibilityLabel:@"ShowDateSelection"];
    
    UIView *datePickerAsUIView = [tester waitForViewWithAccessibilityLabel:@"DatePicker"];
    
    XCTAssertTrue([datePickerAsUIView isKindOfClass:[UIDatePicker class]]);
    if([datePickerAsUIView isKindOfClass:[UIDatePicker class]]) {
        UIDatePicker *datePicker = (UIDatePicker *)datePickerAsUIView;
        
        NSDateComponents *components = [[NSDateComponents alloc] init];
        components.year = 2015;
        components.month = 1;
        components.day = 3;
        components.hour = 15;
        components.minute = 12;
        components.second = 0;
        
        NSDate *preRoundingDate = [[NSCalendar currentCalendar] dateFromComponents:components];
        NSDate *roundedDate = [preRoundingDate dateByRoundingToMinutes:5];
        [datePicker setDate:roundedDate animated:NO];
    }
    
    [tester tapViewWithAccessibilityLabel:@"SelectButton"];
    
    UIView *selectedDateLabelAsUIView = [tester waitForViewWithAccessibilityLabel:@"SelectedDate"];
    XCTAssertTrue([selectedDateLabelAsUIView isKindOfClass:[UILabel class]]);
    if([selectedDateLabelAsUIView isKindOfClass:[UILabel class]]) {
        UILabel *selectedDateLabel = (UILabel *)selectedDateLabelAsUIView;
        XCTAssertTrue([selectedDateLabel.text isEqualToString:@"1/3/15, 3:15 PM"]);
    }
}

- (void)testCancelingDateSelection {
    [tester tapViewWithAccessibilityLabel:@"ShowDateSelection"];
    
    UIView *datePickerAsUIView = [tester waitForViewWithAccessibilityLabel:@"DatePicker"];
    
    XCTAssertTrue([datePickerAsUIView isKindOfClass:[UIDatePicker class]]);
    if([datePickerAsUIView isKindOfClass:[UIDatePicker class]]) {
        UIDatePicker *datePicker = (UIDatePicker *)datePickerAsUIView;
        
        NSDateComponents *components = [[NSDateComponents alloc] init];
        components.year = 2015;
        components.month = 1;
        components.day = 3;
        components.hour = 15;
        components.minute = 12;
        components.second = 0;
        
        NSDate *preRoundingDate = [[NSCalendar currentCalendar] dateFromComponents:components];
        NSDate *roundedDate = [preRoundingDate dateByRoundingToMinutes:5];
        [datePicker setDate:roundedDate animated:NO];
    }
    
    [tester tapViewWithAccessibilityLabel:@"CancelButton"];
    
    UIView *selectedDateLabelAsUIView = [tester waitForViewWithAccessibilityLabel:@"SelectedDate"];
    XCTAssertTrue([selectedDateLabelAsUIView isKindOfClass:[UILabel class]]);
    if([selectedDateLabelAsUIView isKindOfClass:[UILabel class]]) {
        UILabel *selectedDateLabel = (UILabel *)selectedDateLabelAsUIView;
        XCTAssertTrue([selectedDateLabel.text isEqualToString:@"1/1/01, 1:00 AM"]);
    }
}

- (void)testPresentingWhiteDateSelection {
    [tester tapViewWithAccessibilityLabel:@"ShowDateSelection"];
    [tester tapViewWithAccessibilityLabel:@"SelectButton"];
}

- (void)testPresentingBlackDateSelection {
    [tester setOn:YES forSwitchWithAccessibilityLabel:@"BlackVersion"];
    
    [tester tapViewWithAccessibilityLabel:@"ShowDateSelection"];
    [tester tapViewWithAccessibilityLabel:@"SelectButton"];
}

- (void)testPresentingWithDisabledEffects {
    [tester setOn:NO forSwitchWithAccessibilityLabel:@"BlurEffects"];
    [tester setOn:NO forSwitchWithAccessibilityLabel:@"MotionEffects"];
    [tester setOn:NO forSwitchWithAccessibilityLabel:@"BouncingEffects"];
    
    [tester tapViewWithAccessibilityLabel:@"ShowDateSelection"];
    [tester tapViewWithAccessibilityLabel:@"SelectButton"];
}

- (void)testPresentingWithDisabledBlurEffects {
    [tester setOn:NO forSwitchWithAccessibilityLabel:@"BlurEffects"];
    
    [tester tapViewWithAccessibilityLabel:@"ShowDateSelection"];
    [tester tapViewWithAccessibilityLabel:@"SelectButton"];
}

- (void)testPresentingWithDisabledMotionEffects {
    [tester setOn:NO forSwitchWithAccessibilityLabel:@"MotionEffects"];
    
    [tester tapViewWithAccessibilityLabel:@"ShowDateSelection"];
    [tester tapViewWithAccessibilityLabel:@"SelectButton"];
}

- (void)testPresentingWithDisabledBouncingEffects {
    [tester setOn:NO forSwitchWithAccessibilityLabel:@"BouncingEffects"];
    
    [tester tapViewWithAccessibilityLabel:@"ShowDateSelection"];
    [tester tapViewWithAccessibilityLabel:@"SelectButton"];
}

@end
