//
//  UILabel+DIAttribute.m
//  Pods
//
//  Created by Back on 16/6/20.
//
//

#import "UILabel+DIAttribute.h"
#import "NSObject+DIAttribute.h"
#import "DIConverter.h"

@implementation UILabel (DIAttribute)


+(UndefinedKeyHandlerBlock)di_AttributeBlock:(NSString*)key
{
	static NSDictionary<NSString*,UndefinedKeyHandlerBlock>* _instance;
	static dispatch_once_t _token;
	dispatch_once(&_token,
				  ^{
					  _instance = @{
									@"text":self.textKey,
									@"fontName":self.fontNameKey,
									@"fontSize":self.fontSize,
									@"lineBreakMode":self.lineBreakModeKey
									} ;
				  });
	return _instance[key];
}
+(UndefinedKeyHandlerBlock)lineBreakModeKey
{
	return ^void(UILabel* label,NSString*key,id value)
	{
		int mode = [(NSString*)value intValue];
		[label setLineBreakMode:(NSLineBreakMode)mode];
	};
}

+(UndefinedKeyHandlerBlock)textKey
{
	return ^void(UILabel* label,NSString*key,id value)
	{
		NSString* val = [DIConverter toString:value];
		if(![NSString isNilOrEmpty:val])
		{
			[label setText:val];
		}
	};
}

+(UndefinedKeyHandlerBlock)fontNameKey
{
	return ^void(UILabel* label,NSString*key,id value)
	{
		NSString* val = [DIConverter toString:value];
		UIFont* font = [UIFont fontWithName:val size:label.font.pointSize];
		if(font)
			label.font = font;
		
		WarnLogWhile(!font, @"Try to set font named %@ but not exist.",val);
	};
}

+(UndefinedKeyHandlerBlock)fontSize
{
	return ^void(UILabel* label,NSString*key,id value)
	{
		double val = [(NSString*)value floatValue];
		UIFont* font;
		if(val>0)
		{
			font = [UIFont fontWithName:label.font.fontName size:val];
			if(font)
				label.font = font;
		}
		WarnLogWhile(!font, @"Try to set font named %@ but not exist.",font);
	};
}

@end
