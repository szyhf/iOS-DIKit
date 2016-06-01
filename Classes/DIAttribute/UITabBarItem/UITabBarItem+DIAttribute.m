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
#import "NSObject+DIAttribute.h"

@implementation UITabBarItem (DIAttribute)

-(void)updateByNode:(DINode*)node
{
	[node.attributes enumerateKeysAndObjectsUsingBlock:
	 ^(NSString * _Nonnull key,
	   NSString * _Nonnull obj,
	   BOOL * _Nonnull stop)
	 {
		 UndefinedKeyHandlerBlock block  = [UITabBarItem di_AttributeBlock:key];
		 if(block!=nil)
			 block(self,key,obj);
		 else
			 [self setValue:obj forKeyPath:key];
	 }];
}

+(UndefinedKeyHandlerBlock)di_AttributeBlock:(NSString*)key
{
	static NSDictionary<NSString*,UndefinedKeyHandlerBlock>* _instance;
	static dispatch_once_t _uiView_token;
	dispatch_once(&_uiView_token,
				  ^{
					  _instance = @{
									@"width":@"",
									@"height":@"",
									} ;
				  });
	id res = _instance[key];
	if(res == nil)
	{
		if([(id)[self superclass]respondsToSelector:@selector(di_AttributeBlock:)])
		{
			res = [[self superclass] invokeStaticMethod:@"di_AttributeBlock:" withParams:key];
		}
	}
	
	return res;
}
+(UndefinedKeyHandlerBlock)sizeKey
{
	static UndefinedKeyHandlerBlock _instance;
	static dispatch_once_t _imageKey;
	dispatch_once(&_imageKey,
				  ^{
					  _instance = ^void(UITabBarItem* obj,NSString*key,NSString* value)
					  {
						 	
					  } ;
				  });
	return _instance;
}
@end
