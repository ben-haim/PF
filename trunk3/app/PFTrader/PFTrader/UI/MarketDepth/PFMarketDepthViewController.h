#import "PFGridViewDelegate.h"
#import "PFGridViewDataSource.h"

#import "PFViewController.h"

@class PFGridView;

@protocol PFSymbol;

@interface PFMarketDepthViewController : PFViewController

@property ( nonatomic, strong ) IBOutlet UILabel* nameLabel;
@property ( nonatomic, strong ) IBOutlet UILabel* priceLabel;
@property ( nonatomic, strong ) IBOutlet UILabel* changeLabel;
@property (strong, nonatomic) IBOutlet UILabel* priceNameLabel;
@property (strong, nonatomic) IBOutlet UILabel* changeNameLabel;

@property ( nonatomic, strong ) IBOutlet UIView* depthView;

-(id)initWithSymbol:( id< PFSymbol > )symbol_;

@end
