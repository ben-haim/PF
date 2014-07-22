#import "PFTableViewWidthItem.h"

#import "PFIndicator.h"

static NSUInteger PFMaxLineWidth = 4;
static NSUInteger PFMinLineWidth = 1;

@interface PFTableViewWidthItem ()

@property ( nonatomic, strong ) PFIndicatorAttributeWidth* width;

@end

@implementation PFTableViewWidthItem

@synthesize width;

-(id)initWithWidth:( PFIndicatorAttributeWidth* )width_
{
   self = [ super initWithAction: nil title: width_.title ];
   if ( self )
   {
      self.width = width_;
   }
   return self;
}

-(NSString*)value
{
   return [ NSString stringWithFormat: @"%d", (int)self.width.width ];
}

-(NSUInteger)pickerField:( PFPickerField* )picker_field_
 numberOfRowsInComponent:( NSInteger )component_
{
   return PFMaxLineWidth - PFMinLineWidth + 1;
}

-(NSString*)pickerField:( PFPickerField* )picker_field_
            titleForRow:( NSInteger )row_
           forComponent:( NSInteger )component_
{
   return [ NSString stringWithFormat: @"%d", (int)row_ + (int)PFMinLineWidth ];
}

-(NSUInteger)pickerField:( PFPickerField* )picker_field_
   currentRowInComponent:( NSInteger )component_
{
   return self.width.width - PFMinLineWidth;
}

-(void)pickerField:( PFPickerField* )picker_field_
      didSelectRow:( NSInteger )row_
       inComponent:( NSInteger )component_
{
   self.width.width = row_ + PFMinLineWidth;
   picker_field_.text = self.value;

   [ super pickerField: picker_field_ didSelectRow: row_ inComponent: component_ ];
}

@end
