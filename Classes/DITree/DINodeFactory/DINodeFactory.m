//
//  DINodeFactory.m
//  DIKit
//
//  Created by Back on 16/6/3.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "DINodeFactory.h"
#import "DIPropNode.h"
#import "DITemplateNode.h"
#import "DIRegisterNode.h"

@implementation DINodeFactory
+(DINode*)newNodeWithElement:(NSString*)element
			 andNamespaceURI:(NSString *)namespaceURI
			   andAttributes:(NSDictionary<NSString*,NSString*>*)attributes
{
	//判断template属性
	if(attributes[@"template"])
		return [[DITemplateNode alloc]initWithElement:element andNamespaceURI:namespaceURI andAttributes:attributes];
	
	//判断prop属性
	if(attributes[@"prop"])
		return [[DIPropNode alloc]initWithElement:element andNamespaceURI:namespaceURI andAttributes:attributes];
	
	//判断ref属性
	if(attributes[@"template"])
		return nil;
	
	//判断reg属性
	if(attributes[@"reg"])
		return [[DIRegisterNode alloc]initWithElement:element andNamespaceURI:namespaceURI andAttributes:attributes];
	
	//普通的node
	return [[DINode alloc]initWithElement:element andNamespaceURI:namespaceURI andAttributes:attributes];
}
@end
