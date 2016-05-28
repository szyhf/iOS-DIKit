//
//  UITabBarItem+DIAttribute.m
//  Pods
//
//  Created by Back on 16/5/24.
//
//

#import "UITabBarItem+DIAttribute.h"
#import "DILog.h"
#import "UndefinedKeyHandlerBlock.h"
#import "NSObject+Runtimes.h"

@implementation UITabBarItem (DIAttribute)
-(void)setValue:(id)value
forUndefinedKey:(NSString *)key
{
	UndefinedKeyHandlerBlock block  = [UITabBarItem blocks:key];
	if(block!=nil)
	{
		block(self,key,value);
	}
	else
	{
		WarnLog(@"Try to set attribute %@ = %@, but failed.",key,value);
	}
}

+(UndefinedKeyHandlerBlock)blocks:(NSString*)key
{
	static NSDictionary<NSString*,UndefinedKeyHandlerBlock>* _instance;
	static dispatch_once_t _uiView_token;
	dispatch_once(&_uiView_token,
				  ^{
					  _instance = @{
									} ;
				  });
	id res = _instance[key];
	if(res == nil)
	{
		if([(id)[self superclass]respondsToSelector:@selector(blocks:)])
		{
			res = [[self superclass] invokeStaticMethod:@"blocks:" withParams:key];
		}
	}
	
	return res;
}
@end
