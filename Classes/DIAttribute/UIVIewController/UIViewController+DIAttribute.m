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

@implementation UIViewController (DIAttribute)
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

+(UndefinedKeyHandlerBlock)di_AttributeBlock:(NSString*)key
{
	static NSDictionary<NSString*,UndefinedKeyHandlerBlock>* _instance;
	static dispatch_once_t _uiView_token;
	dispatch_once(&_uiView_token,
				  ^{
					  _instance = @{
									@"backgroundColor":self.colorKey,
									@"leftBarButtonItems":self.leftBarKey,
									@"rightBarButtonItems":self.rightBarKey,
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
									
									@"di_addConstant":self.di_layoutKey
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




+(UndefinedKeyHandlerBlock)layoutKey
{
	static UndefinedKeyHandlerBlock _instance;
	static dispatch_once_t _layoutKey;
	dispatch_once(&_layoutKey,
				  ^{
					  _instance = ^void(UIViewController* obj,NSString*key,id value)
					  {
						  NSArray<DINodeLayoutConstraint*>* nodeConstraints = value;
						  for (DINodeLayoutConstraint* constraint in nodeConstraints)
						  {
							  [constraint realizeConstant];
						  }
					  } ;
				  });
	return _instance;
}

+(UndefinedKeyHandlerBlock)di_layoutKey
{
	static UndefinedKeyHandlerBlock _instance;
	static dispatch_once_t _layoutKey;
	dispatch_once(&_layoutKey,
				  ^{
					  _instance = ^void(UIViewController* obj,NSString*key,id value)
					  {
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
