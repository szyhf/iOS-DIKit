//
//  DIModel.h
//  DIKit
//
//  Created by Back on 16/6/21.
//  Copyright © 2016年 Back. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DIModel : NSObject
@end

@interface DIModel(Watch)
-(void)startWatching;
-(void)watchModel:(NSObject*)model named:(NSString*)modelName;
-(void)watchModel:(NSObject*)model;
-(void)watchModelClass:(Class)modelClass;

@property (nonatomic, strong, readonly) NSMutableDictionary<NSString*,NSObject*>*watchMap;

@property (nonatomic, strong, readonly) NSDictionary<NSString*,NSString*>* bindingMap;
@end