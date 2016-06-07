//
//  DIIO.h
//  Pods
//
//  Created by Back on 16/5/20.
//
//

#import <Foundation/Foundation.h>

@interface DIIO : NSObject
+(NSArray<NSString*>*)filesWithSuffix:(NSString*)suffix;
+(NSArray<NSString*>*)filesWithSuffix:(NSString*)suffix inDirectory:(NSString*)directoryPath;
+(NSArray<NSString*>*)filesWithSuffix:(NSString*)suffix
							   atPath:(NSString*)path;
+(NSArray<NSString*>*)recurFullPathFilesWithSuffix:(NSString*)suffix
							   inDirectory:(NSString*)path;
@end
