#import "PFTableViewDoubleItem.h"

#import "PFIndicator.h"

#import "NSString+DoubleFormatter.h"

@interface PFTableViewDoubleItem ()

@property ( nonatomic, strong ) PFIndicatorAttributeDouble* doubleAttribute;

@end

@implementation PFTableViewDoubleItem

@synthesize doubleAttribute;

-(id)initWithDouble:( PFIndicatorAttributeDouble* )double_
{
   self = [ super initWithAction: nil title: double_.title ];
   if ( self )
   {
      self.doubleAttribute = double_;
   }
   return self;
}

-(NSString*)value
{
   return [ NSString stringWithDouble: self.doubleAttribute.value
                            precision: self.doubleAttribute.digits ];
}

-(NSUInteger)pickerField:( PFPickerField* )picker_field_
 numberOfRowsInComponent:( NSInteger )component_
{
   return ( self.doubleAttribute.max - self.doubleAttribute.min) / self.doubleAttribute.step + 1;
}

-(NSString*)pickerField:( PFPickerField* )picker_field_
            titleForRow:( NSInteger )row_
           forComponent:( NSInteger )component_
{
   return [ NSString stringWithDouble: row_ * self.doubleAttribute.step + self.doubleAttribute.min
                            precision: self.doubleAttribute.digits ];
}

-(NSUInteger)pickerField:( PFPickerField* )picker_field_
   currentRowInComponent:( NSInteger )component_
{
   return ( self.doubleAttribute.value - self.doubleAttribute.min ) / self.doubleAttribute.step;
}

-(void)pickerField:( PFPickerField* )picker_field_
      didSelectRow:( NSInteger )row_
       inComponent:( NSInteger )component_
{
   self.doubleAttribute.value = self.doubleAttribute.min + row_ * self.doubleAttribute.step;
   picker_field_.text = self.value;

   [ super pickerField: picker_field_ didSelectRow: row_ inComponent: component_ ];
}

@end
