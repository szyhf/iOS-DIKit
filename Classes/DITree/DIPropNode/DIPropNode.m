//
//  DIPropNode.m
//  Pods
//
//  Created by Back on 16/6/3.
//
//

#import "DIPropNode.h"
#import "DIConverter.h"
@interface DIPropNode()
@property (nonatomic, strong) NSString* property;
@end

@implementation DIPropNode
-(instancetype)initWithElement:(NSString *)element andNamespaceURI:(NSString *)namespaceURI andAttributes:(NSDictionary<NSString *,NSString *> *)attributes
{
	self = [super initWithElement:element andNamespaceURI:namespaceURI andAttributes:attributes];
	if(self)
	{
		//处理属性项目
		/**
		 * 1、attributes[@"prop"];
		 * 2、name
		 */
		self.property = attributes[@"prop"];
	}
	return self;
}
-(id)makeInstance
{
	id nodeInstance = [self realizeValueNode];
	if(nodeInstance)
		return nodeInstance;
	
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

-(void)assemblyTo:(DINode *)parentNode
{
	parentNode.attributes[self.property]=self.implement;
}

-(id)realizeValueNode
{
	if([self.clazz isSubclassOfClass:NSString.class])
	{
		return [NSString stringWithString:self.attributes[@"init"]];
	}
	else if ([self.clazz isSubclassOfClass:UIImage.class])
	{
		return [UIImage imageNamed:self.attributes[@"name"]];
	}
	else if ([self.clazz isSubclassOfClass:UIColor.class])
	{
		return [DIConverter toColor:self.attributes[@"init"]];
	}
	return nil;
}
@end
