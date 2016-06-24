//
//  DIViewModel.h
//  DIKit
//
//  Created by Back on 16/6/21.
//  Copyright © 2016年 Back. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DIViewModel : NSObject
-(void)registryModel:(NSObject*)model named:(NSString*)modelName;
-(void)registryModel:(NSObject*)model;
-(void)registryModelClass:(Class)modelClass;
-(void)unbinding;
@property (nonatomic, weak) NSObject* bindingInstance;
@property (nonatomic, readonly) NSMutableDictionary<NSString*,NSObject*>*modelsMap;
@end
