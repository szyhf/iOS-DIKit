//
//  DIArraySelectionModel.h
//  DIKit
//
//  Created by Back on 16/7/14.
//  Copyright © 2016年 Back. All rights reserved.
//

#import <DIKit/DIKit.h>
#import "DIArrayModel.h"

@interface DIArraySelectionModel : DIArrayModel
@property (nonatomic, strong) NSPredicate* predicate;
@property (nonatomic, strong) NSMutableArray<NSSortDescriptor*>* sorts;
@property (nonatomic, strong) NSArray<NSDictionary<NSString*,NSNumber*>*>* orders;
-(void)reversOrderByKey:(NSString*)key;
@end

@interface DIArraySelectionModel(Sort)
@end