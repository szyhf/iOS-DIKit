//
//  DIRouter+Xml.m
//  DIKit
//
//  Created by Back on 16/5/19.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "DIRouter+Xml.h"
#import "RouterXmlParserDelegate.h"
#import "DITools.h"
#import "FlatRouterMap.h"
#import "DIRouter+Assemble.h"
#import "DIContainer.h"
#import "NUISettings.h"
#import "NSObject+Runtimes.h"
#import "DIAttribute.h"
#import "NSObject+DIAttribute.h"
#import "DINode+Make.h"
#import "DIConverter.h"

@interface DIRouter()
{
	
}
@end

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
	DIRouter* instance = [self Instance];
	if(!instance.uiTree)
	{
		instance.uiTree = [[DITree alloc]initWithRootXML:xmlString];
	}
	else
	{
		[instance.uiTree updateWithXML:xmlString];
	}
}

+(void)remakeRealizeXml:(NSString*)xmlString
{
	DIRouter* instance = [self Instance];
	if(!instance.uiTree)
	{
		instance.uiTree = [[DITree alloc]initWithRootXML:xmlString];
	}
	else
	{
		[instance.uiTree remakeWithXML:xmlString];
	}
}

+(id)realizeNode:(DINode*)node
{
	id nodeInstance = [node makeInstance];
	[node setValue:nodeInstance forKey:@"implement"];
	
	for (DINode* child in node.children)
    {
		if([child isProperty])
		{
			id childInstance = [self realizeValueNode:child];
			[nodeInstance setValue:childInstance forKeyPath:child.property];
			[child setValue:childInstance forKey:@"implement"];
		}
		else
		{
			id childInstance = [self realizeNode:child];
			RealizeHandlerBlock block = [DIRouter blockToAddElement:child.className toParent:node.className];
			block(nodeInstance,childInstance);
		}
	}
	
	for(DINode* child in node.children)
	{
		if(![child isProperty])
		{
			id instance = [child valueForKey:@"implement"];
			[instance updateByNode:child];
			[self autoSetNUIClass:child.name withInstance:instance];
		}
	}
	
	return nodeInstance;
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

+(void)realizeXml:(NSString*)xmlString
{
	RouterXmlParserDelegate* parserDelegate =[[RouterXmlParserDelegate alloc]init];
	
	NSXMLParser* xmlParser;
	NSData* xmlData = [xmlString dataUsingEncoding:NSUTF8StringEncoding];
	xmlParser = [[NSXMLParser alloc]initWithData:xmlData];
	[xmlParser setShouldProcessNamespaces:NO];
	[xmlParser setShouldReportNamespacePrefixes:NO];
	xmlParser.delegate = parserDelegate;
	
	[xmlParser parse];
}

@end
