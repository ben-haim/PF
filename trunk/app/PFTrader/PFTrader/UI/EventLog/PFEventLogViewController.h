#import <UIKit/UIKit.h>

@protocol PFEventLogViewControllerDelegate;

@interface PFEventLogViewController : UITableViewController

@property ( nonatomic, weak ) id< PFEventLogViewControllerDelegate > delegate;

+(BOOL)isAvailable;

@end

@protocol PFReportTable;

@protocol PFEventLogViewControllerDelegate < NSObject >

-(void)eventLogViewController:( PFEventLogViewController* )controller_
              didSelectReport:( id< PFReportTable > )report_;

@end
