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
	
	@try
	{
		if([parserResult isAbsolute])
		{
			targetNode = nil;
		}
		else if([NSString isNilOrEmpty:parserResult.target])
		{
			targetNode = parentNode;
		}
		else if([parserResult.target hasPrefix:@"#"])
		{
			NSScanner* scaner = [NSScanner scannerWithString:parserResult.target];
			[scaner scanString:@"#" intoString:nil];
			NSInteger index=0;
			NSInteger(^targetInitBlock)(NSInteger index);
			if([scaner scanString:@"last" intoString:nil])
			{
				targetInitBlock=^NSInteger(NSInteger index)
				{
					if(index==0)
						index = 1;
					return [parentNode.children indexOfObject:self.oriNode]-index;
				};
			}
			if([scaner scanString:@"next" intoString:nil])
			{
				targetInitBlock=^NSInteger(NSInteger index)
				{
					if(index==0)
						index = 1;
					return [parentNode.children indexOfObject:self.oriNode]+index;
				};
			}
			[scaner scanInteger:&index];
			
			if(targetInitBlock)
				index = targetInitBlock(index);
			
			targetNode = [parentNode childOfIndex:index];
		}
		else if([parserResult.target hasPrefix:@"$"])
		{
			NSScanner* scaner = [NSScanner scannerWithString:parserResult.target];
			[scaner scanString:@"$" intoString:nil];

			if([scaner scanString:@"self" intoString:nil])
			{
				targetNode = self.oriNode;
			}
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
		
		NSLayoutConstraint* constraint =
		[NSLayoutConstraint constraintWithItem:[self layoutItem:oriNode]
									 attribute:[DILayoutKey layoutAttributeOf:parserResult.oriAttribute]
									 relatedBy:parserResult.relation
										toItem:[self layoutItem:targetNode]
									 attribute:[DILayoutKey layoutAttributeOf:parserResult.targetAttribute]
									multiplier:parserResult.mutiply
									  constant:parserResult.offset];
		
		[(UIView*)constraint.firstItem setTranslatesAutoresizingMaskIntoConstraints:NO];
		
		/*
		 	有三种情况要分别处理：
		 	1、当前元素的约束目标是父元素有关，约束添加到父元素。
		 	2、当前元素的约束目标是兄弟元素有关，设置兄弟元素的autoresizing，约束添加到父元素。
		 	3、当前元素的约束目标是自己，约束添加给自己。
		 */
		
		if(parentNode!=targetNode)
			[(UIView*)constraint.secondItem setTranslatesAutoresizingMaskIntoConstraints:NO];
		
		constraint.priority = parserResult.priority;
		UIView* tempView;
		if(oriNode==targetNode)
		{
			//因为目标也是自己，替换约束父节点为自己。
			parentNode = oriNode;
		}
		
		tempView = [self layoutItem:parentNode];
		
		if(tempView)
		{
			[tempView addConstraint:constraint];
		}
	}
	@catch (NSException *exception)
	{
		WarnLog(@"%@\n%@",self,exception);
	}
}


-(id)layoutItem:(DINode*)node
{
	UIView* tempView;
	if([node.implement isKindOfClass:UITableViewCell.class])
	{
		UITableViewCell* cell = node.implement;
		tempView = cell.contentView;
	}
	else if([node.implement isKindOfClass:UICollectionViewCell.class])
	{
		UICollectionViewCell* cell = node.implement;
		tempView = cell.contentView;
	}
	else if([node.implement isKindOfClass:UIView.class])
	{
		tempView = (UIView*)node.implement;
	}
	else if([node.implement isKindOfClass:UIViewController.class])
	{
		tempView = [(UIViewController*)node.implement view];
	}
	return tempView;
}

-(NSString*)description
{
	NSMutableString* description = [NSMutableString stringWithFormat:@"<DINodeLayoutConstraint %p> ",self];
	
	NSString* relate;
	switch(parserResult.relation)
	{
		case NSLayoutRelationLessThanOrEqual:
			relate = @"<=";
			break;
		case NSLayoutRelationEqual:
			relate = @"=";
			break;
		case NSLayoutRelationGreaterThanOrEqual:
			relate = @">=";
			break;
	}
	
	[description appendFormat:@"%@<%p #%lu>.%@ %@ %@<%p #%lu>.%@",oriNode.name,oriNode.implement,(unsigned long)[oriNode.parent.children indexOfObject:oriNode],parserResult.oriAttribute,relate,targetNode.name,targetNode.implement,(unsigned long)[targetNode.parent.children indexOfObject:targetNode],parserResult.targetAttribute];
	
	return description;
}

@end
