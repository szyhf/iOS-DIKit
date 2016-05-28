//
//  NSArray+Stack.h
//  DIKit
//
//  Created by Back on 16/5/22.
//  Copyright © 2016年 Back. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray<ObjectType>(Stack)
-(id)pop;
-(void)push:(ObjectType)obj;
@end
