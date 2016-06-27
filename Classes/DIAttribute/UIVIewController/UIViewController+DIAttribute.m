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
#import "DINodeLayoutConstraint.h"
#import "DIViewModel.h"

@implementation UIViewController (DIAttribute)
@dynamic navigationBarHidden;

+(UndefinedKeyHandlerBlock)di_AttributeBlock:(NSString*)key
{
	static NSDictionary<NSString*,UndefinedKeyHandlerBlock>* _instance;
	static dispatch_once_t _uiView_token;
	dispatch_once(&_uiView_token,
				  ^{
					  _instance = @{
									@"style":self.styleKey,
									@"backgroundColor":self.colorKey,
									@"leftBarButtonItems":self.leftBarKey,
									@"rightBarButtonItems":self.rightBarKey,
									@"navigationBarHidden":self.navigationBarHiddenKey,
									} ;
				  });
	return _instance[key];
}

+(UndefinedKeyHandlerBlock)navigationBarHiddenKey
{
	return ^void(UIViewController* obj,NSString*key,NSString* value)
	{
		//配合DINavigationControllerDelegate可以实现动态控制bar hidden。
		[obj setValue:[NSNumber numberWithBool:[value boolValue]] forKey:key];
	};
}

+(UndefinedKeyHandlerBlock)styleKey
{
	static UndefinedKeyHandlerBlock _instance;
	static dispatch_once_t _leftBarKey_token;
	dispatch_once(&_leftBarKey_token,
				  ^{
					  _instance =  ^void(UIViewController* obj,NSString*key,id value)
					  {
						  [obj.view setValue:value forKey:@"nuiClass"];
					  } ;
				  });
	return _instance;
}

+(UndefinedKeyHandlerBlock)leftBarKey
{
	static UndefinedKeyHandlerBlock _instance;
	static dispatch_once_t _leftBarKey_token;
	dispatch_once(&_leftBarKey_token,
				  ^{
					  _instance =  ^void(UIViewController* obj,NSString*key,id value)
					  {
						  if(obj.navigationItem.leftBarButtonItems.count>0)
						  {
							  NSMutableArray* barArray = [NSMutableArray arrayWithCapacity:obj.navigationItem.leftBarButtonItems.count+1];
							  [barArray addObjectsFromArray:obj.navigationItem.leftBarButtonItems];
							  [barArray addObject:value];
							  obj.navigationItem.leftBarButtonItems = barArray;
						  }
						  else
						  {
							  obj.navigationItem.leftBarButtonItem=value;
						  }
						  
					  } ;
				  });
	return _instance;
}

+(UndefinedKeyHandlerBlock)rightBarKey
{
	static UndefinedKeyHandlerBlock _instance;
	static dispatch_once_t _leftBarKey_token;
	dispatch_once(&_leftBarKey_token,
				  ^{
					  _instance =  ^void(UIViewController* obj,NSString*key,id value)
					  {
						  if(obj.navigationItem.rightBarButtonItems.count>0)
						  {
							  NSMutableArray* barArray = [NSMutableArray arrayWithCapacity:obj.navigationItem.rightBarButtonItems.count+1];
							  [barArray addObjectsFromArray:obj.navigationItem.rightBarButtonItems];
							  [barArray addObject:value];
							  obj.navigationItem.rightBarButtonItems = barArray;
						  }else
						  {
							  obj.navigationItem.rightBarButtonItem=value;
						  }
						  
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
						  UIColor* color = [DIConverter toColor:value];
						  [obj.view setValue:color forKeyPath:key];
					  };
				  });
	return _instance;
}

-(void)di_viewDidAppear:(BOOL)animated
{
	[self viewDidAppear:animated];
}

-(void)pushNext
{
	[self.navigationController pushNext];
}

-(void)setNavigationBarHidden:(BOOL)navigationBarHidden
{
	objc_setAssociatedObject(self, NSSelectorFromString(@"navigationBarHidden"),[NSNumber numberWithBool:navigationBarHidden], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
