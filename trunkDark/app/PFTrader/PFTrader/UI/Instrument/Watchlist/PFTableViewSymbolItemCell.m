#import "PFTableViewSymbolItemCell.h"
#import "PFTableViewSymbolItem.h"
#import "NSString+DoubleFormatter.h"
#import "UIImage+PFTableView.h"
#import "UILabel+Price.h"

#import <ProFinanceApi/ProFinanceApi.h>

@implementation PFTableViewSymbolItemCell

@synthesize symbolLabel;
@synthesize overviewLabel;
@synthesize changeTitleLabel;
@synthesize lastTitleLabel;
@synthesize changeValueLabel;
@synthesize lastValueLabel;

-(Class)expectedItemClass
{
   return [ PFTableViewSymbolItem class ];
}

-(void)awakeFromNib
{
   [ super awakeFromNib ];
   
   self.backgroundView = [ [ UIImageView alloc ] initWithImage: [ UIImage singleGroupedCellBackgroundImageSuperLight ] ];
}

-(void)reloadDataWithItem:( PFTableViewItem* )item_
{
   PFTableViewSymbolItem* symbol_item_ = ( PFTableViewSymbolItem* )item_;
   
   [ (UIImageView*)self.backgroundView setImage: symbol_item_.isSelected ? [ UIImage singleGroupedCellBackgroundImageSuperLight ] : [ UIImage singleGroupedCellBackgroundImageLight ] ];
   
   self.symbolLabel.text = symbol_item_.symbol.name;
   self.overviewLabel.text = symbol_item_.symbol.instrument.overview;
   self.changeTitleLabel.text = [ NSString stringWithFormat: @"%@:", NSLocalizedString( @"CHANGE", nil ) ];
   self.lastTitleLabel.text = [ NSString stringWithFormat: @"%@:", NSLocalizedString( @"LAST", nil ) ];
   [ self.lastValueLabel showLastForSymbol: symbol_item_.symbol ];
   [ self.changeValueLabel showColouredValue: symbol_item_.symbol.changePercent precision: 2 suffix: @"%" ];
}

-(void)updateDataWithItem:( PFTableViewItem* )item_
{
   [ self reloadDataWithItem: item_ ];
}

@end
