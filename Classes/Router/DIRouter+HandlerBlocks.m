//
//  DIRouter+HandlerBlocks.m
//  Fakeshion
//
//  Created by Back on 16/5/11.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "DIRouter+HandlerBlocks.h"
#import "DIContainer.h"

@implementation DIRouter (HandlerBlocks)
static NSDictionary<NSString*,NSDictionary<NSString*,RealizeHandlerBlock>*>*_realizeMap;
+(NSDictionary<NSString*,NSDictionary<NSString*,RealizeHandlerBlock>*>*)realizeMap
{
	//["super"=>["child"=>handlerBlock]]
	if(_realizeMap==nil)
		_realizeMap = @{
			  @"UITabBarController":@{
					  @"UIViewController":self.realizeTabBarControllerToViewController,
					},
			  @"UINavigationController":@{
					  @"UIViewController":self.realizeNavigationControllerToViewController,
					  },
			  @"UIViewController":@{
					  @"UIViewController":self.realizeViewControllerToViewController,
					  @"UIView":self.realizeViewControllerToView,
					  },
			  @"UIControl":@{},
			  @"UIView":@{
					  @"UIView":self.realizeViewToView
					  }
			  };;
	
	return _realizeMap;
}

+(RealizeHandlerBlock)realizeViewControllerToView
{
	return ^void(NSString* parentName,NSString* childName)
	{
		UIViewController* superIns = [DIContainer getInstanceByName:parentName];
		UIView* childView = [DIContainer getInstanceByName:childName];
		if(![superIns.view.subviews containsObject:childView])
		{
			[superIns.view addSubview:childView];
		}
		[superIns.view bringSubviewToFront:childView];
	};
}

+(RealizeHandlerBlock)realizeViewToView
{
	return ^void(NSString* parentName,NSString* childName)
	{
		UIView* parentView = [DIContainer getInstanceByName:parentName];
		UIView* childView = [DIContainer getInstanceByName:childName];
		
		if([parentView.subviews containsObject:childView])
		{
			[parentView addSubview:childView];
		}
	};
}

+(RealizeHandlerBlock)realizeViewControllerToViewController
{
	return ^void(NSString* parentName,NSString* childName)
	{
		UIViewController* childIns = [DIContainer getInstanceByName:childName];
		UIViewController* superIns = [DIContainer getInstanceByName:parentName];
		
		if(![superIns.childViewControllers containsObject:childIns])
		{
			[superIns addChildViewController:childIns];
		}
		
		if(![superIns.view.subviews containsObject:childIns.view])
		{
			[superIns.view addSubview:childIns.view];
			[superIns.view bringSubviewToFront:childIns.view];
		}
		
	};
}

+(RealizeHandlerBlock)realizeNavigationControllerToViewController
{
	return ^void(NSString* parentName,NSString* childName)
	{
		UIViewController* childIns = [DIContainer getInstanceByName:childName];
		UINavigationController* superIns = [DIContainer getInstanceByName:parentName];
		if(![superIns.childViewControllers containsObject:childIns])
		{
			[superIns pushViewController:childIns animated:YES];
		}
	};
}

+(RealizeHandlerBlock)realizeTabBarControllerToViewController
{
	return ^void(NSString* parentName,NSString* childName)
	{
		UIViewController* childIns = [DIContainer getInstanceByName:childName];
		UITabBarController* superIns = [DIContainer getInstanceByName:parentName];
		
		if(![superIns.childViewControllers containsObject:childIns])
		{
			[superIns addChildViewController:childIns];
		}
	};
}
@end
