#import "PFGridViewController.h"

#import <UIKit/UIKit.h>

@protocol PFSymbolPriceCellDelegate;

@interface PFLevel2QuotesViewController : PFGridViewController

+(id)bidControllerWithSymbolCellDelegate:( id< PFSymbolPriceCellDelegate > )delegate_;
+(id)askControllerWithSymbolCellDelegate:( id< PFSymbolPriceCellDelegate > )delegate_;

@end
