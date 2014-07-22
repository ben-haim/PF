#import "PFConcreteGridCell.h"

#import <UIKit/UIKit.h>

@class PFSymbolPriceCell;
@protocol PFSymbol;
@protocol PFLevel2Quote;
@protocol PFLevel4Quote;

@protocol PFSymbolPriceCellDelegate <NSObject>

@optional

-(void)symbolPriceCell:( PFSymbolPriceCell* )price_cell_
             buySymbol:( id< PFSymbol > )symbol_;

-(void)symbolPriceCell:( PFSymbolPriceCell* )price_cell_
            sellSymbol:( id< PFSymbol > )symbol_;

-(void)symbolPriceCell:( PFSymbolPriceCell* )price_cell_
   didSelectLeve2Quote:( id< PFLevel2Quote > )quote_;

-(void)symbolPriceCell:( PFSymbolPriceCell* )price_cell_
didAskSelectForLeve4Quote:( id< PFLevel4Quote > )quote_;

-(void)symbolPriceCell:( PFSymbolPriceCell* )price_cell_
didBidSelectForLeve4Quote:( id< PFLevel4Quote > )quote_;

@end

@interface PFSymbolPriceCell : PFPriceCell

@property ( nonatomic, strong ) IBOutlet UIButton* priceButton;
@property ( nonatomic, weak ) id< PFSymbolPriceCellDelegate > delegate;

-(IBAction)marketAction:( id )sender_;

@end

@interface PFSymbolAskCell : PFSymbolPriceCell

@end

@interface PFSymbolBidCell : PFSymbolPriceCell

@end

@interface PFSymbolBSizeCell : PFDetailCell

@end

@interface PFSymbolASizeCell : PFDetailCell

@end

@interface PFSymbolLastCell : PFDetailCell

@end

@interface PFSymbolSpreadCell : PFDetailCell

@end

@interface PFSymbolOpenCell : PFDetailCell

@end

@interface PFSymbolCloseCell : PFDetailCell

@end
