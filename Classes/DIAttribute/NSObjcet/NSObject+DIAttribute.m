//
//  NSObject+DIAttribute.m
//  DIKit
//
//  Created by Back on 16/5/24.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "NSObject+DIAttribute.h"
#import "UndefinedKeyHandlerBlock.h"
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
		UndefinedKeyHandlerBlock block  = [self.class di_AttributeBlock:key];
		if(block!=nil)
			block(self,key,obj);
		else
			[self setValue:obj forKeyPath:key];
	}];
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
	static dispatch_once_t _uiView_token;
	dispatch_once(&_uiView_token,
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
