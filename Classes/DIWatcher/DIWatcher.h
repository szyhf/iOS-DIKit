//
//  DIWatcher.h
//  DIKit
//
//  Created by Back on 16/6/21.
//  Copyright © 2016年 Back. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DIWatcher : NSObject
+(void)watch:(NSString*)path withCallback:(void(^)())callback;
@end
