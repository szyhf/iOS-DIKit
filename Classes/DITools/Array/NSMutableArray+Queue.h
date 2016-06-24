//
//  NSMutableArray+Queue.h
//  DIKit
//
//  Created by Back on 16/5/22.
//  Copyright © 2016年 Back. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray<ObjectType> (Queue)
-(void)removeFirstObject;
-(ObjectType)dequeue;
-(void)enqueue:(ObjectType)object;
@end
