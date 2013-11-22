//
//  NSDate+Rounding-Tests.m
//  RMDateSelectionViewController-Demo
//
//  Created by Roland Moers on 09.11.13.
//  Copyright (c) 2013 Roland Moers. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface NSDate (Rounding)

- (NSDate *)dateByRoundingToMinutes:(NSInteger)minutes;

@end

@interface NSDate_Rounding_Tests : XCTestCase

@end

@implementation NSDate_Rounding_Tests

- (void)testRounding {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.year = 2013;
    components.month = 11;
    components.day = 9;
    components.hour = 15;
    components.minute = 6;
    
    NSDate *preRoundingDate = [[NSCalendar currentCalendar] dateFromComponents:components];
    NSDate *roundedDate = [preRoundingDate dateByRoundingToMinutes:15];
    
    NSDateComponents *roundedComponents = [[NSCalendar currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:roundedDate];
    
    XCTAssertEqual(roundedComponents.year, components.year, @"");
    XCTAssertEqual(roundedComponents.month, components.month, @"");
    XCTAssertEqual(roundedComponents.day, components.day, @"");
    XCTAssertEqual(roundedComponents.hour, components.hour, @"");
    XCTAssertEqual(roundedComponents.minute, 15, @"");
}

- (void)testLowerRoundingBorder {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.year = 2013;
    components.month = 11;
    components.day = 9;
    components.hour = 15;
    components.minute = 0;
    
    NSDate *preRoundingDate = [[NSCalendar currentCalendar] dateFromComponents:components];
    NSDate *roundedDate = [preRoundingDate dateByRoundingToMinutes:15];
    
    NSDateComponents *roundedComponents = [[NSCalendar currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:roundedDate];
    
    XCTAssertEqual(roundedComponents.year, components.year, @"");
    XCTAssertEqual(roundedComponents.month, components.month, @"");
    XCTAssertEqual(roundedComponents.day, components.day, @"");
    XCTAssertEqual(roundedComponents.hour, components.hour, @"");
    XCTAssertEqual(roundedComponents.minute, 0, @"");
}

- (void)testUpperBorder {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.year = 2013;
    components.month = 11;
    components.day = 9;
    components.hour = 15;
    components.minute = 15;
    
    NSDate *preRoundingDate = [[NSCalendar currentCalendar] dateFromComponents:components];
    NSDate *roundedDate = [preRoundingDate dateByRoundingToMinutes:15];
    
    NSDateComponents *roundedComponents = [[NSCalendar currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:roundedDate];
    
    XCTAssertEqual(roundedComponents.year, components.year, @"");
    XCTAssertEqual(roundedComponents.month, components.month, @"");
    XCTAssertEqual(roundedComponents.day, components.day, @"");
    XCTAssertEqual(roundedComponents.hour, components.hour, @"");
    XCTAssertEqual(roundedComponents.minute, 15, @"");
}

@end
