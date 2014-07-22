#import "PFGridViewController.h"
#import "PFSymbolCell.h"

@class PFSegmentedControl;
@class PFPickerField;


@interface PFOptionChainViewController : PFGridViewController < PFSymbolPriceCellDelegate >

@property ( nonatomic, weak ) IBOutlet UITextField* expirationSelector;
@property ( nonatomic, weak ) IBOutlet PFSegmentedControl* optionTypeSelector;

-(id)initWithSymbol:( id< PFSymbol > )option_symbol_
      andBaseSymbol:( id< PFSymbol > )base_symbol_;

@end
