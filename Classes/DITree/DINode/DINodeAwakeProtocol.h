//
//  DINodeAwakeProtocol.h
//  DIKit
//
//  Created by Back on 16/6/3.
//  Copyright © 2016年 Back. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DINodeAwakeProtocol <NSObject>
@required
-(void)awake;
@optional
-(void)beforeImply;
-(void)implying;
-(void)afterImply;
-(void)finishAll;
@end
