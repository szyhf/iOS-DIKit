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
#import "FBKVOController.h"
#import "NSObject+FBKVOController.h"
#import "DIContainer.h"
#import <objc/runtime.h>

@implementation UIView (DIAttribute)
-(void)updateByNode:(DINode*)node
{
	[node.attributes enumerateKeysAndObjectsUsingBlock:
	 ^(NSString * _Nonnull key,
	   NSString * _Nonnull obj,
	   BOOL * _Nonnull stop)
	 {
		 UndefinedKeyHandlerBlock block  = [UIView blocks:key];
		 if(block!=nil)
			 block(self,key,obj);
		 else
			 [self setValue:obj forKeyPath:key];
	 }];
}

+(UndefinedKeyHandlerBlock)blocks:(NSString*)key
{
	static NSDictionary<NSString*,UndefinedKeyHandlerBlock>* _instance;
	static dispatch_once_t _uiView_token;
	dispatch_once(&_uiView_token,
				  ^{
					  _instance = @{
									@"backgroundColor":self.colorKey,
									@"image":self.imageKey,
									@"size":self.frameKey,
									/**
									 *  layout
									 */
									@"height":self.layoutKey,
									@"width":self.layoutKey,
									
									@"top":self.layoutKey,
									@"bottom":self.layoutKey,
									@"left":self.layoutKey,
									@"right":self.layoutKey,
									
									@"centerX":self.layoutKey,
									@"centerY":self.layoutKey,
									
									@"leading":self.layoutKey,
									@"trailing":self.layoutKey,
									} ;
				  });
	return _instance[key];
}

+(NSString*)alias:(NSString*)alias
{
	static NSDictionary<NSString*,NSString*>* _instance;
	static dispatch_once_t _alias_token;
	dispatch_once(&_alias_token,
				  ^{
					  _instance =
					  @{
						@"style":@"nuiClass"
						};
				  });
	return _instance[alias];
}

+(UndefinedKeyHandlerBlock)frameKey
{
	static UndefinedKeyHandlerBlock _instance;
	static dispatch_once_t _frameKey_token;
	dispatch_once(&_frameKey_token,
				  ^{
					  _instance = ^void(UIView* view,NSString* key,NSString* value)
					  {
						
						  value = [value trimStart:@"("];
						  value = [value trimEnd:@")"];
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

+(UndefinedKeyHandlerBlock)layoutKey
{
	static UndefinedKeyHandlerBlock _instance;
	static dispatch_once_t _layoutKey;
	dispatch_once(&_layoutKey,
				  ^{
					  _instance = ^void(UIView* obj,NSString*key,id value)
					  {
						  NSArray* cons = [DILayoutParser constraints:value toAttribute:key forView:obj];
						  [obj.superview addConstraints:cons];
						  [obj setTranslatesAutoresizingMaskIntoConstraints:NO];
					  } ;
				  });
	return _instance;
}

static void InstallAddSubviewListener(void (^listener)(id),id target)
{
	if ( listener == NULL )
	{
		NSLog(@"listener cannot be NULL.");
		return;
	}
	NSString* methodName = @"didMoveToSuperview";
	SEL selector = NSSelectorFromString(methodName);
	Method oldMethod = class_getInstanceMethod(UIButton.class,selector);
	IMP imp = [UIButton instanceMethodForSelector:selector];
	id (*func)(id, SEL) = (void *)imp;

	void (^block)(id) = ^(id _self)
	{
		func(_self, selector);
		if([target isEqual:_self])
			listener(_self);
	};
	
	IMP newImp = imp_implementationWithBlock((__bridge id)((__bridge void*)block));
	method_setImplementation(oldMethod, newImp);
}
@end
