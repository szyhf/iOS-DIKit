//
//  NSObject+Hook.h
//  Pods
//
//  Created by Back on 16/5/27.
//
//

#import <Foundation/Foundation.h>

@interface NSObject (Hook)
+(void)exchangeClassSelector:(SEL)aSel toSelector:(SEL)bSel;
+(void)exchangeInstanceSelector:(SEL)aSel toSelector:(SEL)bSel;
@end
