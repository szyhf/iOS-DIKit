//
//  UIViewControllerObserver.h
//  Fakeshion
//
//  Created by Back on 16/5/3.
//  Copyright © 2016年 Back. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DIRouterParentViewObserver : UINavigationController
- (void)observeValueForKeyPath:(NSString *)keyPath
					  ofObject:(id)object
						change:(NSDictionary *)change
					   context:(void *)context;
@end
