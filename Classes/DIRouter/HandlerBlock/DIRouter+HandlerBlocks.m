//
//  DIRouter+HandlerBlocks.m
//  Fakeshion
//
//  Created by Back on 16/5/11.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "DIRouter+HandlerBlocks.h"
#import "DIContainer.h"
#import "NSObject+Runtimes.h"

@implementation DIRouter (HandlerBlocks)
static NSMutableDictionary<NSString*,NSDictionary<NSString*,RealizeHandlerBlock>*>*_realizeMap;
+(NSMutableDictionary<NSString*,NSDictionary<NSString*,RealizeHandlerBlock>*>*)realizeMap
{
	//["super"=>["child"=>handlerBlock]]
	if(_realizeMap==nil)
	{	id defaultMap = @{
			  @"UITabBarController":@{
					  @"UIViewController":self.realizeUITabBarControllerToUIViewController,
					},
			  @"UINavigationController":@{
					  @"UITabBarItem":self.realizeUINavigationControllerToUITabBarItem,
					  @"UIViewController":self.realizeUINavigationControllerToUIViewController,
					  },
			  @"UIViewController":@{
					  @"UIBarButtonItem":@"",
					  @"UIViewController":self.realizeUIViewControllerToUIViewController,
					  @"UIView":self.realizeUIViewControllerToUIView,
					  },
			  @"UIControl":@{},
			  @"UIView":@{
					  @"UIView":self.realizeUIViewToUIView
					  }
			  };
		_realizeMap = [NSMutableDictionary dictionaryWithDictionary:defaultMap];

	}
	return _realizeMap;
}

+(RealizeHandlerBlock)realizeUITableViewCellToUIView
{
	return ^void(UITableViewCell* cell,UIView* view)
	{
		[cell.contentView addSubview:view];
	};
}

+(RealizeHandlerBlock)realizeUITableViewControllerToUITableViewCell
{
	return ^void(UITableViewController* viewIns,UITableViewCell* cell)
	{
		NSString* identify = [cell valueForKey:@"identify"];
		if([NSString isNilOrEmpty:identify])
			identify = NSStringFromClass(cell.class);
		[viewIns.tableView registerClass:cell.class forCellReuseIdentifier:identify];
	};
}

+(RealizeHandlerBlock)realizeUIBarButtonItemToUIView
{
	return ^void(UIBarButtonItem* viewIns,UIView* barIns)
	{
		viewIns.customView = barIns;
	};
}

+(RealizeHandlerBlock)realizeUINavigationControllerToUITabBarItem
{
	return ^void(UINavigationController* naviIns,UITabBarItem* barIns)
	{
		[naviIns setTabBarItem:barIns];
	};
}

+(RealizeHandlerBlock)realizeUIViewControllerToUIView
{
	return ^void(UIViewController* superIns,UIView* childView )
	{
		if(![superIns.view.subviews containsObject:childView])
		{
			[superIns.view addSubview:childView];
		}
		[superIns.view bringSubviewToFront:childView];
	};
}

+(RealizeHandlerBlock)realizeUIViewToUIView
{
	return ^void(UIView* parentView,UIView* childView)
	{
		if([parentView.subviews containsObject:childView])
		{
			[parentView addSubview:childView];
		}
	};
}

+(RealizeHandlerBlock)realizeUIViewControllerToUIViewController
{
	return ^void(UIViewController* superIns,UIViewController* childIns)
	{		
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

+(RealizeHandlerBlock)realizeUINavigationControllerToUIViewController
{
	return ^void(UINavigationController* superIns,UIViewController* childIns)
	{
		if(![superIns.childViewControllers containsObject:childIns])
		{
			[superIns pushViewController:childIns animated:YES];
		}
	};
}

+(RealizeHandlerBlock)realizeUITabBarControllerToUIViewController
{
	return ^void(UITabBarController* superIns,UIViewController* childIns)
	{
		if(![superIns.childViewControllers containsObject:childIns])
		{
			[superIns addChildViewController:childIns];
		}
	};
}
@end
