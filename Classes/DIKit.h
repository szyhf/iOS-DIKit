//
//  DIKit.h
//  Fakeshion
//
//  Created by Back on 16/5/5.
//  Copyright © 2016年 Back. All rights reserved.
//
#import<UIKit/UIKit.h>

FOUNDATION_EXPORT double DIKitVersionNumber;
FOUNDATION_EXPORT const unsigned char DIKitVersionString[];

#import <DIKit/DITools.h>
#import <DIKit/DIContainer.h>
#import <DIKit/DIConfig.h>
#import <DIKit/DIWatcher.h>
//Router系列
#import <DIKit/DIRouter.h>
#import <DIKit/DIRouter+Xml.h>
#import <DIKit/DIRouter+Assemble.h>

//Model和ViewModel
#import "DIModel.h"
#import "DIDictionaryProxyModel.h"
#import "DIArrayModel.h"
#import "DIDictionaryModel.h"

#import "DIViewModel.h"
#import "DITableViewModel.h"

//NUI相关
#import "NUISettings.h"