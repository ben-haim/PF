#import "PFEventLogViewController_iPad.h"

#import "PFEventLogViewController.h"
#import "PFEventBrowserViewController.h"

@interface PFEventLogViewController_iPad () < PFEventLogViewControllerDelegate >

@end

@implementation PFEventLogViewController_iPad

-(id)init
{
   self = [ super init ];
   if ( self )
   {
      self.title = NSLocalizedString( @"EVENT_LOG", nil );
   }
   return self;
}

-(void)viewDidLoad
{   
   [ super viewDidLoad ];
   
   PFEventLogViewController* events_controller_ = [ PFEventLogViewController new ];
   events_controller_.delegate = self;
   self.masterController = events_controller_;
}

#pragma mark - PFEventLogViewControllerDelegate

-(void)eventLogViewController:( PFEventLogViewController* )controller_
              didSelectReport:( id< PFReportTable > )report_
{
   PFEventBrowserViewController* event_browser_ = [ [ PFEventBrowserViewController alloc ] initWithReport: report_ ];
   event_browser_.view.backgroundColor = [ UIColor clearColor ];
   
   self.detailController = event_browser_;
}

@end
