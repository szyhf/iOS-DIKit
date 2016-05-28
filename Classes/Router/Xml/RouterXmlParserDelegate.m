//
//  RouterXmlParser.m
//  DIKit
//
//  Created by Back on 16/5/19.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "RouterXmlParserDelegate.h"
#import "DITools.h"
#import "DIContainer.h"
#import "DIRouter+Assemble.h"
#import "DITree.h"

@interface RouterXmlParserDelegate ()
{
	FlatRouterMap* flatRouterSettings;
}
@property(nonatomic)NSMutableArray<NSString*>* stack;
@property (nonatomic, strong) DITree* diTree;
@end

@implementation RouterXmlParserDelegate
@synthesize stack;

- (instancetype)init
{
	self = [super init];
	if (self)
	{
		stack = [NSMutableArray arrayWithCapacity:10];
	}
	return self;
}

-(void)fillToSettings:(FlatRouterMap*)flatSettings
{
	self->flatRouterSettings = flatSettings;
}

- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(nullable NSString *)namespaceURI
 qualifiedName:(nullable NSString *)qName
	attributes:(NSDictionary<NSString *, NSString *> *)attributeDict
{
	//DebugLog(@"didStartElement:%@",elementName);

	if([stack count]>0)
	{
		[self->flatRouterSettings addChild:elementName
									toNode:stack.lastObject];
	}
	[stack addObject:elementName];
	
	[self->flatRouterSettings addAttributes:attributeDict
									 toNode:elementName];
	
	
	
}


-(void)parser:(NSXMLParser *)parser
didEndElement:(NSString *)elementName
 namespaceURI:(NSString *)namespaceURI
qualifiedName:(NSString *)qName
{	
	[stack removeLastObject];
}

- (void)parser:(NSXMLParser *)parser
parseErrorOccurred:(NSError *)parseError
{
	FatalLog(@"Parse Router Xml failed, %@",parseError);
}

@end
