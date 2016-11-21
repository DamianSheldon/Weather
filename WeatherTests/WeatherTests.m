//
//  WeatherTests.m
//  WeatherTests
//
//  Created by DongMeiliang on 25/10/2016.
//  Copyright © 2016 Meiliang Dong. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface WeatherTests : XCTestCase

@end

@implementation WeatherTests

//- (void)setUp {
//    [super setUp];
//    // Put setup code here. This method is called before the invocation of each test method in the class.
//}
//
//- (void)tearDown {
//    // Put teardown code here. This method is called after the invocation of each test method in the class.
//    [super tearDown];
//}

- (void)testNSLog {
    NSString *longString = @"1.Date and time objects allow you to store references to particular instances in time. You can use date and time objects to perform calculations and comparisons that account for the corner cases of date and time calculations.\n2.Date and time objects allow you to store references to particular instances in time. You can use date and time objects to perform calculations and comparisons that account for the corner cases of date and time calculations.\n3.Date and time objects allow you to store references to particular instances in time. You can use date and time objects to perform calculations and comparisons that account for the corner cases of date and time calculations.\n4.Date and time objects allow you to store references to particular instances in time. You can use date and time objects to perform calculations and comparisons that account for the corner cases of date and time calculations.\n5.Date and time objects allow you to store references to particular instances in time. You can use date and time objects to perform calculations and comparisons that account for the corner cases of date and time calculations.\n6.Date and time objects allow you to store references to particular instances in time. You can use date and time objects to perform calculations and comparisons that account for the corner cases of date and time calculations.\n7.Date and time objects allow you to store references to particular instances in time. You can use date and time objects to perform calculations and comparisons that account for the corner cases of date and time calculations.\n8.Date and time objects allow you to store references to particular instances in time. You can use date and time objects to perform calculations and comparisons that account for the corner cases of date and time calculations.\n9.Date and time objects allow you to store references to particular instances in time. You can use date and time objects to perform calculations and comparisons that account for the corner cases of date and time calculations.\n10Date and time objects allow you to store references to particular instances in time. You can use date and time objects to perform calculations and comparisons that account for the corner cases of date and time calculations.\n11Date and time objects allow you to store references to particular instances in time. You can use date and time objects to perform calculations and comparisons that account for the corner cases of date and time calculations.";
    
    NSLog(@"%@", longString);
    
    XCTAssertTrue(YES);
}

@end
