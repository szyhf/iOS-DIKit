//
//  DIConfig.m
//  Fakeshion
//
//  Created by Back on 16/5/5.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "DIConfig.h"
#import "DILog.h"
#import "DITools.h"

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
		NSString* confPath = [[NSBundle mainBundle]pathForResource:@"AppConfig" ofType:@"json"];
		NSString* jsonConf = [NSString stringWithContentsOfFile:confPath
												   usedEncoding:nil
														  error:nil];
		if(![NSString isNilOrEmpty:jsonConf])
		{
			[storage addEntriesFromDictionary:[jsonConf jsonDictionary]];
		}
		
	}
	return self;
}

+(instancetype)instance
{
	static DIConfig* _instance;
	static dispatch_once_t _token;
	dispatch_once(&_token,
				  ^{
					  _instance = [[DIConfig alloc]init] ;
				  });
	return _instance;
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

+(NSInteger(^)(NSString*))getInt
{
	return ^NSInteger(NSString* key)
	{
		return 0;
	};
}

+(float(^)(NSString*))getFloat
{
	return ^float(NSString* key)
	{
		return 0.;
	};
}

+(NSString*(^)(NSString*))getNSString
{
	return ^NSString*(NSString*key)
	{
		DIConfig* instance = [DIConfig instance];
		return [instance.storage[key]description];
	};
}

+(BOOL(^)(NSString*))getBool
{
	return ^BOOL(NSString* key)
	{
		return NO;
	};
}
@end
