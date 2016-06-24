//
//  DIWatcher.m
//  DIKit
//
//  Created by Back on 16/6/21.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "DIWatcher.h"
#import "NUIFileMonitor.h"

@implementation DIWatcher
//static NSMutableDictionary<NSString*,NSMutableArray<void(^)()>*>* watchedFiles;

+(void)watch:(NSString*)path withCallback:(void(^)())callback
{
	//if(!watchedFiles)
		//watchedFiles = [NSMutableDictionary dictionary];
	
	//NSMutableArray* blockArray = watchedFiles[path];
	
	//if(!blockArray)
	//{
		//watchedFiles[path] = [NSMutableArray arrayWithObject:callback];
	[NUIFileMonitor watch:path withCallback:callback];
		//^{
			//for (void(^block)() in watchedFiles[path])
			//{
				//block();
			//}
		//}];
	//}
	//else
	//{
		//[blockArray addObject:callback];
	//}	
}
@end
