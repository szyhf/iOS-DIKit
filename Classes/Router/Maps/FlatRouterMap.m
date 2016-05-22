//
//  DIRouterSettings.m
//  DIKit
//
//  Created by Back on 16/5/20.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "FlatRouterMap.h"
@interface FlatRouterMap ()
@property(nonatomic)NSMutableDictionary<NSString*,NSMutableArray<NSString*>*>* nodes;
@property(nonatomic)NSMutableDictionary<NSString*,NSDictionary<NSString *, NSString *> *>* nodesAttributes;
@end

@implementation FlatRouterMap

-(void)addChild:(NSString*)child
		 toNode:(NSString*)node
{
	if(self.nodes[node]==nil)
		self.nodes[node]=[NSMutableArray arrayWithCapacity:1];
	[self.nodes[node]addObject:child];
}

-(void)removeChild:(NSString*)child
			ofNode:(NSString*)node
{
	[self.nodes[node]removeObject:child];
}

-(void)removeNode:(NSString*)node
{
	[self.nodes removeObjectForKey:node];
}

-(NSArray<NSString*>*)childrenOfNode:(NSString*)node
{
	return self.nodes[node];
}

-(void)addAttributes:(NSDictionary<NSString *, NSString *> *)attributes
			  toNode:(NSString*)node
{
	if (attributes.count >0)
	{
		if(self.nodesAttributes[node]==nil)
			self.nodesAttributes[node]=attributes;
		else
		{
			NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithDictionary:self.nodesAttributes[node]];
			for (NSString* attrKey in attributes)
			{
				dict[attrKey]=attributes[attrKey];
			}
			self.nodesAttributes[node]=dict;
		}
	}
}

-(void)removeAttributesOfNode:(NSString*)node
{
	[self.nodesAttributes removeObjectForKey:node];
}

-(NSDictionary<NSString *, NSString *> *)attributesOfNode:(NSString*)node
{
	return self.nodesAttributes[node];
}

-(NSString*)description
{
	NSString* superDes = [super description];
	NSString* nodesString = [NSString stringWithFormat:@"Nodes:\n%@",self.nodes];
	NSString* attrString = [NSString stringWithFormat:@"NodesAttributes:\n%@",self.nodesAttributes];
	
	return [NSString stringWithFormat:@"%@\n%@\n%@",superDes,nodesString,attrString];
}

#pragma mark -- property

- (NSMutableDictionary<NSString*,NSDictionary<NSString *, NSString *> *> *)nodesAttributes
{
	if(_nodesAttributes == nil)
 	{
		_nodesAttributes = [[NSMutableDictionary<NSString*,NSDictionary<NSString *, NSString *> *> alloc] init];
	}
	return _nodesAttributes;
}

- (NSMutableDictionary<NSString*,NSMutableArray<NSString*>*> *)nodes
{
	if(_nodes == nil)
	{
		_nodes = [[NSMutableDictionary<NSString*,NSMutableArray<NSString*>*> alloc] init];
	}
	return _nodes;
}

@end
