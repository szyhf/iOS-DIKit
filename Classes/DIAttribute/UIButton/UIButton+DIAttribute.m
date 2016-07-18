//
//  UIButton+DIAttribute.m
//  DIKit
//
//  Created by Back on 16/6/2.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "UIButton+DIAttribute.h"
#import "DITree.h"
#import "DIContainer.h"
#import "DIConverter.h"
#import "DICommand.h"

@implementation UIButton (DIAttribute)

+(UndefinedKeyHandlerBlock)di_AttributeBlock:(NSString*)key
{
	static NSDictionary<NSString*,UndefinedKeyHandlerBlock>* _instance;
	static dispatch_once_t _token;
	dispatch_once(&_token,
				  ^{
					  _instance = @{
						@"tap":self.tapKey,
						@"title":self.titleKey,
						@"image":self.imageKey,
						@"titleColor":self.titleColorKey
									} ;
				  });
	return _instance[key];
}

+(UndefinedKeyHandlerBlock)titleColorKey
{
	return ^void(UIButton* button,NSString*key,id value)
	{
		UIColor* color = [DIConverter toColor:value];
		if(color)
			[button setTitleColor:color forState:UIControlStateNormal];
	};
}

+(UndefinedKeyHandlerBlock)imageKey
{
	return ^void(UIButton* button,NSString*key,id value)
	{
		UIImage* image;
		if([value isKindOfClass:UIImage.class])
		{
			image = value;
		}else
		{
			image = [DIConverter toImage:value];
		}
		if(image)
			[button setImage:image forState:UIControlStateNormal];
	};
}

+(UndefinedKeyHandlerBlock)titleKey
{
	return ^void(UIButton* button,NSString*key,id value)
	{
		[button setTitle:value forState:UIControlStateNormal];
	};
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
	void(^tapBlock)(UIButton*) ;
	if([tap_value isKindOfClass:NSString.class])
	{
		NSArray* commands = [(NSString*)tap_value componentsSeparatedByString:@";"];
		NSMutableArray* actions = [NSMutableArray arrayWithCapacity:commands.count];
		for (NSString* command in commands)
		{
			if([NSString isNilOrEmpty:command])
				continue;
			//DICommand* diCommand = [[DICommand alloc]initWithString:command];
			//[diCommand call];
			NSScanner* scanner = [NSScanner scannerWithString:command];
			NSString* targetName;
			NSString* methodName;
			[scanner scanUpToString:@"." intoString:&targetName];
			[scanner scanString:@"." intoString:nil];
			[scanner scanUpToString:@"" intoString:&methodName];
			id target = [DIContainer getInstanceByName:targetName];
			
			SEL action = NSSelectorFromString(methodName);
			if([target respondsToSelector:action])
				[actions addObject:@[target,methodName]];
			else if([NSClassFromString(targetName) respondsToSelector:action])
				[actions addObject:@[NSClassFromString(targetName),methodName]];
		}
		
		tap_value =^void(UIButton*_button)
		{
			for (NSArray* action in actions)
			{
				NSString* methodName = action.lastObject;
				if([methodName hasSuffix:@":"])
				{
					[action.firstObject invokeSelector:NSSelectorFromString(methodName) withParams:_button];
				}
				else
				{
					[action.firstObject  invokeMethod:methodName];
				}
			}
		};
		tapBlock = tap_value;
		[button setValue:tap_value forKey:@"di_tap"];
	}
	else
	{
		tapBlock = tap_value;
	}
	if(tapBlock)
		return tapBlock(button);
}

@dynamic di_tap;
-(void)setDi_tap:(id)value
{
	objc_setAssociatedObject(self, NSSelectorFromString(@"di_tap"), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
