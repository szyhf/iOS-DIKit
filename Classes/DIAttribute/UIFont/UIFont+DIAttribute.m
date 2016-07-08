//
//  UIFont+DIAttribute.m
//  DIKit
//
//  Created by Back on 16/7/6.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "UIFont+DIAttribute.h"
#import "DIObject.h"

@implementation UIFont (DIAttribute)
+(void)load
{
	[self exchangeClassSelector:@selector(systemFontOfSize:) toSelector:@selector(di_systemFontOfSize:)];
	//[self exchangeClassSelector:@selector(systemFontOfSize:weight:) toSelector:@selector(di_systemFontOfSize:weight:)];
	[self exchangeClassSelector:@selector(boldSystemFontOfSize:) toSelector:@selector(di_boldSystemFontOfSize:)];
	//[self exchangeClassSelector:@selector(italicSystemFontOfSize:) toSelector:@selector(di_italicSystemFontOfSize:)];
}

+(UIFont*)di_systemFontOfSize:(CGFloat)fontSize
{
	return [self fontWithName:@"STYuanti-SC-Regular" size:fontSize];
}

//+(UIFont*)di_systemFontOfSize:(CGFloat)fontSize weight:(CGFloat)weight
//{
	//return [self fontWithName:@"" size:fontSize];
//}

+(UIFont*)di_boldSystemFontOfSize:(CGFloat)fontSize
{
	return [self fontWithName:@"STYuanti-SC-Bold" size:fontSize];
}

//+(UIFont*)di_italicSystemFontOfSize:(CGFloat)fontSize
//{
	
//}
@end
