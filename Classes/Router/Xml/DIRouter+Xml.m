//
//  DIRouter+Xml.m
//  DIKit
//
//  Created by Back on 16/5/19.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "DIRouter+Xml.h"
#import "DIRouter.h"
#import "RouterXmlParser.h"

@interface DIRouter()
@end

@implementation DIRouter (Xml)

+(void)realizeXmlFile:(NSString*)xmlFilePath
{
	NSString* filePath = [[NSBundle mainBundle]pathForResource:@"Main" ofType:@"xml"];
	NSString* content = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
	
	[self realizeXml:content];
}

+(void)realizeXml:(NSString*)xmlString
{
	
	NSXMLParser* xmlParser;
	NSData* xmlData = [xmlString dataUsingEncoding:NSUTF8StringEncoding];
	xmlParser =  [[NSXMLParser alloc]initWithData:xmlData];
	RouterXmlParser* parser =[[RouterXmlParser alloc]init];
	xmlParser.delegate = parser;
	[xmlParser setShouldProcessNamespaces:NO];
	[xmlParser setShouldReportNamespacePrefixes:NO];
	
	[xmlParser parse];
}

@end
