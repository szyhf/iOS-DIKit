//
//  DIRouter+JsonTree.m
//  Pods
//
//  Created by Back on 16/5/17.
//
//

#import "DIRouter+JsonTree.h"

@implementation DIRouter (JsonTree)
+(void)realizeJson:(NSString*)jsonTree
{
	NSDictionary* tree = [jsonTree jsonDictionary];
	if (tree==nil)
    {
		return;
	}
	[DIRouter relizeTree:tree];
}

+(void)relizeTree:(NSDictionary*)tree
{
	for (NSString* key in tree)
	{
		
	}
}

@end
