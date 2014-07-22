#import "PFActiveIndicatorsViewController.h"

#import "PFIndicatorsViewController.h"
#import "PFIndicatorSettingsViewController.h"

#import "PFChartSettings.h"

#import "PFSectionHeaderView.h"
#import "PFIndicatorLocalizedString.h"

#import "PFIndicator.h"

#import "PFIndicatorCell.h"

#import "UIImage+PFTableView.h"
#import "UIColor+Skin.h"

#import <JFFMessageBox/JFFMessageBox.h>

typedef enum
{
   PFIndicatorSectionMain
   , PFIndicatorSectionAdditional
   , PFIndicatorSectionsCount
} PFIndicatorSectionIndex;

@interface PFActiveIndicatorsViewController ()< PFIndicatorsViewControllerDelegate >

@property ( nonatomic, strong ) PFChartSettings* settings;

@end

@implementation PFActiveIndicatorsViewController

@synthesize settings;
@synthesize delegate;

-(id)initWithSettings:( PFChartSettings* )settings_
{
   self = [ self initWithStyle: UITableViewStylePlain ];

   if ( self )
   {
      self.title = NSLocalizedString( @"INDICATORS", nil );
      self.settings = settings_;
   }

   return self;
}

-(void)addIndicator
{
   static NSUInteger PFMaxIndicatorsCount = 7;

   if ( [ self.settings userIndicatorsCount ] < PFMaxIndicatorsCount )
   {
      PFIndicatorsViewController* indicators_controller_ = [ [ PFIndicatorsViewController alloc ] initWithIndicators: self.settings.defaultIndicators ];

      indicators_controller_.delegate = self;

      [ self.navigationController pushViewController: indicators_controller_ animated: YES ];
   }
   else
   {
      JFFAlertView* alert_view_ = [ JFFAlertView alertWithTitle: nil
                                                        message: NSLocalizedString( @"INDICATORS_LIMIT", nil )
                                              cancelButtonTitle: NSLocalizedString( @"OK", nil )
                                              otherButtonTitles: nil ];
      
      [ alert_view_ show ];
   }
}

-(void)done
{
   [ self.delegate didCompleteIndicatorsController: self ];
}

-(void)viewDidLoad
{
   [ super viewDidLoad ];

   self.navigationItem.rightBarButtonItem =
   [ [ UIBarButtonItem alloc ] initWithBarButtonSystemItem: UIBarButtonSystemItemAdd
                                                    target: self
                                                    action: @selector( addIndicator ) ];
   
   self.navigationItem.leftBarButtonItem =
   [ [ UIBarButtonItem alloc ] initWithBarButtonSystemItem: UIBarButtonSystemItemDone
                                                    target: self
                                                    action: @selector( done ) ];

   self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
   self.tableView.backgroundColor = [ UIColor tableBackgroundColor ];
}

-(void)indicatorsController:( PFIndicatorsViewController* )controller_
         didSelectIndicator:( PFIndicator* )indicator_
{
   [ self.navigationController popViewControllerAnimated: YES ];

   [ self.settings addIndicator: indicator_ ];

   [ self.tableView reloadData ];
}

-(BOOL)shouldAutorotate
{
   return YES;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:( UIInterfaceOrientation )interface_orientation_
{
   return UIInterfaceOrientationIsPortrait( interface_orientation_ );
}

-(NSUInteger)supportedInterfaceOrientations
{
   return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
}

-(void)willRotateToInterfaceOrientation:( UIInterfaceOrientation )interface_orientation_
                               duration:( NSTimeInterval )duration_
{
   [ super willRotateToInterfaceOrientation: interface_orientation_ duration: duration_ ];
   [ self.delegate willRotateToInterfaceOrientation: interface_orientation_ duration: duration_ ];
}

#pragma mark - Table view data source

-(NSArray*)indicatorsForSection:( NSUInteger )section_
{
   if ( section_ == PFIndicatorSectionMain )
      return self.settings.mainIndicators;
   
   return self.settings.additionalIndicators;
}

-(PFIndicator*)indicatorForIndexPath:( NSIndexPath* )index_path_
{
   return [ [ self indicatorsForSection: index_path_.section ] objectAtIndex: index_path_.row ];
}

-(NSInteger)numberOfSectionsInTableView:( UITableView* )table_view_
{
   return PFIndicatorSectionsCount;
}

-(NSInteger)tableView:( UITableView* )table_view_ numberOfRowsInSection:( NSInteger )section_
{
   return [ [ self indicatorsForSection: section_ ] count ];
}

-(UIView*)tableView:( UITableView* )table_view_ viewForHeaderInSection:( NSInteger )section_
{
   PFSectionHeaderView* header_view_ = [ PFSectionHeaderView new ];
   header_view_.textLabel.text = section_ == PFIndicatorSectionMain
      ? PFIndicatorLocalizedString( @"MAIN_INDICATORS", nil )
      : PFIndicatorLocalizedString( @"ADDITIONAL_INDICATORS", nil );
   return header_view_;
}

-(UITableViewCell*)tableView:( UITableView* )table_view_ cellForRowAtIndexPath:( NSIndexPath* )index_path_
{
   static NSString* cell_identifier_ = @"PFIndicatorCell";
   
   PFIndicatorCell* cell_ = ( PFIndicatorCell* )[ table_view_ dequeueReusableCellWithIdentifier: cell_identifier_ ];
   
   if ( !cell_ )
   {
      cell_ = [ PFIndicatorCell cell ];
      cell_.accessoryView = [ [ UIImageView alloc ] initWithImage: [ UIImage tableAccessoryIndicatorImage ] ];
   }
   
   PFIndicator* indicator_ = [ self indicatorForIndexPath: index_path_ ];
   cell_.nameLabel.text = indicator_.title;

   return cell_;
}

- (void)tableView:( UITableView* )table_view_
commitEditingStyle:( UITableViewCellEditingStyle )style_
forRowAtIndexPath:( NSIndexPath* )index_path_
{
   PFIndicator* indicator_ = [ self indicatorForIndexPath: index_path_ ];
   [ self.settings removeIndicator: indicator_ ];

   [ table_view_ deleteRowsAtIndexPaths: [ NSArray arrayWithObject: index_path_ ]
                       withRowAnimation: UITableViewRowAnimationRight ];
}

#pragma mark - Table view delegate

-(void)tableView:(UITableView *)table_view_ didSelectRowAtIndexPath:(NSIndexPath *)index_path_
{
   PFIndicator* indicator_ = [ self indicatorForIndexPath: index_path_ ];

   PFIndicatorSettingsViewController* settings_controller_ = [ [ PFIndicatorSettingsViewController alloc ] initWithIndicator: indicator_ ];

   [ self.navigationController pushViewController: settings_controller_ animated: YES ];
}

-(UITableViewCellEditingStyle)tableView:( UITableView* )table_view_
          editingStyleForRowAtIndexPath:( NSIndexPath* )index_path_
{
   return UITableViewCellEditingStyleDelete;
}

-(CGFloat)tableView: (UITableView*)table_view_ heightForHeaderInSection: (NSInteger)section_
{
   return [ [ self indicatorsForSection: section_ ] count ] == 0 ? 0.f : 20.f;
}

@end
