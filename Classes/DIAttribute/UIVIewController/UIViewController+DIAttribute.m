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

@implementation UIViewController (DIAttribute)
-(void)setValue:(id)value
forUndefinedKey:(NSString *)key
{
	//必须显式的调用UIView，否则无法正确拦截并处理子类向上传递的消息。
	UndefinedKeyHandlerBlock block  = [UIViewController blocks:key];
	if(block!=nil)
		block(self,key,value);
	else
		[super setValue:value forUndefinedKey:key];
}

+(UndefinedKeyHandlerBlock)blocks:(NSString*)key
{
	static NSDictionary<NSString*,UndefinedKeyHandlerBlock>* _instance;
	static dispatch_once_t _uiView_token;
	dispatch_once(&_uiView_token,
				  ^{
					  _instance = @{
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

+(UndefinedKeyHandlerBlock)layoutKey
{
	static UndefinedKeyHandlerBlock _instance;
	static dispatch_once_t _layoutKey;
	dispatch_once(&_layoutKey,
				  ^{
					  _instance = ^void(UIViewController* obj,NSString*key,id value)
					  {
						  NSArray<NSLayoutConstraint*>* constarints = [DILayoutParser constraints:value toAttribute:key forView:obj.view];
						  [obj.view setTranslatesAutoresizingMaskIntoConstraints:NO];
						  [obj.view.superview addConstraints:constarints];
						  
					  } ;
				  });
	return _instance;
}
@end
