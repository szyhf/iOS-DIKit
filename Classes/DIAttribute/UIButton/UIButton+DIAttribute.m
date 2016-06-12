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
						@"image":self.imageKey
									} ;
				  });
	return _instance[key];
}

+(UndefinedKeyHandlerBlock)imageKey
{
	return ^void(UIButton* button,NSString*key,id value)
	{
		UIImage* image;
		if([value isKindOfClass:UIImage.class])
		{
			image = value;
		}else if([value isKindOfClass:NSString.class])
		{
			NSString*imageStr = value;
			image = [UIImage imageNamed:imageStr];
			//网址暂不支持= =以后再说
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
	void(^tapBlock)() ;
	if([tap_value isKindOfClass:NSString.class])
	{
		NSScanner* scanner = [NSScanner scannerWithString:tap_value];
		NSString* targetName;
		NSString* methodName;
		[scanner scanUpToString:@"." intoString:&targetName];
		[scanner scanString:@"." intoString:nil];
		[scanner scanUpToString:@"" intoString:&methodName];
		id target = [DIContainer getInstanceByName:targetName];
		SEL action = NSSelectorFromString(methodName);
		if([target respondsToSelector:action])
		{
			tap_value =^void()
			{
				if([methodName hasSuffix:@":"])
				{
					[target invokeSelector:action withParams:button];
				}
				else
				{
					[target invokeSelector:action];
				}
			};
			tapBlock = tap_value;
			[button setValue:tap_value forKey:@"di_tap"];
		}
	}
	else
	{
		tapBlock = tap_value;
	}
	if(tapBlock)
		return tapBlock();
	
}
@end
