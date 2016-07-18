//
//  DIViewModel.h
//  DIKit
//
//  Created by Back on 16/6/21.
//  Copyright © 2016年 Back. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DIModel.h"

@interface DIViewModel : DIModel
@property (nonatomic, weak) NSObject* bindingInstance;
-(void)prepareForReuse;
@end
