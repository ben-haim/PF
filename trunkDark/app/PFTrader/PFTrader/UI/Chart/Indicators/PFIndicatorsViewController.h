#import <UIKit/UIKit.h>

@protocol PFIndicatorsViewControllerDelegate;

typedef void (^PFIndicatorsViewControllerCloseBlock)();

@interface PFIndicatorsViewController : UITableViewController

@property ( nonatomic, weak ) id< PFIndicatorsViewControllerDelegate > delegate;
@property ( nonatomic, copy ) PFIndicatorsViewControllerCloseBlock closeBlock;

-(id)initWithIndicators:( NSArray* )indicators_;

@end

@class PFIndicator;

@protocol PFIndicatorsViewControllerDelegate < NSObject >

-(void)indicatorsController:( PFIndicatorsViewController* )controller_
         didSelectIndicator:( PFIndicator* )indicator_;

@end


