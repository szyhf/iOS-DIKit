//
//  DIConfig.m
//  Fakeshion
//
//  Created by Back on 16/5/5.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "DIConfig.h"
#import "DILog.h"

@interface DIConfig()
@property(atomic)NSMutableDictionary* storage;
@end

@implementation DIConfig
@synthesize storage;

- (instancetype)init
{
	self = [super init];
	if (self) {
		storage = [NSMutableDictionary dictionaryWithCapacity:0];
	}
	return self;
}

-(void)set:(id)value
	forKey:(NSString*)key
{
	return [storage setValue:value forKey:key];
}

-(id)get:(NSString*)key
{
	return [storage objectForKey:key];
}

-(bool)parseBool:(id)obj
{
	if (obj)
	{
		if([obj isKindOfClass:[NSValue class]])
		{
			return [obj boolValue];
		}
		else if ([obj isKindOfClass:[NSString class]])
		{
			NSString* str = [((NSString*)obj) lowercaseString];
			if([str  isEqual: @"1"] ||
			   [str  isEqual: @"t"] ||
			   [str  isEqual: @"true"] ||
			   [str  isEqual: @"y"] ||
			   [str  isEqual: @"yes"] ||
			   [str  isEqual: @"on"] )
			{
				return YES;
			}else
				return NO;
		}
	}
	WarnLog(@"Try to parse bool but failed, return false as default.");
	return NO;
}

//-(NSString*)getString:(NSString*)key default:(NSString*)defalut
//{
	//return [storage stringValueForKey:key default:@""];
//}

//-(Boolean)getBool:(NSString*)key default:(Boolean)defalut
//{
	//return [storage boolValueForKey:key default:defalut];
//}

//-(int)getInt:(NSString*)key default:(int)defalut
//{
	//return [storage intValueForKey:key default:defalut];
//}

@end
