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
	id tap_value = [button valueForKey:@"di_tap"];
	if([tap_value isKindOfClass:NSString.class])
	{
		NSScanner* scanner = [NSScanner scannerWithString:tap_value];
		NSString* targetName;
		NSString* methodName;
		[scanner scanUpToString:@"." intoString:&targetName];
		[scanner scanString:@"." intoString:nil];
		[scanner scanUpToString:@"" intoString:&methodName];
		DINode* targetNode = [DITree instance].nameToNode[targetName];
		SEL action = NSSelectorFromString(methodName);
		if([targetNode.implement respondsToSelector:action])
		{
			tap_value =^void()
			{
				[targetNode.implement invokeSelector:action];
			};
			[button setValue:tap_value forKey:@"di_tap"];
		}
	}
	void(^tapBlock)() = tap_value;
	if(tapBlock)
		return tapBlock();
	
}
@end
