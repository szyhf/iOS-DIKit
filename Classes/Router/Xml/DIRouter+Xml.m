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
	[self patchAttribute:node];
	return node.Implement;
}

+(DINode*)makeLogicTree:(DINode*)node
{
	node.Implement = [node makeInstance];
	
	for (DINode* child in node.children)
	{
		if([child isProperty])
		{
			child.Implement = [self realizeValueNode:child];
			if(!child.Implement)
			{
				[self makeLogicTree:child];
			}
			node.attributes[child.property]=child.Implement;
			//[node.Implement setValue:child.Implement forKeyPath:child.property];
		}
		else
		{
			[self makeLogicTree:child];
			RealizeHandlerBlock block = [DIRouter blockToAddElement:child.className toParent:node.className];
			if(block)
				block(node.Implement,child.Implement);
			else
				WarnLog(@"Add %@ to %@ failed.",child.name,node.name);
		}
	}
	return node;
}

+(DINode*)patchAttribute:(DINode*)node
{
	for(DINode* child in node.children)
	{
		[self patchAttribute:child];
	}
	
	[self autoSetNUIClass:node.name withInstance:node.Implement];
	[node.Implement updateByNode:node];
	
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
