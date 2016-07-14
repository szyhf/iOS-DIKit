//
//  DICommand.m
//  DIKit
//
//  Created by Back on 16/7/14.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "DICommand.h"
#import "DITools.h"
#import "DIContainer.h"
@interface DICommand()
@property (nonatomic, assign) SEL action;
@property (nonatomic, weak) id target;
@end

@implementation DICommand
-(instancetype)initWithString:(NSString*)commandString
{
	self = [super init];
	if(self)
	{
		NSAssert(![NSString isNilOrEmpty:commandString], @"Command string should not be nil or empty");
		NSScanner* scanner = [NSScanner scannerWithString:commandString];
		NSString* targetName;
		NSString* methodName;
		[scanner scanUpToString:@"." intoString:&targetName];
		[scanner scanString:@"." intoString:nil];
		[scanner scanUpToString:@"" intoString:&methodName];
		
		self.target = [DIContainer getInstanceByName:targetName];
		NSAssert(self.target, @"Target not exist.");
		self.action = NSSelectorFromString(methodName);
		
	}
	return self;
}

-(void)addParamsWithDictionary:(NSDictionary<NSString*,id>*)params
{
	
}

-(id)call
{
	return [self.target invokeSelector:self.action];
}

-(id)callWithParams:(id)params,...
{
	return [self.target invokeSelector:self.action withParams:params];
}
@end
