//
//  NSObject+Runtimes.h
//  DIKit
//
//  Created by Back on 16/5/24.
//  Copyright © 2016年 Back. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Runtimes)
#pragma mark - static
+(id)invokeStaticMethod:(NSString*)methodName;
+(id)invokeStaticMethod:(NSString*)methodName withParams:(id)param,...;

#pragma mark
-(id)invokeMethod:(NSString*)methodName;
-(id)invokeMethod:(NSString *)methodName withParams:(id)param,...;
@end
