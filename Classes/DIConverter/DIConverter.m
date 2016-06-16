//
//  DIConverter.m
//  DIKit
//
//  Created by Back on 16/5/24.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "DIConverter.h"
#import "NUIConverter.h"
#import "NSObject+Runtimes.h"
#import "DITools.h"
#import "DIIO.h"

@implementation DIConverter

+(UIEdgeInsets)toEdgeInsets:(NSString*)string
{
	[string stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"[](){}<>"]];
	NSArray<NSString*>* parames = [string componentsSeparatedByString:@","];
	
	return UIEdgeInsetsMake([parames[0] floatValue], [parames[1] floatValue], [parames[2] floatValue], [parames[3] floatValue]);
}

+(NSValue*)toEdgeInsetsValue:(NSString*)string
{
	return [NSValue valueWithUIEdgeInsets:[self toEdgeInsets:string]];
}

+(CGSize)toSize:(NSString*)string
{
	[string stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"[](){}<>"]];
	NSArray<NSString*>* parames = [string componentsSeparatedByString:@","];
	CGFloat width = [parames[0]floatValue];
	CGFloat height = [parames[1]floatValue];
	return CGSizeMake(width, height);
}

+(NSValue*)toSizeValue:(NSString*)string
{
	return [NSValue valueWithCGSize:[self toSize:string]];
}

#if TARGET_OS_SIMULATOR
+(NSString*)imageFilePathNamed:(NSString*)imageName
{
	return [DIIO recurFullPathFilesWithSuffix:[NSString stringWithFormat:@"/%@.png",imageName] inDirectory:@"/Users/back/Documents/IOS/Liangfeng/Liangfeng/Resources"].firstObject;
}
#endif

+(UIImage*)toImage:(NSString*)string
{
	//尝试根据Named获取
	UIImage* res = [UIImage imageNamed:string];
	if(res)
		return res;
#if TARGET_OS_SIMULATOR
	//尝试从临时素材路径获取
	NSString* path = [self imageFilePathNamed:string];
	res = [UIImage imageWithContentsOfFile:path];
	if(res)
		return res;
	
#endif
	
	//尝试从路径获取
	res = [UIImage imageWithContentsOfFile:string];
	if(res)
		return res;
	//todo:尝试从网络下载
	
	
	return res;
}
+(UIColor*)toColor:(NSString*)string
{
	UIColor* color = [NUIConverter toColor:string];
	if(!color)
	{
		SEL selector = NSSelectorFromString(string);
		if([[UIColor class]respondsToSelector:selector])
		{
			color = [UIColor invokeSelector:selector];
		}
	}
	return color;
}
@end
