//
//  PFAssetTypes.h
//  ProFinanceApi
//
//  Created by VitaliyK on 04.03.14.
//  Copyright (c) 2014 profinancesoft. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "PFAssetType.h"

@interface PFAssetTypes : NSObject

@property (nonatomic, strong, readonly) NSDictionary* assetTypes;

-(void)addAssetType: (PFAssetType*)asset_type_;
-(PFAssetType *)assetTypeWithCurrency:(NSString *)currency;
-(PFAssetType*)assetTypeWithId: (int)asset_id_;

@end
