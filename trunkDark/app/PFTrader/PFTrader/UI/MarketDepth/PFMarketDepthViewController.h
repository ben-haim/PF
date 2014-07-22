#import "PFGridViewDelegate.h"
#import "PFGridViewDataSource.h"

#import "PFViewController.h"

@class PFGridView;

@protocol PFSymbol;

@interface PFMarketDepthViewController : PFViewController

@property ( nonatomic, weak ) IBOutlet UILabel* spreadLabel;
@property ( nonatomic, weak ) IBOutlet UILabel* priceLabel;
@property ( nonatomic, weak ) IBOutlet UILabel* changeLabel;
@property ( nonatomic, weak ) IBOutlet UILabel* spreadNameLabel;
@property ( nonatomic, weak ) IBOutlet UILabel* priceNameLabel;
@property ( nonatomic, weak ) IBOutlet UILabel* changeNameLabel;
@property ( nonatomic, weak ) IBOutlet UIView* titleView;
@property ( nonatomic, weak ) IBOutlet UIView* depthView;

-(id)initWithSymbol:( id< PFSymbol > )symbol_;

@end
