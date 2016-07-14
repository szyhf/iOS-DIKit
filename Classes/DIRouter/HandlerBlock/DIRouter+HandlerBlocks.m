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
#import "DITableView.h"
#import "DIHidden.h"

@implementation DIRouter (HandlerBlocks)
+(RealizeHandlerBlock)realizeUIViewToDIHidden
{
	return ^void(NSObject*parent ,DIHidden* hidden)
	{
		//不用做,Hidden用于存储临时属性
	};
}

+(RealizeHandlerBlock)realizeDITableViewToDITableViewSection
{
	return ^void(DITableView*tableView ,DITableViewSection* tableViewSection)
	{
		[tableView addSectionsObject:tableViewSection];
	};
}

+(RealizeHandlerBlock)realizeUIViewControllerToUITabBarItem
{
	return ^void(UIViewController*viewCtrl ,UITabBarItem* tabBarItem)
	{
		viewCtrl.tabBarItem = tabBarItem;
	};
}

+(RealizeHandlerBlock)realizeUIViewControllerToUICollectionViewCell
{
	return ^void(UIViewController*viewCtrl ,UICollectionViewCell* cell)
	{
		if(![viewCtrl.view.subviews containsObject:cell.contentView]
		   && ![viewCtrl.view.subviews containsObject:cell])
		{
			[viewCtrl.view addSubview:cell.contentView];
		}
	};
}

+(RealizeHandlerBlock)realizeUIViewToUICollectionViewCell
{
	return ^void(UIView*view ,UICollectionViewCell* cell)
	{
		if(![view.subviews containsObject:cell.contentView]
		   && ![view.subviews containsObject:cell])
		{
			[view addSubview:cell.contentView];
		}
	};
}

+(RealizeHandlerBlock)realizeUICollectionViewCellToUIView
{
	return ^void(UICollectionViewCell* cell,UIView* view)
	{
		[cell.contentView addSubview:view];
	};
}

+(RealizeHandlerBlock)realizeUIViewToUIViewController
{
	return ^void(UIView* view,UIViewController* viewCtrl)
	{
		if(![view.subviews containsObject:viewCtrl.view])
		{
			[view addSubview:viewCtrl.view];
		}
	};
}

+(RealizeHandlerBlock)realizeUIViewControllerToUITableViewCell
{
	return ^void(UIViewController*viewCtrl ,UITableViewCell* cell)
	{
		if(![viewCtrl.view.subviews containsObject:cell.contentView]
		   && ![viewCtrl.view.subviews containsObject:cell])
		{
			[viewCtrl.view addSubview:cell.contentView];
		}
	};
}

+(RealizeHandlerBlock)realizeUIViewToUITableViewCell
{
	return ^void(UIView*view ,UITableViewCell* cell)
	{
		if(![view.subviews containsObject:cell.contentView]
		   && ![view.subviews containsObject:cell])
		{
			[view addSubview:cell.contentView];
		}
	};
}

+(RealizeHandlerBlock)realizeUITableViewCellToUIView
{
	return ^void(UITableViewCell* cell,UIView* view)
	{
		[cell.contentView addSubview:view];
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
		if(![parentView.subviews containsObject:childView])
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
