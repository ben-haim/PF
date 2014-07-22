#import "PFTableViewQuantityItem.h"

#import "PFPickerField.h"
#import "PFTableViewPickerItemCell.h"

#import "PFRound.h"

#import "NSString+DoubleFormatter.h"

#import <ProFinanceApi/ProFinanceApi.h>

#import <math.h>

static double PFMaxLotsCount = 100.0;
static double PFMinLotsCount = 0.01;
static double PFLotStep = 0.01;

@interface PFTableViewQuantityItem ()

@property ( nonatomic, assign ) double lots;
@property ( nonatomic, assign ) double lotStep;
@property ( nonatomic, assign ) double minimalLot;
@property ( nonatomic, assign ) NSUInteger numberOfRows;
@property ( nonatomic, assign ) NSUInteger precision;

@end

@implementation PFTableViewQuantityItem

@synthesize lots;
@synthesize lotStep;
@synthesize minimalLot;
@synthesize numberOfRows;
@synthesize precision;

-(NSString*)value
{
   NSString* lots_count_ = [ NSString stringWithDouble: self.lots precision: self.precision ];

   return [ NSString stringWithFormat: NSLocalizedString( @"QUANTITY_FORMAT", nil ), lots_count_ ];
}

-(id)initWithSymbol:( id< PFSymbol > )symbol_
{
   return [ self initWithSymbol: symbol_ lots: symbol_.instrument.minimalLot ];
}

-(id)initWithLots:( double )lots_
       minimalLot:( double )minimal_lot_
          lotStep:( double )lot_step_
{
   self = [ super initWithAction: nil title: NSLocalizedString( @"QUANTITY", nil ) ];
   if ( self )
   {
      self.lots = lots_;
      self.minimalLot = minimal_lot_;
      self.lotStep = lot_step_;
      self.numberOfRows = ( PFMaxLotsCount - minimal_lot_ ) / lot_step_;
      self.precision = -log10( lot_step_ );
   }
   return self;
}

-(id)initWithSymbol:( id< PFSymbol > )symbol_
               lots:( double )lots_
{
   return [ self initWithLots: lots_
                   minimalLot: symbol_.instrument.minimalLot
                      lotStep: symbol_.instrument.lotStep ];
}

-(id)initWithLots:( double )lots_
{
   return [ self initWithLots: lots_
                   minimalLot: PFMinLotsCount
                      lotStep: PFLotStep ];
}

-(NSUInteger)pickerField:( PFPickerField* )picker_field_
 numberOfRowsInComponent:( NSInteger )component_
{
   return self.numberOfRows;
}

-(NSString*)pickerField:( PFPickerField* )picker_field_
            titleForRow:( NSInteger )row_
           forComponent:( NSInteger )component_
{
   return [ NSString stringWithDouble: ( row_ + 1 ) * self.lotStep
                            precision: self.precision ];
}

-(void)pickerField:( PFPickerField* )picker_field_
      didSelectRow:( NSInteger )row_
       inComponent:( NSInteger )component_
{
   self.lots = ( row_ + 1 ) * self.lotStep;
   picker_field_.text = self.value;
   [ super pickerField: picker_field_ didSelectRow: row_ inComponent: component_ ];
}

-(NSUInteger)pickerField:( PFPickerField* )picker_field_
   currentRowInComponent:( NSInteger )component_
{
   return ( self.lots / self.lotStep ) - 1;
}

-(BOOL)pickerField:( PFPickerField* )picker_field_
 isCyclicComponent:( NSInteger )component_
{
   return NO;
}

-(void)add:( double )lots_
{
   NSInteger steps_count_ = PFDoubleToInteger( lots_ / self.lotStep );

   double new_lots_ = fmin( fmax( self.minimalLot, self.lots + steps_count_ * self.lotStep ), PFMaxLotsCount - self.lotStep );

   PFTableViewPickerItemCell* picker_cell_ = ( PFTableViewPickerItemCell* )self.cell;
   PFPickerField* picker_field_ = ( PFPickerField* )picker_cell_.valueField;

   [ picker_field_ selectRow: PFDoubleToInteger( ( new_lots_ - self.minimalLot ) / self.lotStep )
                 inComponent: 0
                    animated: YES ];

   self.lots = new_lots_;

   picker_cell_.valueField.text = self.value;
   
   if ( self.pickerAction )
   {
      self.pickerAction( self );
   }
}

-(void)plus1
{
   [ self add: 1.0 ];
}

-(void)plus5
{
   [ self add: 5.0 ];
}

-(void)minus1
{
   [ self add: -1.0 ];
}

-(void)minus5
{
   [ self add: -5.0 ];
}

-(NSArray*)accessoryItemsInPickerField:( PFPickerField* )picker_field_
{
   UIBarButtonItem* minus_5_item_ = [ [ UIBarButtonItem alloc ] initWithTitle: NSLocalizedString( @"MINUS_5", nil )
                                                                        style: UIBarButtonItemStylePlain
                                                                       target: self
                                                                       action: @selector( minus5 ) ];

   UIBarButtonItem* minus_1_item_ = [ [ UIBarButtonItem alloc ] initWithTitle: NSLocalizedString( @"MINUS_1", nil )
                                                                        style: UIBarButtonItemStylePlain
                                                                       target: self
                                                                       action: @selector( minus1 ) ];

   UIBarButtonItem* plus_1_item_ = [ [ UIBarButtonItem alloc ] initWithTitle: NSLocalizedString( @"PLUS_1", nil )
                                                                       style: UIBarButtonItemStylePlain
                                                                      target: self
                                                                      action: @selector( plus1 ) ];
   
   UIBarButtonItem* plus_5_item_ = [ [ UIBarButtonItem alloc ] initWithTitle: NSLocalizedString( @"PLUS_5", nil )
                                                                       style: UIBarButtonItemStylePlain
                                                                      target: self
                                                                      action: @selector( plus5 ) ];

   return [ NSArray arrayWithObjects: minus_5_item_, minus_1_item_, plus_1_item_, plus_5_item_, nil ];
}

@end
