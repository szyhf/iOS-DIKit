//
//  DIRegisterNode+Awake.m
//  DIKit
//
//  Created by Back on 16/6/19.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "DIRegisterNode.h"
#import <objc/runtime.h>

@implementation DIRegisterNode (Awake)
-(void)assemblyTo:(DINode*)parentNode
{
	[super assemblyTo:parentNode];//完成默认组装以后设置为其属性。
	objc_setAssociatedObject(parentNode.implement, NSSelectorFromString(self.registry), self.implement, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
