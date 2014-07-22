#import "PFAccountPickerItem.h"

#import <ProFinanceApi/ProFinanceApi.h>


@interface PFAccountPickerItem ()

@property ( nonatomic, strong ) NSArray* availableAccounts;

@end

@implementation PFAccountPickerItem

@synthesize selectedAccount;
@synthesize availableAccounts;

-(id)initWithAccount:( id< PFAccount > )account_
   andNonusedAccount:( id< PFAccount > )nonused_account_
{
   self = [ super initWithAction: nil title: NSLocalizedString( @"ACCOUNTS", nil ) ];
   if ( self )
   {
      self.selectedAccount = account_;
      
      NSMutableArray* all_accounts_ = [ [ PFSession sharedSession ].accounts.accounts mutableCopy ];
      if ( nonused_account_ )
      {
         [ all_accounts_ removeObject: nonused_account_ ];
      }
      self.availableAccounts = all_accounts_;
   }
   
   return self;
}

-(id)initWithAccount:( id< PFAccount > )account_
{
   return [ self initWithAccount: account_ andNonusedAccount: nil ];
}

-(NSString*)valueForRow:( NSInteger )row_
{
   return [ [ self.availableAccounts objectAtIndex: row_ ] name ];
}

-(NSString*)value
{
   return self.selectedAccount.name;
}

-(NSUInteger)pickerField:( PFPickerField* )picker_field_
 numberOfRowsInComponent:( NSInteger )component_
{
   return [ self.availableAccounts count ];
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
   return [ self.availableAccounts indexOfObject: self.selectedAccount ];
}

-(void)pickerField:( PFPickerField* )picker_field_
      didSelectRow:( NSInteger )row_
       inComponent:( NSInteger )component_
{
   self.selectedAccount = [ self.availableAccounts objectAtIndex: row_ ];
   picker_field_.text = self.selectedAccount.name;
   
   [ super pickerField: picker_field_ didSelectRow: row_ inComponent: component_ ];
}

-(BOOL)pickerField:( PFPickerField* )picker_field_
 isCyclicComponent:( NSInteger )component_
{
   return NO;
}

@end
