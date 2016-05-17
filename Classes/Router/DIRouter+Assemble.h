//
//  DIRouter+Assemble.h
//  DIKit
//
//  Created by Back on 16/5/17.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "DIRouter.h"

@interface DIRouter (Assemble)
+(void)addElement:(NSString*)element
		 toParent:(NSString*)lastElement;
@end
