//
//  PFAssetTypes.m
//  ProFinanceApi
//
//  Created by VitaliyK on 04.03.14.
//  Copyright (c) 2014 profinancesoft. All rights reserved.
//

#import "PFAssetTypes.h"

@interface PFAssetTypes ()

@property (nonatomic, strong) NSMutableDictionary* mutableAssetTypes;

-(PFAssetType*)assetTypeWithId: (int)asset_id_;
-(PFAssetType*)assetTypeWithCurrency: (NSString*)currency;

@end

@implementation PFAssetTypes

@synthesize mutableAssetTypes;

-(NSDictionary*)assetTypes
{
    return mutableAssetTypes;
}

-(void)addAssetType:(PFAssetType *)asset_type_
{
    PFAssetType* current_asset_type_ = [ self.mutableAssetTypes objectForKey: @(asset_type_.assetId)];

    if ( !current_asset_type_ )
    {
        if (!self.mutableAssetTypes)
        {
            self.mutableAssetTypes = [NSMutableDictionary new];
        }

        [ self.mutableAssetTypes setObject: asset_type_ forKey: @(asset_type_.assetId) ];
    }
    else
    {
        [current_asset_type_ updateFromAssetType: asset_type_];
    }
}

-(PFAssetTypes*)assetTypeWithId: (int)asset_id_
{
    return [ self.mutableAssetTypes objectForKey: @(asset_id_) ];
}

-(PFAssetType *)assetTypeWithCurrency:(NSString *)currency
{
    for (PFAssetType* asset_ in mutableAssetTypes.allValues)
    {
        if ( [asset_.name isEqualToString: currency] )
            return asset_;
    }
    return nil;
}

@end
