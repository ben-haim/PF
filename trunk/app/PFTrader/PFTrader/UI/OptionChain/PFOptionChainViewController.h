#import "PFGridViewController.h"

#import "PFSymbolCell.h"

@protocol PFSymbol;

@class PFSegmentedControl;
@class PFPickerField;

@interface PFOptionChainViewController : PFGridViewController < PFSymbolPriceCellDelegate >

@property ( strong, nonatomic ) IBOutlet UITextField* expirationSelector;
@property ( strong, nonatomic ) IBOutlet PFSegmentedControl* optionTypeSelector;

-(id)initWithSymbol:( id< PFSymbol > )option_symbol_ andBaseSymbol:( id< PFSymbol > )base_symbol_;

@end
