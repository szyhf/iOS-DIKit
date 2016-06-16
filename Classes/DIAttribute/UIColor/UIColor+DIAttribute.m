//
//  UIColor+DIAttribute.m
//  Pods
//
//  Created by Back on 16/6/13.
//
//

#import "UIColor+DIAttribute.h"
#import "NSObject+Runtimes.h"
#import "DITools.h"
#import <objc/runtime.h>

@implementation UIColor (DIAttribute)
//+(BOOL)resolveClassMethod:(SEL)aSelector
//{
	//NSString* colorName = NSStringFromSelector(aSelector);
	//if([NSString isNilOrEmpty:colorName])
		//return NO;
	//if(![colorName hasSuffix:@"Color"])
	//{
		//colorName = [colorName stringByAppendingString:@"Color"];
		//aSelector = NSSelectorFromString(colorName);
		
	//}else
	//{
		//colorName = [colorName trimEnd:@"Color"];
		//aSelector = NSSelectorFromString(colorName);
	//}
	
	//if( [UIColor.class respondsToSelector:aSelector])
	//{
		//IMP imp = [UIColor.class methodForSelector:aSelector];
		//class_addMethod(self, aSelector, imp, "v@:");
		//return YES;
	//}
	//return NO;
//}
@end
