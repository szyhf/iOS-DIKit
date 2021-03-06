//
//  NSObject+Hook.m
//  Pods
//
//  Created by Back on 16/5/27.
//
//

#import "NSObject+Hook.h"
#import <objc/runtime.h>
#import "DITools.h"

@implementation NSObject (Hook)

+(void)exchangeInstanceSelector:(SEL)aSel toSelector:(SEL)bSel
{
	Method aMethod = class_getInstanceMethod(self, aSel);
	Method bMethod = class_getInstanceMethod(self, bSel);
	method_exchangeImplementations(aMethod, bMethod);
}
+(void)exchangeClassSelector:(SEL)aSel toSelector:(SEL)bSel
{
	Method aMethod = class_getClassMethod(self, aSel);
	Method bMethod = class_getClassMethod(self, bSel);
	method_exchangeImplementations(aMethod, bMethod);
}

-(void)addHook:(void(^)(id obj))hook toMethod:(NSString*)methodName
{
	if(!hook)
		return WarnLog(@"Add nil hook to %@ of %@.",methodName,self);
	SEL selector = NSSelectorFromString(methodName);
	Method oldMethod = class_getClassMethod(self.class, selector);
	IMP oldImp = class_getMethodImplementation(self.class, selector);
	id(*oldImpFun)(id,SEL) = (void*)oldImp;
	
	//用来替换的的新方法的block形式
	void(^newImpBlock)(id)=^(id _self)
	{
		oldImpFun(_self,selector);
		hook(_self);
	};
	
	//将block转为IMP
	IMP newImp = imp_implementationWithBlock((__bridge id)((__bridge void*)newImpBlock));
	
	//替换Method的Imp
	method_setImplementation(oldMethod, newImp);
}
@end
