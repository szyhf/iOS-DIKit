//
//  Router+XmlTests.m
//  DIKit
//
//  Created by Back on 16/5/19.
//  Copyright © 2016年 Back. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DIRouter.h"
#import "DIRouter+Xml.h"

@interface Router_XmlTests : XCTestCase
@property(nonatomic)NSString* testXml;
@end

@implementation Router_XmlTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.

}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testParse {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
	[DIRouter realizeXml:self.testXml];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (NSString *)testXml {
	if(_testXml == nil)
	{
		_testXml = @"<MainTabBarController>\n\t<ShareNavigationController name=\"shar\">\n\t\t<ShareViewController>\n\t\t\t<lightButton/>\n\t\t</ShareViewController>\n\t</ShareNavigationController>\n\t<ClassifyViewController/>\n\t<UserViewController/>\n</MainTabBarController>";
	}
	return _testXml;
}

@end
