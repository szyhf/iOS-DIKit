//
//  RouterXmlParser.m
//  DIKit
//
//  Created by Back on 16/5/19.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "RouterXmlParser.h"
#import "DITools.h"
#import "DIContainer.h"
#import "DIRouter+Assemble.h"

@interface RouterXmlParser ()
@property(nonatomic)NSMutableArray<NSString*>* stack;
@property(nonatomic)NSMutableDictionary<NSString*,NSMutableArray<NSString*>*>* nodes;
@property(nonatomic)NSMutableDictionary<NSString*,NSDictionary<NSString *, NSString *> *>* attributes;
@end

@implementation RouterXmlParser
@synthesize stack;
@synthesize nodes;
@synthesize attributes;

- (instancetype)init
{
	self = [super init];
	if (self)
	{
		stack = [NSMutableArray arrayWithCapacity:10];
		nodes = [NSMutableDictionary dictionaryWithCapacity:10];
		attributes = [NSMutableDictionary dictionaryWithCapacity:10];
	}
	return self;
}

// Document handling methods
- (void)parserDidStartDocument:(NSXMLParser *)parser
{
	//DebugLog(@"Parse start");
}
// sent when the parser begins parsing of the document.
- (void)parserDidEndDocument:(NSXMLParser *)parser
{
	//DebugLog(@"Parse stop");
}
// sent when the parser has completed parsing. If this is encountered, the parse was successful.

// DTD handling methods for various declarations.
-					(void)parser:(NSXMLParser *)parser
foundNotationDeclarationWithName:(NSString *)name
		  publicID:(nullable NSString *)publicID
		  systemID:(nullable NSString *)systemID
{
	DebugLog(@"foundNotationDeclarationWithName:%@",name);
}

-						  (void)parser:(NSXMLParser *)parser
foundUnparsedEntityDeclarationWithName:(NSString *)name
			 publicID:(nullable NSString *)publicID
			 systemID:(nullable NSString *)systemID
		 notationName:(nullable NSString *)notationName
{
	DebugLog(@"foundUnparsedEntityDeclarationWithName:%@",name);
}

- (void)parser:(NSXMLParser *)parser
foundAttributeDeclarationWithName:(NSString *)attributeName
	forElement:(NSString *)elementName
		  type:(nullable NSString *)type
  defaultValue:(nullable NSString *)defaultValue;
{
	DebugLog(@"foundAttributeDeclarationWithName:%@",attributeName);
}

- (void)parser:(NSXMLParser *)parser
foundElementDeclarationWithName:(NSString *)elementName
		 model:(NSString *)model
{
	DebugLog(@"foundElementDeclarationWithName:%@",elementName);
}

- (void)parser:(NSXMLParser *)parser
foundInternalEntityDeclarationWithName:(NSString *)name
		 value:(nullable NSString *)value;
{
	DebugLog(@"foundInternalEntityDeclarationWithName:%@",name);
}

- (void)parser:(NSXMLParser *)parser
foundExternalEntityDeclarationWithName:(NSString *)name
	  publicID:(nullable NSString *)publicID
	  systemID:(nullable NSString *)systemID
{
	DebugLog(@"foundExternalEntityDeclarationWithName:%@",name);
}

// sent when the parser finds an element start tag.
// In the case of the cvslog tag, the following is what the delegate receives:
//   elementName == cvslog, namespaceURI == http://xml.apple.com/cvslog, qualifiedName == cvslog
// In the case of the radar tag, the following is what's passed in:
//    elementName == radar, namespaceURI == http://xml.apple.com/radar, qualifiedName == radar:radar
// If namespace processing >isn't< on, the xmlns:radar="http://xml.apple.com/radar" is returned as an attribute pair, the elementName is 'radar:radar' and there is no qualifiedName.
- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(nullable NSString *)namespaceURI
 qualifiedName:(nullable NSString *)qName
	attributes:(NSDictionary<NSString *, NSString *> *)attributeDict
{
	//DebugLog(@"didStartElement:%@",elementName);
	if([stack count]>0)
	{
		//[DIRouter addElement:elementName toParent:[stack lastObject]];
		[nodes[[stack lastObject]]addObject:elementName];
	}
	[stack addObject:elementName];
	nodes[elementName]=[NSMutableArray arrayWithCapacity:1];
	if ([attributeDict count]>0)
	{
		attributes[elementName]=attributeDict;
	}
}


-(void)parser:(NSXMLParser *)parser
didEndElement:(NSString *)elementName
 namespaceURI:(NSString *)namespaceURI
qualifiedName:(NSString *)qName
{
	for (NSString* element in nodes[elementName])
	{
		DebugLog(@"%@",element);
		[DIRouter addElement:element toParent:elementName];
		
		if(attributes[element]!=nil)
		{
			NSObject* elementObj = [DIContainer getInstanceByName:element];
			NSDictionary<NSString *, NSString *> *attr =attributes[element];
			for (NSString* keyPath in attr)
			{
				[elementObj setValue:attr[keyPath] forKeyPath:keyPath];
			}
			DebugLog(@"%@",attr);
			[attributes removeObjectForKey:element];
		}
	}
	[stack removeLastObject];
	[nodes[elementName] removeAllObjects];
	[nodes removeObjectForKey:elementName];
}


// sent when the namespace prefix in question goes out of scope.
- (void)parser:(NSXMLParser *)parser didEndMappingPrefix:(NSString *)prefix
{
	
}

- (void)parser:(NSXMLParser *)parser
parseErrorOccurred:(NSError *)parseError
{
	
}

// If validation is on, this will report a fatal validation error to the delegate. The parser will stop parsing.
- (void)parser:(NSXMLParser *)parser
validationErrorOccurred:(NSError *)validationError
{
	
}

@end
