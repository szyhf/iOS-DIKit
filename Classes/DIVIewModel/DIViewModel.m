//
//  DIViewModel.m
//  DIKit
//
//  Created by Back on 16/6/21.
//  Copyright © 2016年 Back. All rights reserved.
//

#import "DIViewModel.h"
#import "DIContainer.h"
#import "DITools.h"
#import "NSObject+FBKVOController.h"

@implementation DIViewModel
-(void)setBindingInstance:(NSObject*)bindingInstance
{
	//重置观察，要不ViewModel在重用时可能无法正确更新被观察的对象
	[self.KVOControllerNonRetaining unobserveAll];
	[self watchModel:bindingInstance named:@"target"];
}

-(id)bindingInstance
{
	return self.watchMap[@"target"];
}
//view.property => vm.property
//vm.property => model.property
@end
