//
//  DIModel.m
//  DIKit
//
//  Created by Back on 16/6/21.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "DIModel.h"
#import "DIWatcher.h"
#import "NSObject+YYModel.h"
#import "DIConfig.h"

@implementation DIModel
- (instancetype)init
{
	self = [super init];
	if (self)
	{
#if TARGET_OS_SIMULATOR
		NSString* dataPath = [NSString stringWithFormat:@"%@%@.json",DIConfig.getNSString(@"LocalDataDirectory"),self.class];
		[DIWatcher watch:dataPath withCallback:
		 ^{
			 NSString* json = [NSString stringWithContentsOfFile:dataPath
										   usedEncoding:nil
														   error:nil];
			 [self performSelectorOnMainThread:@selector(yy_modelSetWithJSON:) withObject:json waitUntilDone:YES];
		 }];
#else
		NSString* dataPath = [[NSBundle mainBundle]pathForResource:NSStringFromClass(self.class) ofType:@".json"];
#endif
		NSString* json = [NSString stringWithContentsOfFile:dataPath
											   usedEncoding:nil
													  error:nil];
		[self performSelectorOnMainThread:@selector(yy_modelSetWithJSON:) withObject:json waitUntilDone:YES];
	}
	return self;
}

-(void)dealloc
{
	
}
@end