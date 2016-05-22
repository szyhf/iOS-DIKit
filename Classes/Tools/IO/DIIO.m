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
@end
