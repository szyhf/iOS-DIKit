//
//  DIHidden.m
//  Pods
//
//  Created by Back on 16/7/13.
//
//

#import "DIHidden.h"
#import <objc/runtime.h>
@implementation DIHidden
-(void)setValue:(id)value forKey:(NSString *)key
{
	return objc_setAssociatedObject(self, NSSelectorFromString(key), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(id)valueForKey:(NSString *)key
{
	return objc_getAssociatedObject(self, NSSelectorFromString(key));
}
@end
