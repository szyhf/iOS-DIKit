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

@implementation UIView (DIAttribute)
-(void)setValue:(id)value
forUndefinedKey:(NSString *)key
{
	key = [UIView alias:key];
	//必须显式的调用UIView，否则无法正确拦截并处理子类向上传递的消息。
	UndefinedKeyHandlerBlock block  = [UIView blocks:key];
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
									@"layout":self.layoutKey
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
						@"style":@"nuiClass",
						@"height":@"layout",
						@"width":@"layout",
						
						@"top":@"layout",
						@"bottom":@"layout",
						@"left":@"layout",
						@"right":@"layout",
						
						@"centerx":@"layout",
						@"centery":@"layout",
						
						@"leading":@"layout",
						@"trailing":@"layout",
						};
				  });
	return _instance[alias]?_instance[alias]:alias;
}

+(UndefinedKeyHandlerBlock)layoutKey
{
	static UndefinedKeyHandlerBlock _instance;
	static dispatch_once_t _layoutKey;
	dispatch_once(&_layoutKey,
				  ^{
					  _instance = ^void(UIView* obj,NSString*key,id value)
					  {
						  NSArray<NSLayoutConstraint*>* constarints = [DILayoutParser constraints:value toAttribute:key forView:obj];
						  [obj setTranslatesAutoresizingMaskIntoConstraints:NO];
						  [obj.superview addConstraints:constarints];
					  
					  } ;
				  });
	return _instance;
}
@end
