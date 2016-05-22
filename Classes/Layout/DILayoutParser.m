//
//  DILayoutParser.m
//  DIKit
//
//  Created by Back on 16/5/22.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "DILayoutParser.h"
#import "DITools.h"
@interface DILayoutParser()
@property (nonatomic, strong) NSMutableArray<NSString*>* parseQueue;
@end

@implementation DILayoutParser

-(void)parserFormula:(NSString*)layoutFormula
{
	//[NSLayoutConstraint
	 //constraintWithItem:<#(nonnull id)#>
	 //attribute:<#(NSLayoutAttribute)#>
	 //relatedBy:<#(NSLayoutRelation)#>
	 //toItem:<#(nullable id)#>
	 //attribute:<#(NSLayoutAttribute)#>
	 //multiplier:<#(CGFloat)#>
	 //constant:<#(CGFloat)#>];
	
	const char* formula = [layoutFormula UTF8String];
	
	NSMutableString* currentString = [NSMutableString string];
	for(int i=0; i<layoutFormula.length; i++)
	{
		//split words: < > : + - *
		switch (formula[i]) {
			case '<':
			case '>':
			case '=':
				
			case ':':
			
			case '*':
			case '/':
			
			case '+':
			case '-':
			{
				[self.parseQueue addObject:[NSString stringWithString:currentString]];
				[self.parseQueue addObject:[NSString stringWithFormat:@"%c",formula[i]]];
				currentString=[NSMutableString string];
				break;
			}
			default:
			{
				[currentString appendFormat:@"%c",formula[i]];
    			break;
			}
		}
	}
	[self.parseQueue addObject:[NSString stringWithString:currentString]];
	if([[self.parseQueue firstObject]isEmpty])
		[self.parseQueue removeFirstObject];
	if([[self.parseQueue lastObject]isEmpty])
		[self.parseQueue removeLastObject];

	DebugLog(@"%ld%@:%@*%.1f+%.1f"
			 ,[self parseRelation]
			 ,[self parseTargetName]
			 ,[self parseTargetAttributeName]
			 ,[self parseMultiply]
			 ,[self parseConstant]);
}

-(NSLayoutRelation)parseRelation
{
	if([self.parseQueue.firstObject isEqualToString:@"<"])
	{
		[self.parseQueue removeFirstObject];
		return NSLayoutRelationLessThanOrEqual;
	}
	if([self.parseQueue.firstObject isEqualToString:@">"])
	{
		[self.parseQueue removeFirstObject];
		return NSLayoutRelationGreaterThanOrEqual;
	}
	if([self.parseQueue.firstObject isEqualToString:@"="])
	   [self.parseQueue removeFirstObject];
	
	return NSLayoutRelationEqual;
}

-(NSString*)parseTargetName
{
	//:必须写，所以这里必然有targetName，哪怕省略了
	if([self.parseQueue.head isEqualToString:@":"])
		return @"";
	else
		return [self.parseQueue dequeue];
}

-(NSString*)parseTargetAttributeName
{
	if([self.parseQueue.head isEqualToString:@":"])
	{
		[self.parseQueue dequeue];
	}
	if(self.parseQueue.count>0)
		return [self.parseQueue dequeue];
	else
		return @"";
}

-(CGFloat)parseMultiply
{
	if([[self.parseQueue head]isEqualToString:@"*"])
	{
		[self.parseQueue dequeue];
		NSString* numberString = [self.parseQueue dequeue];
		return [numberString floatValue];
	}
	else if([[self.parseQueue head]isEqualToString:@"/"])
	{
		[self.parseQueue dequeue];
		NSString* numberString = [self.parseQueue dequeue];
		return 1/[numberString floatValue];//敢写0就敢除0=。=
	}
	
	return 1.0;
}

-(CGFloat)parseConstant
{
	if([self.parseQueue.head isEqualToString:@"+"])
	{
		[self.parseQueue dequeue];
		NSString* numberString = [self.parseQueue dequeue];
		return [numberString floatValue];
	}
	else if([self.parseQueue.head isEqualToString:@"-"])
	{
		[self.parseQueue dequeue];
		NSString* numberString = [self.parseQueue dequeue];
		return -1*[numberString floatValue];
	}
	
	return 0.0;
}

-(CGFloat)parsePriority
{
	
	return 100000;
}

#pragma mark -- property
- (NSMutableArray<NSString*> *)parseQueue
{
	if(_parseQueue == nil)
	{
		_parseQueue = [NSMutableArray<NSString*> arrayWithCapacity:9];
	}
	return _parseQueue;
}

+(BOOL)checkFormula:(NSString*)formula
{
	static NSPredicate* predicate ;
	if (predicate==nil)
 	{
		predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^(=|>|<)?\\w*:\\w*(\\*\\d+)?((\\+|-)\\d)?$"];
	}
	return [predicate evaluateWithObject:formula];
}

+(NSLayoutAttribute)layoutAttributeOf:(NSString*)attrName
{
	attrName = [attrName lowercaseString];
	static NSDictionary<NSString*,NSNumber*>* _layoutAttribute;
	if(_layoutAttribute==nil)
	{
		_layoutAttribute = @{
							 @"height":[NSNumber numberWithInteger:NSLayoutAttributeHeight],
							 @"width":[NSNumber numberWithInteger:NSLayoutAttributeWidth],
							 
							 @"top":[NSNumber numberWithInteger:NSLayoutAttributeTop],
							 @"bottom":[NSNumber numberWithInteger:NSLayoutAttributeBottom],
							 @"left":[NSNumber numberWithInteger:NSLayoutAttributeLeft],
							 @"right":[NSNumber numberWithInteger:NSLayoutAttributeRight],
							 
							 @"centerx":[NSNumber numberWithInteger:NSLayoutAttributeCenterX],
							 @"centery":[NSNumber numberWithInteger:NSLayoutAttributeCenterY],
							 
							 @"leading":[NSNumber numberWithInteger:NSLayoutAttributeLeading],
							 @"trailing":[NSNumber numberWithInteger:NSLayoutAttributeTrailing],
							 };
	}
	return (NSLayoutAttribute)_layoutAttribute[attrName];
}

@end
