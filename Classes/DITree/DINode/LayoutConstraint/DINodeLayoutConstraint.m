//
//  DINodeLayoutConstant.m
//  DIKit
//
//  Created by Back on 16/6/1.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "DINodeLayoutConstraint.h"
#import "DITools.h"
#import "DILayoutKey.h"
@interface DINodeLayoutConstraint()
@property (nonatomic, weak) DINode* oriNode;
@property (nonatomic, weak) DINode* targetNode;
@property (nonatomic, strong) DILayoutParserResult* parserResult;
@end

@implementation DINodeLayoutConstraint
@synthesize oriNode;
@synthesize targetNode;
@synthesize parserResult;

-(instancetype)initWithOriNode:(DINode*)node
				  parserResult:(DILayoutParserResult*)result
{
	self = [super init];
	
	if(self)
	{
		[self setOriNode:node];
		[self setParserResult:result];
	}
	
	return self;
}

-(void)realizeConstant
{
	DINode* parentNode = oriNode.parent;
	if(!parentNode)	return;
	if([parserResult isAbsolute])
	{
		targetNode = nil;
	}
	else if([NSString isNilOrEmpty:parserResult.target])
	{
		targetNode = parentNode;
	}
	else if([parserResult.target startsWith:@"#"])
	{
		NSInteger indexOfBrother = [[parserResult.target trimStart:@"#"] integerValue];
		targetNode = [parentNode childOfIndex:indexOfBrother];
	}
	else
	{
		for (DINode* child in parentNode.children)
		{
			if([child.name isEqualToString:parserResult.target])
			{
				targetNode = child;
				break;
			}
		}
	}
	
	@try
	{
		NSLayoutConstraint* constraint =
		[NSLayoutConstraint constraintWithItem:[self layoutItem:oriNode]
									 attribute:[DILayoutKey layoutAttributeOf:parserResult.oriAttribute]
									 relatedBy:parserResult.relation
										toItem:[self layoutItem:targetNode]
									 attribute:[DILayoutKey layoutAttributeOf:parserResult.targetAttribute]
									multiplier:parserResult.mutiply
									  constant:parserResult.offset];
		
		[(UIView*)constraint.firstItem setTranslatesAutoresizingMaskIntoConstraints:NO];
		if(parentNode!=targetNode)
			[(UIView*)constraint.secondItem setTranslatesAutoresizingMaskIntoConstraints:NO];
		
		constraint.priority = parserResult.priority;
		UIView* tempView;
		if([parentNode.Implement isKindOfClass:UIView.class])
		{
			tempView = (UIView*)parentNode.Implement;
		}
		
		if([parentNode.Implement isKindOfClass:UIViewController.class])
		{
			tempView = [(UIViewController*)parentNode.Implement view];
		}
		if(tempView)
		{
			[tempView addConstraint:constraint];
		}
	}
 	@catch (NSException *exception)
	{
		WarnLog(@"%@",exception);
	}
}

-(id)layoutItem:(DINode*)node
{
	UIView* tempView;

	if([node.Implement isKindOfClass:UIView.class])
	{
		tempView = (UIView*)node.Implement;
	}
	
	if([node.Implement isKindOfClass:UIViewController.class])
	{
		tempView = [(UIViewController*)node.Implement view];
	}
	return tempView;
}

@end
