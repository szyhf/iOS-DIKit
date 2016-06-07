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
+(NSMutableArray<NSString*>*)dirFiles
{
	static NSMutableArray<NSString*>* _instance;
	static dispatch_once_t _token;
	dispatch_once(&_token,
				  ^{
					  _instance = [NSMutableArray arrayWithCapacity:10];
				  });
	return _instance;
}
+(void)registryXmlDirectory:(NSString*)dirPath
{
	// Override point for customization after application launch.
	UIWindow* window = [[UIWindow alloc]
						initWithFrame:[[UIScreen mainScreen]bounds]];
	[window makeKeyAndVisible];
	[[UIApplication sharedApplication].delegate setWindow:window];
	
	NSArray* filesPaths = [DIIO recurFullPathFilesWithSuffix:@"xml" inDirectory:dirPath];
	for (NSString* xmlFilePath in filesPaths)
 	{
		[self addFileWatch:xmlFilePath];
		[self.dirFiles addObject:xmlFilePath];
	}
	[self reload];
}

+(void)addFileWatch:(NSString*)filePath
{
	[NUIFileMonitor watch:filePath withCallback:
	 ^{
		 [self.class performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];
	}];
}

+(void)reload
{
	[[UIApplication sharedApplication].delegate.window setRootViewController:nil];
	[DIContainer clear];
	[DITree.instance clear];
	for (NSString* path in self.dirFiles)
	{
		NSString* content =
		[NSString stringWithContentsOfFile:path
							  usedEncoding:nil
									 error:nil];
		[DIRouter remakeRealizeXml:content];
	}
	
	DINode* root = DITree.instance.nameToNode[@"root"];
	[root awake];
	UIViewController* rootCtrl = root.implement;
	[[UIApplication sharedApplication].delegate.window setRootViewController:rootCtrl];
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
