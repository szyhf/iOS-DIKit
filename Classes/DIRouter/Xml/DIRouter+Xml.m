//
//  DIRouter+Xml.m
//  DIKit
//
//  Created by Back on 16/5/19.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "DIRouter+Xml.h"
#import "DITools.h"
#import "DIRouter+Assemble.h"
#import "DIContainer.h"
#import "NUISettings.h"
#import "NSObject+Runtimes.h"
#import "DIAttribute.h"
#import "DIConverter.h"
#import "NUIFileMonitor.h"

@implementation DIRouter (Xml)
static NSString* dirPath;
+(void)registryXmlDirectory:(NSString*)dir
{
	// Override point for customization after application launch.
	UIWindow* window = [[UIWindow alloc]
						initWithFrame:[[UIScreen mainScreen]bounds]];
	[window makeKeyAndVisible];
	[[UIApplication sharedApplication].delegate setWindow:window];
	dirPath = dir;
	
	[self reload];
}

static NSMutableArray<NSString*>* watchedFiles;
+(void)addFileWatch:(NSString*)filePath
{
	if(!watchedFiles)
		watchedFiles = [NSMutableArray arrayWithCapacity:10];
	if(![watchedFiles containsObject:filePath])
	{
		[watchedFiles addObject:filePath];
		[NUIFileMonitor watch:filePath withCallback:
		 ^{
			 [self.class performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];
		 }];
	}
}

+(void)reload
{
	UIViewController* rootCtrl;
	@try
 	{
		[[UIApplication sharedApplication].delegate.window setRootViewController:nil];
		[DIContainer clear];
		[DITree.instance clear];
		NSArray* filesPaths = [DIIO recurFullPathFilesWithSuffix:@"xml" inDirectory:dirPath];
		for (NSString* path in filesPaths)
 		{
			[self addFileWatch:path];
			NSString* content =
			[NSString stringWithContentsOfFile:path
								  usedEncoding:nil
										 error:nil];
			[DIRouter remakeRealizeXml:content];
		}
		
		DINode* root = DITree.instance.nameToNode[@"root"];
		[root awake];
		
		rootCtrl = root.implement;
	}@catch(NSException* ex)
	{
		rootCtrl = [UIViewController alloc];
	}
	@finally
 	{
		[[UIApplication sharedApplication].delegate.window setRootViewController:rootCtrl];
	}
	DebugLog(@"Reload view.");
}

+(NSString*)resourceRealPathOfDirectory:(NSString*)directory
{
	NSString* dirPath = [[[NSBundle mainBundle]resourcePath]stringByAppendingPathComponent:directory];
	return dirPath;
}

+(void)registryRealizeXml:(NSString*)xmlString
{
	if(!DITree.instance)
	{
		[DITree.instance newWithXML:xmlString];
	}
	else
	{
		[DITree.instance updateWithXML:xmlString];
	}
}

+(void)remakeRealizeXml:(NSString*)xmlString
{
	if(!DITree.instance)
	{
		[DITree.instance newWithXML:xmlString];
	}
	else
	{
		[DITree.instance remakeWithXML:xmlString];
	}
}

@end
