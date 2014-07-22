#import "PFTableViewTifItem.h"

#import "PFOrderValidityTypeConversion.h"

#import "PFPickerField.h"

@interface PFTableViewTifItem ()

@property ( nonatomic, strong ) NSArray* validities;
@property ( nonatomic, assign ) PFOrderValidityType currentValidity;

@end

@implementation PFTableViewTifItem

@synthesize validities;
@synthesize currentValidity;

-(NSString*)value
{
   return NSStringFromPFOrderValidityType( self.currentValidity );
}

-(id)initWithValidity:( PFOrderValidityType )validity_type_ andAllowedValidities:( NSArray* ) allowed_validities_
{
   self = [ super initWithAction: nil title: NSLocalizedString( @"TIF", nil ) ];
   if ( self )
   {
      if ( allowed_validities_ )
      {
         self.validities = allowed_validities_;
         self.currentValidity = (PFOrderValidityType)([ allowed_validities_ containsObject: @(validity_type_) ] ? validity_type_ : [ [ allowed_validities_ lastObject ] integerValue ]);
      }
      else
      {
         self.validities = [ NSArray arrayWithObjects: @(PFOrderValidityDay)
                            , @(PFOrderValidityGtc)
                            , @(PFOrderValidityGtd)
                            , @(PFOrderValidityIoc)
                            , nil ];
         
         self.currentValidity = validity_type_;
      }
   }
   
   return self;
}

-(id)init
{
   return [ self initWithValidity: PFOrderValidityDay andAllowedValidities: nil ];
}

-(NSUInteger)pickerField:( PFPickerField* )picker_field_
 numberOfRowsInComponent:( NSInteger )component_
{
   return [ self.validities count ];
}

-(NSString*)pickerField:( PFPickerField* )picker_field_
            titleForRow:( NSInteger )row_
           forComponent:( NSInteger )component_
{
   return NSStringFromPFOrderValidityType( [ [ self.validities objectAtIndex: row_ ] shortValue ] );
}

-(void)pickerField:( PFPickerField* )picker_field_
      didSelectRow:( NSInteger )row_
       inComponent:( NSInteger )component_
{
   self.currentValidity = [ [ self.validities objectAtIndex: row_ ] shortValue ];
   picker_field_.text = self.value;
   [ super pickerField: picker_field_ didSelectRow: row_ inComponent: component_ ];
}

-(NSUInteger)pickerField:( PFPickerField* )picker_field_
   currentRowInComponent:( NSInteger )component_
{
   NSUInteger current_index_ = [ self.validities indexOfObject: @(self.currentValidity) ];
   return current_index_ == NSNotFound ? 0 : current_index_;
}

-(BOOL)isEqual:( id ) object_
{
   return [self.validities isEqualToArray: ((PFTableViewTifItem*)object_).validities];
}

@end
