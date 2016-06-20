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
									@"text":self.textKey
									} ;
				  });
	return _instance[key];
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
@end
