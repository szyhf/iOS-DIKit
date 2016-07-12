//
//  NSObject+Thread.h
//  DIKit
//
//  Created by Back on 16/7/8.
//  Copyright © 2016年 Back. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Thread)
-(void)performBlockOnMainThread:(void(^)())aBlock waitUntilDone:(BOOL)wait;
@end
