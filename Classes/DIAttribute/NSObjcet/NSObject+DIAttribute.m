//
//  NSObject+DIAttribute.m
//  DIKit
//
//  Created by Back on 16/5/24.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "NSObject+DIAttribute.h"
#import "DIConverter.h"
#import "NSObject+Runtimes.h"
#import <objc/runtime.h>

@implementation NSObject (DIAttribute)

-(void)updateByNode:(DINode*)node
{
	[node.attributes enumerateKeysAndObjectsUsingBlock:
	 ^(NSString * _Nonnull key,
	   NSString * _Nonnull obj,
	   BOOL * _Nonnull stop)
	{
		@try
		{
			[self.class di_UpdateObject:self byKey:key value:obj];
		}
		@catch (NSException *exception)
		{
			DebugLog(@"set key(%@) catched an exception: %@",key,exception);
		}
	}];
}

+(void)di_UpdateObject:(id)obj byKey:(NSString*)key value:(NSString*)value
{
	UndefinedKeyHandlerBlock block  = [self di_AttributeBlock:key];
	if(block!=nil)
		block(obj,key,value);
	else
	{
		Class superClass = [self superclass];
		while (superClass)
		{
			if([((id)superClass)respondsToSelector:@selector(di_UpdateObject:byKey:value:)])
			{
				return (void)[superClass di_UpdateObject:obj byKey:key value:value];
			}
			superClass = [superClass superclass];
		}
		
		[obj setValue:value forKeyPath:key];
	}
}

-(void)setValue:(id)value
forUndefinedKey:(NSString *)key
{
	objc_setAssociatedObject(self, NSSelectorFromString(key), value, OBJC_ASSOCIATION_RETAIN);
}

-(id)valueForUndefinedKey:(NSString *)key
{
	return objc_getAssociatedObject(self,NSSelectorFromString(key));
}

+(UndefinedKeyHandlerBlock)di_AttributeBlock:(NSString*)key
{
	static NSDictionary<NSString*,UndefinedKeyHandlerBlock>* _instance;
	static dispatch_once_t _token;
	dispatch_once(&_token,
				  ^{
					  _instance = @{
									@"image":self.imageKey
									} ;
				  });
	return _instance[key];
}
+(UndefinedKeyHandlerBlock)imageKey
{
	static UndefinedKeyHandlerBlock _instance;
	static dispatch_once_t _imageKey;
	dispatch_once(&_imageKey,
				  ^{
					  _instance = ^void(NSObject* obj,NSString*key,id value)
					  {
						  if([obj respondsToSelector:@selector(setImage:)])
						  {
							  if([value isKindOfClass:UIImage.class])
								 [obj setValue:value forKey:@"image"];
							  else
							  {
								  UIImage* image = [DIConverter toImage:value];
								  if(image)
									  [obj setValue:image forKey:@"image"];
							  }
						  }
					  } ;
				  });
	return _instance;
}
@end
