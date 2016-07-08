//
//  NSNumber+DITimeFormater.m
//  DIKit
//
//  Created by Back on 16/6/17.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "NSNumber+DITimeFormater.h"

@implementation NSNumber (DITimeFormater)
-(NSString*)toTimeString
{
	return [self toTimeStringFrom:[NSDate date]];
}
-(NSString*)toTimeStringFrom:(NSDate*)from
{
	NSUInteger toTime = [self unsignedIntegerValue];
	NSUInteger fromTime = [from timeIntervalSince1970];
	NSString* suffix;
	
	NSUInteger diff =0;
	
	if(fromTime>toTime)
	{
		suffix = @"前";
		diff = fromTime-toTime;
	}
	else
	{
		suffix = @"后";
		diff = toTime-fromTime;
	}
	
	if(diff<3600)
	{
		NSUInteger minDif = diff/60;
		return [NSString stringWithFormat:@"%ld分钟%@",minDif,suffix];
	}
	
	if(diff<86400)
	{
		NSUInteger hourDif = diff/3600;
		return [NSString stringWithFormat:@"%ld小时%@",hourDif,suffix];
	}
	
	static NSDateFormatter *formatter ;
	if(!formatter)
	{
		formatter = [[NSDateFormatter alloc] init];
		[formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
		return @"很久以前";
	}
	
	
	return [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:toTime]];
}
@end
