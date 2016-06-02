//
//  DIRouter+Xml.m
//  DIKit
//
//  Created by Back on 16/5/19.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "DIRouter+Xml.h"
#import "DITools.h"
#import "DIRouter+Assemble.h"
#import "DIContainer.h"
#import "NUISettings.h"
#import "NSObject+Runtimes.h"
#import "DIAttribute.h"
#import "DINode+Make.h"
#import "DIConverter.h"

@implementation DIRouter (Xml)

+(void)registryXmlDirectory:(NSString*)directory
{
	NSString* dirPath = [[[NSBundle mainBundle]resourcePath]stringByAppendingPathComponent:directory];
	
	NSArray* files = [DIIO filesWithSuffix:@"xml" atPath:dirPath];
	for (NSString* xmlFile in files)
 	{
		NSString* fullPath = [dirPath stringByAppendingPathComponent:xmlFile];
		NSString* xmlString = [[NSString alloc]initWithContentsOfFile:fullPath encoding:NSUTF8StringEncoding error:nil];
		[self registryRealizeXml:xmlString];
	}
}

+(void)registryRealizeXml:(NSString*)xmlString
{
	if(!DITree.instance)
	{
		[DITree.instance newWithXML:xmlString];
	}
	else
	{
		[DITree.instance updateWithXML:xmlString];
	}
}

+(void)remakeRealizeXml:(NSString*)xmlString
{
	if(!DITree.instance)
	{
		[DITree.instance newWithXML:xmlString];
	}
	else
	{
		[DITree.instance remakeWithXML:xmlString];
	}
}

+(id)realizeNode:(DINode*)node
{
	[self makeLogicTree:node];
	[self delay:node];
	return node.implement;
}

+(DINode*)makeLogicTree:(DINode*)node
{
	for (DINode* child in node.children)
	{
		//实例化全部子成员
		if([child isProperty])
		{
			child.implement = [self realizeValueNode:child];
			if(!child.implement)
			{
				[self makeLogicTree:child];
			}
			node.attributes[child.property]=child.implement;
		}
		else
		{
			[self makeLogicTree:child];
		}
	}
	node.implement = [node makeInstance];
	for (DINode* child in node.children)
	{
		//处理默认的组装
		if(![child isProperty])
		{
			RealizeHandlerBlock block = [DIRouter blockToAddElement:child.className toParent:node.className];
			if(block)
			{
				block(node.implement,child.implement);
			}
			else
				WarnLog(@"Add %@ to %@ failed.",child.name,node.name);
		}
	}
	
	[self patchAttribute:node];
	return node;
}

+(DINode*)patchAttribute:(DINode*)node
{
	//for(DINode* child in node.children)
	//{
		//[self patchAttribute:child];
	//}
	
	[self autoSetNUIClass:node.name withInstance:node.implement];
	[node.implement updateByNode:node];
	
	return node;
}

+(DINode*)delay:(DINode*)node
{
	for(DINode* child in node.children)
	{
		[self delay:child];
	}
	
	[node.constraints enumerateKeysAndObjectsUsingBlock:^(NSArray<DINodeLayoutConstraint *> * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
		for (DINodeLayoutConstraint* constraint in key)
		{
			[constraint realizeConstant];
		}
	}];
	
	return node;
}

+(id)realizeValueNode:(DINode*)node
{
	if([node.clazz isSubclassOfClass:NSString.class])
	{
		return [NSString stringWithString:node.attributes[@"init"]];
	}
	else if ([node.clazz isSubclassOfClass:UIImage.class])
	{
		return [UIImage imageNamed:node.attributes[@"name"]];
	}
	else if ([node.clazz isSubclassOfClass:UIColor.class])
	{
		return [DIConverter toColor:node.attributes[@"init"]];
	}
	return nil;
}

+(void)autoSetNUIClass:(NSString*)element withInstance:(id)instance
{
	NUISettings*nuiInstance = [NUISettings invokeMethod:@"getInstance"];
	if(nuiInstance.styles[element]!=nil)
	{
		if([NSString isNilOrEmpty:[instance valueForKey:@"nuiClass"]])
		{
			[instance setValue:element forKey:@"nuiClass"];
		}
	}
}
@end
