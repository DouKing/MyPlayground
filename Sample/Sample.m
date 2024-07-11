//===----------------------------------------------------------*- Swift -*-===//
//
// Created by wuyikai on 2024/4/17.
// Copyright © 2024 wuyikai. All rights reserved.
//
//===----------------------------------------------------------------------===//

#import <XCTest/XCTest.h>

@interface Sample : XCTestCase

@end

@implementation Sample

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    NSArray *array = @[@1, @2, @3, @4, @5];
    for (id element in array.reverseObjectEnumerator) {
        NSLog(@"%@", element);
        NSLog(@"%d", arc4random_uniform(5));
    }
}

- (void)testPerformanceExample {
    NSString *str = @"//publish-pic-cpu.baidu.com/4e10408d-66ca-4320-9c1d-617f719cfef9.jpeg@c_1,y_21,w_660,h_330";
    NSURLComponents *components = [[NSURLComponents alloc] initWithString:str];
    components.scheme = @"https";
    NSLog(@"%@", components.URL);
}

- (void)testRange {
    int a = 5;
    NSLog(@"%d", a++ >> 1);
}

@end
