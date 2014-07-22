//
//  PFEnabledIndicatorsInfoController.m
//  PFTrader
//
//  Created by Denis on 27.06.14.
//  Copyright (c) 2014 profinancesoft. All rights reserved.
//

#import "PFEnabledIndicatorsInfoController.h"
#import "PFIndicatorSettingsViewController.h"
#import "PFIndicatorsViewController.h"
#import "PFIndicatorCell.h"
#import "PFIndicator.h"
#import "PFChartSettings.h"
#import "PFButton.h"
#import "UIColor+Skin.h"

#import <JFFMessageBox/JFFMessageBox.h>

@interface PFEnabledIndicatorsInfoController ()

@property ( nonatomic, strong ) PFChartSettings* settings;
@property ( nonatomic, assign ) BOOL isMain;
@property ( nonatomic, weak ) id< PFEnabledIndicatorsInfoControllerDelegate > delegate;

@end

@implementation PFEnabledIndicatorsInfoController

@synthesize settings;
@synthesize isMain;
@synthesize delegate;

+(id)controllerWithSettings:( PFChartSettings* )settings_
                   delegate:( id< PFEnabledIndicatorsInfoControllerDelegate > )delegate_
                     isMain:( BOOL )is_main_
{
   PFEnabledIndicatorsInfoController* controller_ = [ [ PFEnabledIndicatorsInfoController alloc ] initWithStyle: UITableViewStylePlain ];
   controller_.settings = settings_;
   controller_.isMain = is_main_;
   controller_.delegate = delegate_;
   
   return controller_;
}

-(void)viewDidLoad
{
   [ super viewDidLoad ];
   
   UIView* header_view_ = [ [ UIView alloc ] initWithFrame: CGRectMake( 0.f, 0.f, self.view.frame.size.width, 55.f ) ];
   header_view_.autoresizingMask = UIViewAutoresizingFlexibleWidth;
   header_view_.backgroundColor = [ UIColor clearColor ];
   
   PFGrayRoundButtonBlueTitle* add_button_ = [ [ PFGrayRoundButtonBlueTitle alloc ] initWithFrame: CGRectMake( 10.f, 13.f, 100.f, 34.f ) ];
   [ add_button_ addTarget: self action: @selector( addIndicator ) forControlEvents: UIControlEventTouchUpInside ];
   [ add_button_ setTitle: @"+ ADD" forState: UIControlStateNormal ];
   [ header_view_ addSubview: add_button_ ];
   
   self.tableView.tableHeaderView = header_view_;
   
   
   self.view.backgroundColor =[ UIColor backgroundLightColor ];
   self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(void)addIndicator
{
   static NSUInteger PFMaxIndicatorsCount = 7;
   
   if ( [ self.settings userIndicatorsCount ] < PFMaxIndicatorsCount )
   {
      [ self.delegate showAllIndicatorsController: [ [ PFIndicatorsViewController alloc ] initWithIndicators: self.isMain ?
                                                    self.settings.defaultMainIndicators : self.settings.defaultAdditionalIndicators ] ];
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

-(void)removeIndicator:( PFIndicator* )indicator_
{
   [ self.settings removeIndicator: indicator_ ];
   [ self updateTable ];
}

-(void)updateTable
{
   [ self.tableView reloadData ];
}

-(PFIndicator*)indicatorForRow:( NSInteger )row_
{
   return ( self.isMain ? self.settings.mainIndicators : self.settings.additionalIndicators )[row_];
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:( UITableView*)table_view_ numberOfRowsInSection:( NSInteger )section_
{
   return [ ( self.isMain ? self.settings.mainIndicators : self.settings.additionalIndicators ) count ];
}

-(UITableViewCell*)tableView:( UITableView*)table_view_ cellForRowAtIndexPath:( NSIndexPath* )index_path_
{
   PFIndicatorCell* indicator_info_cell_ = [ table_view_ dequeueReusableCellWithIdentifier: @"PFIndicatorCell" ];
   
   if ( !indicator_info_cell_ )
   {
      indicator_info_cell_ = [ PFIndicatorCell cell ];
   }
   
   PFIndicator* indicator_ = [ self indicatorForRow: index_path_.row ];
   indicator_info_cell_.nameLabel.text = indicator_.title;
   indicator_info_cell_.indicator = indicator_;
   indicator_info_cell_.controller = self;
   
   return indicator_info_cell_;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)table_view_ didSelectRowAtIndexPath:(NSIndexPath *)index_path_
{
   [ self.delegate showIndicatorSettingsController: [ [ PFIndicatorSettingsViewController alloc ] initWithIndicator: [ self indicatorForRow: index_path_.row ] ] ];
}

@end
