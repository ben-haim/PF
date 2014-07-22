//
//  PFAssetAccountsPickerItem.h
//  PFTrader
//
//  Created by VitaliyK on 13.03.14.
//  Copyright (c) 2014 profinancesoft. All rights reserved.
//

#import "PFTableViewPickerItem.h"

@protocol PFAccount;
@protocol PFAssetAccount;

@interface PFAssetAccountsPickerItem : PFTableViewPickerItem

@property ( nonatomic, strong ) id< PFAssetAccount > selectedAssetAccount;

-(id)initWithAccount:( id< PFAccount > )account_;

@end
