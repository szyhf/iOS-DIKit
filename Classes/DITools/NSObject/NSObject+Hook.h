//
//  NSObject+Hook.h
//  Pods
//
//  Created by Back on 16/5/27.
//
//

#import <Foundation/Foundation.h>

@interface NSObject (Hook)
-(void)addHook:(void(^)(id))hook toMethod:(NSString*)methodName;
@end
