//
//  UIButton+DIAttribute.m
//  DIKit
//
//  Created by Back on 16/6/2.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "UIButton+DIAttribute.h"
#import "UIView+DIAttribute.h"
#import "DITree.h"
#import <objc/objc-runtime.h>

@implementation UIButton (DIAttribute)
+(UndefinedKeyHandlerBlock)di_AttributeBlock:(NSString*)key
{
	static NSDictionary<NSString*,UndefinedKeyHandlerBlock>* _instance;
	static dispatch_once_t _token;
	dispatch_once(&_token,
				  ^{
					  _instance = @{
						@"tap":self.tapKey
									} ;
				  });
	return _instance[key];
}

+(UndefinedKeyHandlerBlock)tapKey
{
	return ^void(UIButton* button,NSString*key,id value)
	{
		[button addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
		[button setValue:value forKey:@"di_tap"];
	};
}

+(void)tap:(UIButton*)button
{
	NSString*command = [button valueForKey:@"di_tap"];
	NSScanner* scanner = [NSScanner scannerWithString:command];
	NSString* targetName;
	NSString* methodName;
	[scanner scanUpToString:@"." intoString:&targetName];
	[scanner scanString:@"." intoString:nil];
	[scanner scanUpToString:@"" intoString:&methodName];
	DINode* targetNode = [DITree instance].nameToNode[targetName];
	SEL action = NSSelectorFromString(methodName);
	if([targetNode.implement respondsToSelector:action])
	{
		//[targetNode.implement  performSelector:action withObject:button];
		[targetNode.implement invokeSelector:action];
		
		//DebugLog(@"%@",res);
	}
}
@end
