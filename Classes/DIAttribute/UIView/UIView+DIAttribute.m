//
//  UIView+Property.m
//  Pods
//
//  Created by Back on 16/5/24.
//
//
#import <UIKit/UIKit.h>
#import "NSObject+DIAttribute.h"
#import "DIConverter.h"
#import "DITools.h"
#import "DIContainer.h"


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
									@"style":self.styleKey,
									@"intrinsic":self.intrinsicKey
									} ;
				  });
	return _instance[key];
}

+(UndefinedKeyHandlerBlock)intrinsicKey
{
	static UndefinedKeyHandlerBlock _instance;
	static dispatch_once_t _token;
	dispatch_once(&_token,
				  ^{
					  _instance = ^void(UIView* view,NSString* key,NSString* value)
					  {
						  //cv 纵向压缩阻力
						  //ch 横向压缩阻力
						  //hv 纵向拉伸阻力
						  //hh 横向拉伸阻力
						  NSArray<NSString*>* pritAry = [value componentsSeparatedByString:@","];
						  
						  for (NSString* prit in pritAry)
						  {
							  NSScanner* scanner = [NSScanner scannerWithString:prit];
							  double priority;
							  NSString*type;
							  [scanner scanCharactersFromSet:[NSCharacterSet letterCharacterSet] intoString:&type];
							  [scanner scanDouble:&priority];
							  if([type isEqualToString:@"cv"])
							  {
								  [view setContentCompressionResistancePriority:priority forAxis:UILayoutConstraintAxisVertical];
							  }
							  else if ([type isEqualToString:@"ch"])
							  {
								   [view setContentCompressionResistancePriority:priority forAxis:UILayoutConstraintAxisHorizontal];
							  }
							  else if ([type isEqualToString:@"hv"])
							  {
								   [view setContentHuggingPriority:priority forAxis:UILayoutConstraintAxisVertical];
							  }
							  else if ([type isEqualToString:@"hh"])
							  {
								  [view setContentHuggingPriority:priority forAxis:UILayoutConstraintAxisHorizontal];
							  }
						  }
						  
					  };
				  });
	return _instance;
}

+(UndefinedKeyHandlerBlock)styleKey
{
	static UndefinedKeyHandlerBlock _instance;
	static dispatch_once_t _frameKey_token;
	dispatch_once(&_frameKey_token,
				  ^{
					  _instance = ^void(UIView* view,NSString* key,NSString* value)
					  {
						  [view setValue:value forKey:@"nuiClass"];
					  };
				  });
	return _instance;
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
