#import "PFTableViewPriceItem.h"

#import "PFComponentDivider.h"

@interface PFTableViewPriceItem ()

@property ( nonatomic, strong ) PFComponentDivider* components;

@end

@implementation PFTableViewPriceItem

@synthesize components;

-(id)initWithTitle:( NSString* )title_
            symbol:( id< PFSymbol > )symbol_
             price:( PFDouble )price_
{
   self = [ super initWithAction: nil title: title_ ];

   if ( self )
   {
      self.components = [ PFComponentDivider dividerWithDouble: price_
                                                     precision: symbol_.instrument.precision ];
   }

   return self;
}

+(id)itemWithTitle:( NSString* )title_
            symbol:( id< PFSymbol > )symbol_
             price:( PFDouble )price_
{
   return [ [ self alloc ] initWithTitle: title_
                                  symbol: symbol_
                                   price: price_ ];
}

-(NSString*)value
{
   return [ self.components stringValue ];
}

-(PFDouble)price
{
   return [ self.components doubleValue ];
}

-(NSUInteger)numberOfComponentsInPickerField:( PFPickerField* )picker_field_
{
   return [ self.components componentsCount ];
}

-(NSUInteger)pickerField:( PFPickerField* )picker_field_
 numberOfRowsInComponent:( NSInteger )component_
{
   return [ self.components maximumValueForComponentWithIndex: component_ ] + 1;
}

-(NSString*)pickerField:( PFPickerField* )picker_field_
            titleForRow:( NSInteger )row_
           forComponent:( NSInteger )component_
{
   return [ self.components valueForRow: row_
                  forComponentWithIndex: component_ ];
}

-(void)pickerField:( PFPickerField* )picker_field_
      didSelectRow:( NSInteger )row_
       inComponent:( NSInteger )component_
{
   [ self.components setCurrentRow: row_
             forComponentWithIndex: component_ ];

   picker_field_.text = self.value;
   [ super pickerField: picker_field_ didSelectRow: row_ inComponent: component_ ];
}

-(NSUInteger)pickerField:( PFPickerField* )picker_field_
   currentRowInComponent:( NSInteger )component_
{
   return [ self.components currentRowForComponentWithIndex: component_ ];
}

@end
