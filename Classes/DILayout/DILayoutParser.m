//
//  DILayoutParser.m
//  DIKit
//
//  Created by Back on 16/5/22.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "DILayoutParser.h"
#import "DITools.h"
#import "DIContainer.h"
@interface DILayoutParser()
@property (nonatomic, strong) NSMutableArray<NSString*>* parseQueue;
@end

@implementation DILayoutParser
+(instancetype)instance
{
	static DILayoutParser* parser = nil;
	static dispatch_once_t diLayoutParser ;
	dispatch_once(&diLayoutParser, ^{
		parser = [[DILayoutParser alloc]init];
	});
	return parser;
}

+(NSArray<DILayoutParserResult*>*)parserResults:(NSString*)layoutFormula
								   attributeKey:(NSString*)attribute
{
	NSArray<NSString*>* formulas = [layoutFormula split:@";"];
	
	NSMutableArray<DILayoutParserResult*>* results = [NSMutableArray arrayWithCapacity:formulas.count];
	for (NSString* formula in formulas)
 	{
		[results addObject:[self parserWithAttribute:attribute
												 formula:formula]];
	}
	return results;
}

+(DILayoutParserResult*)parserWithAttribute:(NSString*)key
									formula:(NSString*)formula
{
	NSScanner* scanner = [NSScanner scannerWithString:formula];
	NSCharacterSet *relationSet = [NSCharacterSet characterSetWithCharactersInString:@">=<"];
	NSCharacterSet *varSet = [NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_0123456789#"];

	static NSCharacterSet *mulitplySet;
	if(!mulitplySet)
		mulitplySet = [NSCharacterSet characterSetWithCharactersInString:@"*/"];
	
	NSString* relation = nil;
	NSString* target = nil;
	NSString* targetAttribute = nil;
	CGFloat mutiply = 1;
	CGFloat offset = 0;
	CGFloat priority = 100000;
	
	DILayoutParserResult* result = [DILayoutParserResult newParserResult];
	result.oriAttribute = key;
	[scanner scanCharactersFromSet:relationSet intoString:&relation];
	[scanner scanCharactersFromSet:varSet intoString:&target];
	
	//变量名还是数字
	if(![target isMatchRegular:@"^\\d+$"])
	{
		[result setTarget:target];
		if([scanner scanString:@":" intoString:NULL])
		{
			[scanner scanCharactersFromSet:[NSCharacterSet letterCharacterSet] intoString:&targetAttribute]?[result setTargetAttribute:targetAttribute]:result;
		}
		if([scanner scanCharactersFromSet:mulitplySet intoString:nil])
			[scanner scanDouble:&mutiply]?[result setMutiply:mutiply]:result;
		[scanner scanDouble:&offset]?[result setOffset:offset]:result;
	}
	else
	{
		[result setOffset:[target floatValue]];
		result.targetAttribute = @"not";
		result.isAbsolute = YES;
	}
	
	if([scanner scanString:@"@" intoString:nil])
		[scanner scanDouble:&priority]?[result setPriority:priority]:result;
	
	
	if([relation isEqualToString:@">"])
		[result setRelation:NSLayoutRelationGreaterThanOrEqual];
	else if([relation isEqualToString:@"<"])
		[result setRelation:NSLayoutRelationLessThanOrEqual];
	
	if([NSString isNilOrEmpty:result.targetAttribute])
	{
		result.targetAttribute = key;
	}
	
	NoticeLog(@"%@",result);
	return result;
}

-(NSLayoutConstraint*)constraint:(NSString*)layoutFormula
					 toAttribute:(NSString*)attribute
						 forView:(UIView*)view
{
	[self.parseQueue removeAllObjects];
	
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
	
	NSLayoutRelation relation = [self parseRelation];
	
	NSString* targetName = [self parseTargetName];
	
	UIView* target;
	if([targetName isEmpty])
		target = view.superview;
	else if(targetName!=nil)
		target = (UIView*)[DIContainer getInstanceByName:targetName];
	
	NSString* targetAttributeName = [self parseTargetAttributeName];
	if([targetAttributeName isEmpty])
		targetAttributeName = attribute;
	NSLayoutAttribute targetAttribute = [DILayoutKey layoutAttributeOf:targetAttributeName];
	
	CGFloat mulitply = [self parseMultiply];
	
	CGFloat constant = [self parseConstant];
	
	NSLayoutAttribute selfAttribute = [DILayoutKey layoutAttributeOf:attribute];

	return [NSLayoutConstraint
			constraintWithItem:view
					 attribute:selfAttribute
					 relatedBy:relation
						toItem:target
					 attribute:targetAttribute
					multiplier:mulitply
					  constant:constant
	 ];
}

-(void)parserFormula:(NSString*)layoutFormula
{
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
	{
		return @"";
	}
	else
	{
		if(self.parseQueue.count>1)
			return [self.parseQueue dequeue];
		else//是数字定义
			return nil;
	}
	
}

-(NSString*)parseTargetAttributeName
{
	if([self.parseQueue.head isEqualToString:@":"])
	{
		[self.parseQueue dequeue];
		if(self.parseQueue.count>0)
			return [self.parseQueue dequeue];
		else
			return @"";
	}
	else
	{//数字定义
		return @"not";
	}
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
	else if([self.parseQueue.head isMatchRegular:@"\\d+"])
	{
		NSString* numberString = [self.parseQueue dequeue];
		return [numberString floatValue];
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

+(BOOL)isRelationFormula:(NSString*)formula
{
	static NSPredicate* predicate ;
	if (predicate==nil)
 	{
		predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^(=|>|<)?\\w*:\\w*(\\*\\d+)?((\\+|-)\\d)?$"];
	}
	return [predicate evaluateWithObject:formula];
}

+(BOOL)isFixedFormula:(NSString*)formula
{
	static NSPredicate* predicate ;
	if (predicate==nil)
	{
		predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^\\d+$"];
	}
	return [predicate evaluateWithObject:formula];
}


@end
