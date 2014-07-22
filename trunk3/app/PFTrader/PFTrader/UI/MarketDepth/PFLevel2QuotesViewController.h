#import "PFGridViewController.h"

#import <UIKit/UIKit.h>

@protocol PFSymbolPriceCellDelegate;
@protocol PFSymbol;

@interface PFLevel2QuotesViewController : PFGridViewController

+(id)depthControllerWithSymbolCellDelegate:( id< PFSymbolPriceCellDelegate > )delegate_
                                    symbol:( id< PFSymbol > )symbol_;

@end
