//
//  DITree.m
//  DIKit
//
//  Created by Back on 16/5/26.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "DITree.h"
#import "DITools.h"
typedef NS_ENUM(NSInteger,ParseStatus)
{
	ParseStatusNew,
	ParseStatusUpdate,
	ParseStatusRemake,
};
@interface DITree()<NSXMLParserDelegate>
{
	DINode* _root;
	ParseStatus parseStatus;
}
@property (nonatomic, strong) NSMutableDictionary<NSString*,DINode*>* pathToNode;
@property (nonatomic, strong) NSMutableDictionary<NSString*,DINode*>* nameToNode;
@property (nonatomic, strong) NSMutableDictionary<DINode*,NSString*>* nodeOfPath;
@end

@implementation DITree
+(instancetype)instance
{
	static DITree *_instance;
	static dispatch_once_t _tree_token;
	dispatch_once(&_tree_token,
				  ^{
					  _instance = [[DITree alloc]init] ;
				  });
	return _instance;
}

-(void)newWithXML:(NSString*)xmlString
{
	[self parseXML:xmlString status:ParseStatusNew];
}

-(void)updateWithXML:(NSString*)xmlString
{
	[self parseXML:xmlString status:ParseStatusUpdate];
}
-(void)remakeWithXML:(NSString*)xmlString
{
	[self parseXML:xmlString status:ParseStatusRemake];
}
-(void)parseXML:(NSString*)xmlString status:(ParseStatus)status
{
	self->parseStatus = status;
	
	NSData* xmlData = [xmlString dataUsingEncoding:NSUTF8StringEncoding];
	
	NSXMLParser* xmlParser;
	[xmlParser setShouldProcessNamespaces:NO];
	[xmlParser setShouldReportNamespacePrefixes:NO];
	xmlParser =  [[NSXMLParser alloc]initWithData:xmlData];
	xmlParser.delegate = self;
	[xmlParser parse];
}

- (DINode *)root
{
	return self->_root;
}

static DINode* onParseringNode ;

- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(nullable NSString *)namespaceURI
 qualifiedName:(nullable NSString *)qName
	attributes:(NSDictionary<NSString *, NSString *> *)attributeDict
{
	DINode* child = [[DINode alloc]
					 initWithElement:elementName
					 andNamespaceURI:namespaceURI
					 andAttributes:attributeDict];
	if(onParseringNode)
	{
		[onParseringNode addChild:child];
	}
	else if(self->parseStatus != ParseStatusUpdate)
	{
		self->_root = child;
	}
	onParseringNode = child;
	
	if(onParseringNode.isGlobal)
	{
		[self autoSetNameToNode:onParseringNode];
	}
}

-(void)parser:(NSXMLParser *)parser
didEndElement:(NSString *)elementName
 namespaceURI:(NSString *)namespaceURI
qualifiedName:(NSString *)qName
{
	onParseringNode = onParseringNode.parent;
}

-(void)autoSetNameToNode:(DINode*)node
{
	switch (parseStatus)
	{
		case ParseStatusUpdate:
		{
			if(self.nameToNode[node.name])
			{
				//todo: update Node.
				break;
			}
		}
		case ParseStatusNew:
		{
			WarnLogWhile(self.nameToNode[node.name],@"Duplicate global node named %@",node.name);
		}
		case ParseStatusRemake:
		{
			self.nameToNode[node.name] = node;
			break;
		}
	}
}

-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
	FatalLog(@"%@",parseError);
}

- (NSMutableDictionary<NSString*,DINode*> *)nameToNode
{
	if(_nameToNode == nil) {
		_nameToNode = [[NSMutableDictionary<NSString*,DINode*> alloc] init];
	}
	return _nameToNode;
}

@end
