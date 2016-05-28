//
//  DIConverter.m
//  DIKit
//
//  Created by Back on 16/5/24.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "DIConverter.h"
#import "NUIConverter.h"

@implementation DIConverter
+(UIImage*)toImage:(NSString*)string
{
	//尝试根据Named获取
	UIImage* res = [UIImage imageNamed:string];
	if(res)
		return res;
	//尝试从路径获取
	res = [UIImage imageWithContentsOfFile:string];
	if(res)
		return res;
	//todo:尝试从网络下载
	
	
	return res;
}
+(UIColor*)toColor:(NSString*)string
{
	return [NUIConverter toColor:string];	
}
@end
