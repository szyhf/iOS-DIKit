//
//  UIViewController+DILayout.h
//  DIKit
//
//  Created by Back on 16/5/22.
//  Copyright © 2016年 Back. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (DILayout)
-(void)left:(NSString*)formula;
-(void)right:(NSString*)formula;
-(void)top:(NSString*)formula;
-(void)bottom:(NSString*)formula;

-(void)height:(NSString*)formula;
-(void)width:(NSString*)formula;

-(void)centerX:(NSString*)formula;
-(void)centerY:(NSString*)formula;

-(void)leading:(NSString*)formula;
-(void)trailing:(NSString*)formula;
@end
