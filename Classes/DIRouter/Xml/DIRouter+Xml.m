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
	[node awake];
	return node.implement;
}
@end
