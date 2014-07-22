#import "PFGridViewDelegate.h"
#import "PFGridViewDataSource.h"

#import "PFViewController.h"

@class PFGridView;

@protocol PFSymbol;

@interface PFMarketDepthViewController : PFViewController

@property ( nonatomic, strong ) IBOutlet UILabel* nameLabel;
@property ( nonatomic, strong ) IBOutlet UILabel* priceLabel;
@property ( nonatomic, strong ) IBOutlet UILabel* changeLabel;

@property ( nonatomic, strong ) IBOutlet UIView* bidView;
@property ( nonatomic, strong ) IBOutlet UIView* askView;

-(id)initWithSymbol:( id< PFSymbol > )symbol_;

@end
