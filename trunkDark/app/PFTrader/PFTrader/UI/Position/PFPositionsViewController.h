#import "PFTableViewControllerCard.h"

@protocol PFPosition;
@protocol PFPositionsViewControllerDelegate;

@interface PFPositionsViewController : PFTableViewControllerCard

@property ( nonatomic, strong ) id< PFPosition > selectedPosition;
@property ( nonatomic, weak ) id< PFPositionsViewControllerDelegate > delegate;

@end

@protocol PFPositionsViewControllerDelegate < NSObject >

-(void)positionsViewController:( PFPositionsViewController* )controller_
             didSelectPosition:( id< PFPosition > )position_;

@end
