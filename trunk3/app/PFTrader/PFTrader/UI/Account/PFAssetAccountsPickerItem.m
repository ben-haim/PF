//
//  PFAssetAccountsPickerItem.m
//  PFTrader
//
//  Created by VitaliyK on 13.03.14.
//  Copyright (c) 2014 profinancesoft. All rights reserved.
//
#import "PFAssetAccountsPickerItem.h"
#import <ProFinanceApi/ProFinanceApi.h>

@interface PFAssetAccountsPickerItem ()

@property ( nonatomic, strong ) NSArray* availableAssetAccounts;

@end

@implementation PFAssetAccountsPickerItem

@synthesize availableAssetAccounts;
@synthesize selectedAssetAccount;

-(id)initWithAccount:( id< PFAccount > ) account_
{
    self = [ super initWithAction: nil title: NSLocalizedString( @"ASSET_ACCOUNTS", nil ) ];
    if ( self )
    {
        self.selectedAssetAccount = (id<PFAssetAccount>) account_.currAssetAccount;
        self.availableAssetAccounts = account_.sortedAssetAccounts;
    }
    return self;
}

-(NSString*)valueForRow:( NSInteger )row_
{
    return [ [ self.availableAssetAccounts objectAtIndex: row_ ] currency ];
}

-(NSString*)value
{
    return self.selectedAssetAccount.currency;
}

-(NSUInteger)pickerField:( PFPickerField* )picker_field_
 numberOfRowsInComponent:( NSInteger )component_
{
    return [ self.availableAssetAccounts count ];
}

-(NSString*)pickerField:( PFPickerField* )picker_field_
            titleForRow:( NSInteger )row_
           forComponent:( NSInteger )component_
{
    return [ self valueForRow: row_ ];
}

-(NSUInteger)pickerField:( PFPickerField* )picker_field_
   currentRowInComponent:( NSInteger )component_
{
    return [ self.availableAssetAccounts indexOfObject: self.selectedAssetAccount ];
}

-(void)pickerField:( PFPickerField* )picker_field_
      didSelectRow:( NSInteger )row_
       inComponent:( NSInteger )component_
{
    self.selectedAssetAccount = [ self.availableAssetAccounts objectAtIndex: row_ ];
    picker_field_.text = self.selectedAssetAccount.currency;

    [ super pickerField: picker_field_ didSelectRow: row_ inComponent: component_ ];
}

-(BOOL)pickerField:( PFPickerField* )picker_field_
 isCyclicComponent:( NSInteger )component_
{
    return NO;
}

@end
