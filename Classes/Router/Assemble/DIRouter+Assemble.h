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
/**
 *  尝试推断可能符合条件的element
 *
 *  @param element 元素名
 *
 *  @return 推断出来的可行元素名
 */
+(NSString*)realizeOfAnonymous:(NSString*)aliasName;
@end
