#import "PFTableViewOrderTypeItem.h"

#import "PFOrderTypeConversion.h"

#import "PFPickerField.h"

@interface PFTableViewOrderTypeItem ()

@property ( nonatomic, strong ) NSArray* types;
@property ( nonatomic, assign ) PFOrderType currentType;
@property ( nonatomic, assign ) PFOrderType oldType;

@end

@implementation PFTableViewOrderTypeItem

@synthesize types;
@synthesize currentType;
@synthesize oldType;

-(NSString*)value
{
   return NSStringFromPFOrderType( self.currentType );
}

-(id)init
{
   return [ self initWithType: PFOrderMarket andAllowedTypes: nil ];
}

-(id)initWithType:( PFOrderType )order_type_ andAllowedTypes:( NSArray* )allowed_order_types_
{
   self = [ super initWithAction: nil title: NSLocalizedString( @"ORDER_TYPE", nil ) ];
   if ( self )
   {
      if ( allowed_order_types_ )
      {
         self.types = allowed_order_types_;
         self.currentType = (PFOrderType)([ allowed_order_types_ containsObject: @(order_type_) ] ? order_type_ : [ [ allowed_order_types_ lastObject ] integerValue ]);
      }
      else
      {
         self.types = [ NSArray arrayWithObjects: @(PFOrderMarket)
                       , @(PFOrderLimit)
                       , @(PFOrderStop)
                       , @(PFOrderStopLimit)
                       , @(PFOrderTrailingStop)
                       , @(PFOrderOCO)
                       , nil ];
         
         self.currentType = order_type_;
      }
   }
   self.oldType = self.currentType;
   return self;
}

-(void)performAction
{
   if ( self.types.count > 0 )
   {
      [ super performAction ];
   }
}

-(NSUInteger)pickerField:( PFPickerField* )picker_field_
 numberOfRowsInComponent:( NSInteger )component_
{
   return [ self.types count ];
}

-(NSString*)pickerField:( PFPickerField* )picker_field_
            titleForRow:( NSInteger )row_
           forComponent:( NSInteger )component_
{
   return NSStringFromPFOrderType( [ [ self.types objectAtIndex: row_ ] shortValue ] );
}

-(void)pickerField:( PFPickerField* )picker_field_
      didSelectRow:( NSInteger )row_
       inComponent:( NSInteger )component_
{
   self.oldType = self.currentType;
   self.currentType = [ [ self.types objectAtIndex: row_ ] shortValue ];
   picker_field_.text = self.value;
   [ super pickerField: picker_field_ didSelectRow: row_ inComponent: component_ ];
}

-(NSUInteger)pickerField:( PFPickerField* )picker_field_
   currentRowInComponent:( NSInteger )component_
{
   NSUInteger current_index_ = [ self.types indexOfObject: @(self.currentType) ];
   return current_index_ == NSNotFound ? 0 : current_index_;
}

@end
