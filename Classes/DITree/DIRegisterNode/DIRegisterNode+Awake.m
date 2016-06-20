//
//  DIRegisterNode+Awake.m
//  DIKit
//
//  Created by Back on 16/6/19.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "DIRegisterNode.h"

@implementation DIRegisterNode (Awake)
-(void)assemblyTo:(DINode*)parentNode
{
	[super assemblyTo:parentNode];//完成默认组装以后设置为其属性。
	[parentNode.implement setValue:self.implement forKeyPath:self.registry];
}
@end
