//
//  DIRouter+Xml.m
//  DIKit
//
//  Created by Back on 16/5/19.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "DIRouter+Xml.h"
#import "DIRouter.h"
#import "RouterXmlParserDelegate.h"
#import "DITools.h"
#import "FlatRouterMap.h"
#import "DIRouter+Assemble.h"
#import "DIContainer.h"
#import "UIView+DILayout.h"
#import "UIViewController+DILayout.h"

@interface DIRouter()

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
	RouterXmlParserDelegate* parserFiller =[[RouterXmlParserDelegate alloc]init];
	[parserFiller fillToSettings:[self Instance].flatRouterMap];
	
	NSXMLParser* xmlParser;
	NSData* xmlData = [xmlString dataUsingEncoding:NSUTF8StringEncoding];
	[xmlParser setShouldProcessNamespaces:NO];
	[xmlParser setShouldReportNamespacePrefixes:NO];
	xmlParser =  [[NSXMLParser alloc]initWithData:xmlData];
	xmlParser.delegate = parserFiller;
	
	[xmlParser parse];
}

+(void)realizeNode:(NSString*)parent
{
	FlatRouterMap* settings = [[DIRouter Instance]flatRouterMap];
	NSArray<NSString*>* children = [settings childrenOfNode:parent];
	for(NSString* child in children)
	{
		[DIRouter addElement:child toParent:parent];
	}
	for(NSString* child in children)
	{
		NSDictionary* attr = [settings attributesOfNode:child];
		if(attr!=nil)
		{
			id obj = [DIContainer getInstanceByName:child];
			[obj setValuesForKeysWithDictionary:attr];
		}
		[DIRouter realizeNode:child];
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
