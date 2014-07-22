#import "PFGridViewController.h"

@protocol PFReportTable;

@interface PFReportGridViewController : PFGridViewController

-(id)initWithReportTable:( id< PFReportTable > )table_;

@end
