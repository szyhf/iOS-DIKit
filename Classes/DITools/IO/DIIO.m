//
//  DIIO.m
//  Pods
//
//  Created by Back on 16/5/20.
//
//

#import "DIIO.h"
@interface DIIO()
@end

@implementation DIIO
+(NSArray<NSString*>*)filesWithSuffix:(NSString*)suffix
{
	NSString *bundleRoot = [[NSBundle mainBundle] bundlePath];
	return [self filesWithSuffix:suffix atPath:bundleRoot];
}
							
+(NSArray<NSString*>*)filesWithSuffix:(NSString*)suffix
						  inDirectory:(NSString*)directoryPath
{
	NSString *bundleRoot = [[[NSBundle mainBundle] bundlePath]stringByAppendingPathComponent:directoryPath];
	return [self filesWithSuffix:suffix atPath:bundleRoot];
}
+(NSArray<NSString*>*)filesWithSuffix:(NSString*)suffix
							   atPath:(NSString*)path
{
	NSFileManager *fm = [NSFileManager defaultManager];
	NSArray *dirContents = [fm contentsOfDirectoryAtPath:path error:nil];
	NSString* predicateFormat = [NSString stringWithFormat:@"self ENDSWITH '%@'",suffix];
	NSPredicate *fltr = [NSPredicate predicateWithFormat:predicateFormat];
	return [dirContents filteredArrayUsingPredicate:fltr];
}
+(NSArray<NSString*>*)recurFullPathFilesWithSuffix:(NSString*)suffix
							   inDirectory:(NSString*)path
{
	NSFileManager *fm = [NSFileManager defaultManager];
	NSArray *dirContents = [fm contentsOfDirectoryAtPath:path error:nil];
	NSMutableArray* res = [NSMutableArray arrayWithCapacity:0];
	for (NSString* dirContent in dirContents)
	{
		BOOL isDir;
		NSString* filePath = [path stringByAppendingPathComponent:dirContent];
		[fm fileExistsAtPath:filePath isDirectory:&isDir];
		if(isDir)
		{
			[res addObjectsFromArray:[self recurFullPathFilesWithSuffix:suffix inDirectory:filePath]];
		}else
		{
			[res addObject:filePath];
		}
	}
	NSString* predicateFormat = [NSString stringWithFormat:@"self ENDSWITH '%@'",suffix];
	NSPredicate *fltr = [NSPredicate predicateWithFormat:predicateFormat];
	return [res filteredArrayUsingPredicate:fltr];
}

+(NSString*)recurFullPathToFile:(NSString*)file
							  inDirectory:(NSString*)path
{
	NSString* _fileName = [@"/" stringByAppendingString:file];
	NSFileManager *fm = [NSFileManager defaultManager];
	NSDirectoryEnumerator* dirEnumerator = [fm enumeratorAtPath:path];
	NSString* filePath ;
	while (( filePath = [dirEnumerator nextObject] ) != nil)
	{
		//这里得到的filePath只是子目录的路径
		BOOL isDir;
		[fm fileExistsAtPath:filePath isDirectory:&isDir];
		if(!isDir)
		{
			if([filePath hasSuffix:_fileName])
			{
				return [path stringByAppendingString:filePath];
			}
		}
	}
	return @"";
}
@end
