//
//  DINode+Make.m
//  Pods
//
//  Created by Back on 16/5/27.
//
//

#import "DINode+Make.h"
#import "DIContainer.h"

@implementation DINode (Make)
-(id)makeInstance
{
	id nodeInstance;
	if([self isGlobal])
	{
		nodeInstance = [DIContainer getInstance:self.clazz];
		[DIContainer setAlias:self.name forInstance:nodeInstance];
	}
	else
	{
		//局部成员
		nodeInstance = [DIContainer makeInstance:self.clazz];
	}
	return nodeInstance;
}
@end
