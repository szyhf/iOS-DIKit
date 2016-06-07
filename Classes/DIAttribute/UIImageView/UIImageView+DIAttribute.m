//
//  UIImageView+DIAttribute.m
//  Pods
//
//  Created by Back on 16/6/6.
//
//

#import "UIImageView+DIAttribute.h"
#import "NSObject+DIAttribute.h"
#import "DIConverter.h"

@implementation UIImageView (DIAttribute)
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
