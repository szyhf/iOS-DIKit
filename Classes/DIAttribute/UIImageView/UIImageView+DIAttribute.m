//
//  UIImageView+Property.m
//  DIKit
//
//  Created by Back on 16/5/23.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "UIImageView+DIAttribute.h"
#import "DILog.h"

@implementation UIImageView (DIAttribute)
-(void)setValue:(id)value
forUndefinedKey:(NSString *)key
{
	void(^currentblock)(UIImageView*,id)  = [UIImageView blocks:key];
	if(currentblock!=nil)
		currentblock(self,value);
	else
		[super setValue:value forUndefinedKey:key];
}

+(void(^)(UIImageView*,id))blocks:(NSString*)key
{
	static dispatch_once_t _uiimage_view_property_token;
	static NSDictionary<NSString*,void(^)(UIImageView*,id)>* _blocks ;
	dispatch_once(&_uiimage_view_property_token, ^{
		_blocks=@{
				  @"imageNamed":self.imageNamed,
				  @"":self.imageSrc
				  };
	});
	return _blocks[key];
}

+(void(^)(UIImageView*,id))imageNamed
{
	static void(^handler)(UIImageView*,id);
	static dispatch_once_t imageNamedToken;
	dispatch_once(&imageNamedToken, ^{
		handler = ^void(UIImageView* obj,id value)
		{
			NSString* imageName = (NSString*)value;
			UIImage* image = [UIImage imageNamed:imageName];
			if(image!=nil)
				[obj setImage:image];
			else
				WarnLog(@"Try to set image named of %@, but failed.",value);
		};
	});
	return handler;
}
+(void(^)(UIImageView*,id))imageSrc
{
	static void(^_instance)(UIImageView*,id) ;
	static dispatch_once_t _blcok_imageSrc_token;
	dispatch_once(&_blcok_imageSrc_token, ^{
		_instance = ^void(UIImageView* obj,id value)
		{
			NSString* imagePath = value;
			//UIImage* image = [UIImage ]
		};
	});
	return _instance;
}

@end
