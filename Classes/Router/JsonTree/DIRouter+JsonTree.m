//
//  DIRouter+JsonTree.m
//  Pods
//
//  Created by Back on 16/5/17.
//
//

#import "DIRouter+JsonTree.h"
#import "DIRouter+Assemble.h"

@implementation DIRouter (JsonTree)

+(void)relizeTree:(NSDictionary*)treeRootNode
{
	NSMutableArray<NSDictionary*>* stack = [NSMutableArray arrayWithCapacity:10];
	[stack addObject:treeRootNode];
	
	while ([stack count]!=0)
 	{
		//出栈
		NSDictionary* node = [stack lastObject];
		[stack removeLastObject];
		
		for (NSString* nodeKey in node)
		{
			id nodeValue = node[nodeKey];
			if([nodeValue isKindOfClass:[NSDictionary class]])
			{
				//当前节点的这个子节点是字典的时候
				NSDictionary* childNode = nodeValue;
				for(NSString* childNodeKey in childNode)
				{
					[self addElement:childNodeKey toParent:nodeKey];
				}
				[stack addObject:childNode];
			}
			else if([nodeValue isKindOfClass:[NSArray class]])
			{
				//当前节点的这个子节点是数组
				NSArray* childArray = nodeValue;
				for (id childNodeValue in childArray)
				{
					if([childNodeValue isKindOfClass:[NSString class]])
					{
						//这是叶子节点=。=
						NSString* childElement = (NSString*)childNodeValue;
						[self addElement:childElement toParent:nodeKey];
					}
					else if([childNodeValue isKindOfClass:[NSDictionary class]])
					{
						//还可能有子项
						//当前节点的这个子节点是字典的时候
						NSDictionary* childNode = childNodeValue;
						for(NSString* childNodeKey in childNode)
						{
							[self addElement:childNodeKey toParent:nodeKey];
						}
						[stack addObject:childNode];
					}
						
				}
			}
			else if([nodeValue isKindOfClass:[NSString class]])
			{
				//这是叶子节点=。=
				NSString* childElement = (NSString*)nodeValue;
				[self addElement:childElement toParent:nodeKey];
			}
		}
	}	
}

@end
