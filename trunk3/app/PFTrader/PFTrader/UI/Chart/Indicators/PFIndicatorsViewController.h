#import <UIKit/UIKit.h>

@protocol PFIndicatorsViewControllerDelegate;

@interface PFIndicatorsViewController : UITableViewController

@property ( nonatomic, weak ) id< PFIndicatorsViewControllerDelegate > delegate;

-(id)initWithIndicators:( NSArray* )indicators_;

@end

@class PFIndicator;

@protocol PFIndicatorsViewControllerDelegate <NSObject>

-(void)indicatorsController:( PFIndicatorsViewController* )controller_
         didSelectIndicator:( PFIndicator* )indicator_;

@end


