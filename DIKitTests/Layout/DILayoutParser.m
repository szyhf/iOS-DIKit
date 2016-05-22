//
//  DILayoutParser.m
//  DIKit
//
//  Created by Back on 16/5/22.
//  Copyright © 2016年 Back. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DILayoutParser.h"

@interface DILayoutParser : XCTestCase

@end

@implementation DILayoutParser

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
	DILayoutParser* parser = [[DILayoutParser alloc]init];
	[parser parserFormula:@">hello:height*12+1"];
	
	//raletion
	[parser parserFormula:@"hello:height*12+1"];
	//raletion+target
	[parser parserFormula:@":height*12+1"];
	//raletion+target+attr
	[parser parserFormula:@":*12+1"];
	//raletion+target+attr+mutl
	[parser parserFormula:@":+1"];
	//raletion+target+attr+constant
	[parser parserFormula:@":*12"];
	//raletion+target+attr+mutl+constant
	[parser parserFormula:@":"];
	//raletion+target+mutl
	[parser parserFormula:@":height+1"];
	//raletion+target+mutl+constant
	[parser parserFormula:@":height"];
	//raletion+target+constant
	[parser parserFormula:@":height*12"];
	
	//raletion+attr
	[parser parserFormula:@"hello:*12+1"];
	//raletion+attr+mutl
	[parser parserFormula:@"hello:+1"];
	//raletion+attr+constant
	[parser parserFormula:@"hello:*12"];
	
	//raletion+mutl
	[parser parserFormula:@"hello:height+1"];
	//raletion+mutl+constant
	[parser parserFormula:@"hello:height"];
	
	//raletion+constant
	[parser parserFormula:@"hello:height*12"];
	
	//target
	[parser parserFormula:@">:height*12+1"];
	//target+attr
	[parser parserFormula:@">:*12+1"];
	//target+attr+mutl
	[parser parserFormula:@">:+1"];
	//target+attr+mutl+constant
	[parser parserFormula:@">:"];
	//target+attr+consatant
	[parser parserFormula:@">:*12"];
	
	//target+mutl
	[parser parserFormula:@">:height+1"];
	//target+mutl+attr
	[parser parserFormula:@">:+1"];
	//target+mutl+attr+constant
	[parser parserFormula:@">:"];
	
	//target+attr
	[parser parserFormula:@">:*12+1"];
	//target+attr+constant
	[parser parserFormula:@">:*12"];
	
	//target+constant
	[parser parserFormula:@">:height*12"];
	
	//attr
	[parser parserFormula:@">hello:*12+1"];
	//attr+mutl
	[parser parserFormula:@">hello:+1"];
	//attr+mutl+constant
	[parser parserFormula:@">hello:"];
	//attr+constant
	[parser parserFormula:@">hello:*12"];
	
	//mutl
	[parser parserFormula:@">hello:height+1"];
	//mutl+constant
	[parser parserFormula:@">hello:height"];
	
	//constant
	[parser parserFormula:@">hello:height*12"];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
