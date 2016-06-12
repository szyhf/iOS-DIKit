//
//  DIRouter+Assemble.h
//  DIKit
//
//  Created by Back on 16/5/17.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "DIRouter.h"

#import "DIRouter+HandlerBlocks.h"

@interface DIRouter (Assemble)
/**
 *  将指定的元素添加到制定的父元素
 *
 *  @param element     子元素名
 *  @param lastElement 父元素名
 */
+(void)addElement:(NSString*)element
		 toParent:(NSString*)lastElement;

+(RealizeHandlerBlock)blockToAddElement:(NSString*)element
							   toParent:( NSString*)lastElement;
@end
