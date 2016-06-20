//
//  DIRegisterNode.m
//  DIKit
//
//  Created by Back on 16/6/19.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "DIRegisterNode.h"

@implementation DIRegisterNode
-(instancetype)initWithElement:(NSString*)element
				  andNamespaceURI:(NSString *)namespaceURI
				 andAttributes:(NSDictionary<NSString*,NSString*>*)attributes
{
	self = [super initWithElement:element andNamespaceURI:namespaceURI andAttributes:attributes];
	self.registry = attributes[@"reg"];
	if(!self.registry)
	{
		self.registry = self.name;
	}
	return self;
}
- (NSString *)registry
{
	return _registry;
}
@end
