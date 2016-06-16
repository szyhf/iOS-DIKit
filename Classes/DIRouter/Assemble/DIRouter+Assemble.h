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
+(RealizeHandlerBlock)blockToAddElement:(NSString*)element
							   toParent:( NSString*)lastElement;
@end
