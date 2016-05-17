//
//  DIRouter+HandlerBlocks.h
//  Fakeshion
//
//  Created by Back on 16/5/11.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "DIRouter.h"

typedef void(^RealizeHandlerBlock)(NSString*parent,NSString*child);
@interface DIRouter (HandlerBlocks)
+(NSDictionary<NSString*,NSDictionary<NSString*,RealizeHandlerBlock>*>*)realizeMap;
@end
