#import "PFEventLogViewController_iPad.h"
#import "PFEventLogViewController.h"
#import "PFEventBrowserViewController.h"

@interface PFEventLogViewController_iPad () < PFEventLogViewControllerDelegate >

@end

@implementation PFEventLogViewController_iPad

-(id)init
{
   PFEventLogViewController* events_controller_ = [ PFEventLogViewController new ];
   events_controller_.delegate = self;
   
   self = [ super initWithMasterController: events_controller_ ];
   
   if ( self )
   {
      self.title = NSLocalizedString( @"EVENT_LOG", nil );
   }
   
   return self;
}

#pragma mark - PFEventLogViewControllerDelegate

-(void)eventLogViewController:( PFEventLogViewController* )controller_
              didSelectReport:( id< PFReportTable > )report_
{
   PFEventBrowserViewController* event_browser_ = [ [ PFEventBrowserViewController alloc ] initWithReport: report_ ];
   event_browser_.view.backgroundColor = [ UIColor clearColor ];
   
   [ self showDetailController: event_browser_ ];
}

@end
