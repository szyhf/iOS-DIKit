//
//  DILayoutDebug.h
//  Fakeshion
//
//  Created by Back on 16/5/13.
//  Copyright © 2016年 Back. All rights reserved.
//

#ifndef DILayoutDebug_h
#define DILayoutDebug_h

#define DI_DEBUG_LAYOUT

#ifdef DI_DEBUG_LAYOUT
#define DebugLayout(view) [view setBackgroundColor:[UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:0.4]]
#else
#define DebugBackground(view)
#endif
#endif /* DILayoutDebug_h */
