//
//  NSObject+DIAttribute.h
//  DIKit
//
//  Created by Back on 16/5/24.
//  Copyright © 2016年 Back. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DINode.h"

@interface NSObject (DIAttribute)
-(void)updateByNode:(DINode*)node;
@end
