//
//  UITextField+DIAttribute.m
//  DIKit
//
//  Created by Back on 16/7/6.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "UITextField+DIAttribute.h"
#import "NSObject+DIAttribute.h"
#import "DIConverter.h"

@implementation UITextField (DIAttribute)
+(UndefinedKeyHandlerBlock)di_AttributeBlock:(NSString*)key
{
	static NSDictionary<NSString*,UndefinedKeyHandlerBlock>* _instance;
	static dispatch_once_t _token;
	dispatch_once(&_token,
				  ^{
					  _instance = @{
									//@"defatultText":self.defaultTextKey
									} ;
				  });
	return _instance[key];
}

+(UndefinedKeyHandlerBlock)defaultTextKey
{
	return ^void(UITextField* textField,NSString*key,id value)
	{
		[textField setDi_defaultText:[DIConverter toString:value]];
	};
}

@dynamic di_defaultText;
-(void)setDi_defaultText:(NSString *)di_defaultText
{
	objc_setAssociatedObject(self, NSSelectorFromString(@"di_defaultText"), di_defaultText, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
