//
//  UIView+Property.m
//  Pods
//
//  Created by Back on 16/5/24.
//
//

#import "UIView+DIAttribute.h"
#import "UndefinedKeyHandlerBlock.h"
#import "DILog.h"
#import "DILayoutParser.h"
#import "DIConverter.h"
#import "NSObject+Runtimes.h"
#import "DITools.h"
#import "DIContainer.h"
#import <objc/runtime.h>
#import "DINodeLayoutConstraint.h"

@implementation UIView (DIAttribute)

+(UndefinedKeyHandlerBlock)di_AttributeBlock:(NSString*)key
{
	static NSDictionary<NSString*,UndefinedKeyHandlerBlock>* _instance;
	static dispatch_once_t _uiView_token;
	dispatch_once(&_uiView_token,
				  ^{
					  _instance = @{
									@"backgroundColor":self.colorKey,
									@"image":self.imageKey,
									@"fsize":self.frameKey,
									} ;
				  });
	return _instance[key];
}

+(UndefinedKeyHandlerBlock)frameKey
{
	static UndefinedKeyHandlerBlock _instance;
	static dispatch_once_t _frameKey_token;
	dispatch_once(&_frameKey_token,
				  ^{
					  _instance = ^void(UIView* view,NSString* key,NSString* value)
					  {
						  NSArray<NSString*>* parames = [value split:@","];
						  CGFloat width = [parames[0]floatValue];
						  CGFloat height = [parames[1]floatValue];
						  CGRect rect = view.frame;
						  rect.size.height = height;
						  rect.size.width = width;
						  view.frame = rect;
					  };
				  });
	return _instance;
}

+(UndefinedKeyHandlerBlock)colorKey
{
	static UndefinedKeyHandlerBlock _instance;
	static dispatch_once_t _colorKey_token;
	dispatch_once(&_colorKey_token,
				  ^{
					  _instance =  ^void(UIView* obj,NSString*key,id value)
					  {
						  UIColor* color = [DIConverter toColor:value];
						  [obj setValue:color forKeyPath:key];
					  };
				  });
	return _instance;
}

+(UndefinedKeyHandlerBlock)imageKey
{
	static UndefinedKeyHandlerBlock _instance;
	static dispatch_once_t _imageKey;
	dispatch_once(&_imageKey,
				  ^{
					  _instance = ^void(UIView* obj,NSString*key,id value)
					  {
						  if([obj respondsToSelector:@selector(setImage:)])
						  {
							  UIImage* image = [DIConverter toImage:value];
							  if(image)
								  [obj setValue:image forKey:@"image"];
						  }
						  
					  } ;
				  });
	return _instance;
}
@end
