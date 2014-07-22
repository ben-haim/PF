#import "PFTableViewControllerCard.h"

@class PFSegmentedControl;
@protocol PFOrder;
@protocol PFTrade;
@protocol PFMarketOperation;
@protocol PFMarketOperationsViewControllerDelegate;

@interface PFMarketOperationsViewController : PFTableViewControllerCard

@property ( nonatomic, weak ) IBOutlet PFSegmentedControl* sourceSelector;
@property ( nonatomic, weak ) IBOutlet UIImageView* headerView;

@property ( nonatomic, strong ) id< PFOrder > selectedOrder;
@property ( nonatomic, strong ) id< PFTrade > selectedTrade;
@property ( nonatomic, strong ) id< PFMarketOperation > selectedOperation;

@property ( nonatomic, weak ) id< PFMarketOperationsViewControllerDelegate > delegate;

@end

@protocol PFMarketOperationsViewControllerDelegate < NSObject >

-(void)marketOperationsViewController:( PFMarketOperationsViewController* )controller_
                       didSelectOrder:( id< PFOrder > )order_;

-(void)marketOperationsViewController:( PFMarketOperationsViewController* )controller_
                       didSelectTrade:( id< PFTrade > )trade_;

-(void)marketOperationsViewController:( PFMarketOperationsViewController* )controller_
             didSelectMarketOperation:( id< PFMarketOperation > )market_operation_;

@end
