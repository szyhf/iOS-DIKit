//
//  UIViewController+DIAttribute.m
//  DIKit
//
//  Created by Back on 16/5/24.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "UIViewController+DIAttribute.h"
#import "UndefinedKeyHandlerBlock.h"
#import "DILayoutParser.h"
#import "DITools.h"
#import "DIContainer.h"
#import "DIConverter.h"

@implementation UIViewController (DIAttribute)
-(void)setValue:(id)value
forUndefinedKey:(NSString *)key
{
	NSString* trim_key = [key stringByDeletingPathExtension];
	
	//必须显式的调用当前类型，否则无法正确拦截并处理子类向上传递的消息。
	UndefinedKeyHandlerBlock block  = [UIViewController blocks:trim_key];
	if(block!=nil)
		block(self,trim_key,value);
	else if(trim_key.length!=key.length)
		return [self setValue:value forKey:trim_key];
	else
		[super setValue:value forUndefinedKey:trim_key];
}

+(UndefinedKeyHandlerBlock)blocks:(NSString*)key
{
	static NSDictionary<NSString*,UndefinedKeyHandlerBlock>* _instance;
	static dispatch_once_t _uiView_token;
	dispatch_once(&_uiView_token,
				  ^{
					  _instance = @{
									@"backgroundColor":self.colorKey,
									@"leftBar":self.leftBarKey,
									/**
									 *  layout
									 */
									@"height":self.layoutKey,
									@"width":self.layoutKey,
									
									@"top":self.layoutKey,
									@"bottom":self.layoutKey,
									@"left":self.layoutKey,
									@"right":self.layoutKey,
									
									@"centerx":self.layoutKey,
									@"centery":self.layoutKey,
									
									@"leading":self.layoutKey,
									@"trailing":self.layoutKey,
									
									@"not":self.layoutKey,
									
									} ;
				  });
	return _instance[key];
}

+(UndefinedKeyHandlerBlock)leftBarKey
{
	static UndefinedKeyHandlerBlock _instance;
	static dispatch_once_t _leftBarKey_token;
	dispatch_once(&_leftBarKey_token,
				  ^{
					  _instance =  ^void(UIViewController* obj,NSString*key,id value)
					  {
						  NSString* name = [(NSString*)value trimStart:@"$"];
						  id button = [DIContainer getInstanceByName:name];
						  if ([button isKindOfClass:UIView.class])
						  {
							  button = [[UIBarButtonItem alloc]initWithCustomView:button];
							  
						  }
						  if([button isKindOfClass:UIBarButtonItem.class])
						  {
							  if(obj.navigationItem.leftBarButtonItems.count>0)
							  {
								  obj.navigationItem.leftBarButtonItem = button;
							  }
							  else
							  {
								  NSMutableArray* tempAry = [NSMutableArray arrayWithArray:obj.navigationItem.leftBarButtonItems];
								  obj.navigationItem.leftBarButtonItems = [tempAry arrayByAddingObject:button];
							  }
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
					  _instance = ^void(UIViewController* obj,NSString*key,id value)
					  {
						  [obj.view setValue:value forKey:key];
						  
					  } ;
				  });
	return _instance;
}

+(UndefinedKeyHandlerBlock)colorKey
{
	static UndefinedKeyHandlerBlock _instance;
	static dispatch_once_t _colorKey_token;
	dispatch_once(&_colorKey_token,
				  ^{
					  _instance =  ^void(UIViewController* obj,NSString*key,id value)
					  {
						  //todo:prop
						  UIColor* color = [DIConverter toColor:value];
						  [obj.view setValue:color forKeyPath:key];
					  };
				  });
	return _instance;
}

@end
