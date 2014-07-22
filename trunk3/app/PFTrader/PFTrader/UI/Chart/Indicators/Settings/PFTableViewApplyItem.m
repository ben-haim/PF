#import "PFTableViewApplyItem.h"

#import "PFIndicator.h"

#import "PFIndicatorLocalizedString.h"

@interface PFTableViewApplyItem ()

@property ( nonatomic, strong ) PFIndicatorAttributeApply* apply;
@property ( nonatomic, strong ) NSArray* availableApplies;

@end

@implementation PFTableViewApplyItem

@synthesize apply;
@synthesize availableApplies;

-(id)initWithApply:(PFIndicatorAttributeApply *)apply_
{
   self = [ super initWithAction: nil title: apply_.title ];
   if ( self )
   {
      self.apply = apply_;

      self.availableApplies = @[ PFIndicatorLocalizedString( @"APPLY_TYPE_CLOSE", nil )
      , PFIndicatorLocalizedString( @"APPLY_TYPE_OPEN", nil )
      , PFIndicatorLocalizedString( @"APPLY_TYPE_HIGH", nil )
      , PFIndicatorLocalizedString( @"APPLY_TYPE_LOW", nil )
      , PFIndicatorLocalizedString( @"APPLY_TYPE_HL2", nil )
      , PFIndicatorLocalizedString( @"APPLY_TYPE_HLC2", nil )
      , PFIndicatorLocalizedString( @"APPLY_TYPE_HLC3", nil )
      , PFIndicatorLocalizedString( @"APPLY_TYPE_HLCC4", nil )
      ];
   }
   return self;
}

-(NSString*)value
{
   return [ self.availableApplies objectAtIndex: self.apply.applyType ];
}

-(NSUInteger)pickerField:( PFPickerField* )picker_field_
 numberOfRowsInComponent:( NSInteger )component_
{
   return [ self.availableApplies count ];
}

-(NSString*)pickerField:( PFPickerField* )picker_field_
            titleForRow:( NSInteger )row_
           forComponent:( NSInteger )component_
{
   return [ self.availableApplies objectAtIndex: row_ ];
}

-(NSUInteger)pickerField:( PFPickerField* )picker_field_
   currentRowInComponent:( NSInteger )component_
{
   return self.apply.applyType;
}

-(void)pickerField:( PFPickerField* )picker_field_
      didSelectRow:( NSInteger )row_
       inComponent:( NSInteger )component_
{
   self.apply.applyType = (PFIndicatorAttributeApplyType)row_;
   picker_field_.text = [ self.availableApplies objectAtIndex: row_ ];

   [ super pickerField: picker_field_ didSelectRow: row_ inComponent: component_ ];
}

-(BOOL)pickerField:( PFPickerField* )picker_field_
 isCyclicComponent:( NSInteger )component_
{
   return NO;
}

@end
