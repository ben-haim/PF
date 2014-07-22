//
//  PFУEnabledIndicatorsViewController.m
//  PFTrader
//
//  Created by Denis on 27.06.14.
//  Copyright (c) 2014 profinancesoft. All rights reserved.
//

#import "PFEnabledIndicatorsViewController.h"
#import "PFEnabledIndicatorsInfoController.h"
#import "PFIndicatorSettingsViewController.h"
#import "PFIndicatorsViewController.h"
#import "PFIndicatorLocalizedString.h"
#import "PFNavigationController.h"
#import "PFChartSettings.h"
#import "PFTabItem.h"
#import "UIColor+Skin.h"

@interface PFEnabledIndicatorsViewController () < PFEnabledIndicatorsInfoControllerDelegate, PFIndicatorsViewControllerDelegate >

@property ( nonatomic, strong ) UIViewController* contentController;

@end

@implementation PFEnabledIndicatorsViewController

@synthesize delegate;
@synthesize contentController = _contentController;

-(id)initWithSettings:( PFChartSettings* )settings_
{
   NSArray* items_ = @[[ PFTabItem itemWithControllerBuilder: ^UIViewController*() { return [ PFEnabledIndicatorsInfoController controllerWithSettings: settings_
                                                                                                                                             delegate: self
                                                                                                                                               isMain: YES ]; }
                                                      title: PFIndicatorLocalizedString( @"MAIN_INDICATORS", nil )
                                                       icon: nil ],
                      [ PFTabItem itemWithControllerBuilder: ^UIViewController*() { return [ PFEnabledIndicatorsInfoController controllerWithSettings: settings_
                                                                                                                                             delegate: self
                                                                                                                                               isMain: NO ]; }
                                                      title: PFIndicatorLocalizedString( @"ADDITIONAL_INDICATORS", nil )
                                                       icon: nil ]];
   
   self = [ self initWithTabItems: items_
                 selectedTabIndex: 0 ];
   
   if ( self )
   {
      self.title = NSLocalizedString( @"INDICATORS", nil );
   }
   
   return self;
}

-(void)done
{
   self.contentController = nil;
   [ self.delegate didCompleteIndicatorsController: self ];
}

-(void)viewDidLoad
{
   [ super viewDidLoad ];
   
   self.navigationItem.rightBarButtonItem = nil;
   
   self.pfNavigationWrapperController.navigationItem.rightBarButtonItem = [ [ UIBarButtonItem alloc ] initWithImage: [ UIImage imageNamed: @"PFCloseButtonModal" ]
                                                                                                              style: UIBarButtonItemStylePlain
                                                                                                             target: self
                                                                                                             action: @selector( done ) ];
   
   self.contentView.backgroundColor = [ UIColor backgroundLightColor ];
   [ self useRemoveAllButton: YES ];
}

-(IBAction)removeAllAction:( id )sender_
{
   PFChartSettings* chart_settings_ = [ PFChartSettings sharedSettings ];
   NSArray* main_indicators_ = [ chart_settings_.mainIndicators copy ];
   NSArray* additional_indicators_ = [ chart_settings_.additionalIndicators copy ];
   
   for ( PFIndicator* indicator_ in main_indicators_ )
   {
      [ chart_settings_ removeIndicator: indicator_ ];
   }
   
   for ( PFIndicator* indicator_ in additional_indicators_ )
   {
      [ chart_settings_ removeIndicator: indicator_ ];
   }
   
   [ (PFEnabledIndicatorsInfoController*)self.contentController updateTable ];
}

-(void)viewWillAppear:( BOOL )animated_
{
   [ super viewWillAppear: animated_ ];
   [ self setDarkNavigationBar ];
}

-(void)setContentController:(UIViewController *)content_controller_
{
   [ _contentController.view removeFromSuperview ];
   _contentController = nil;
   
   if ( content_controller_ )
   {
      _contentController = content_controller_;
      
      _contentController.view.frame = self.contentView.bounds;
      _contentController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
      [ _contentController.view removeFromSuperview ];
      [ self.contentView addSubview: _contentController.view ];
      [ (PFEnabledIndicatorsInfoController*)self.contentController updateTable ];
   }
}

-(void)performActionWithItem:( PFTabItem* )item_
{
   [ super performActionWithItem: item_ ];
   
   self.contentController = item_.controller;
}

#pragma mark - PFEnabledIndicatorsInfoControllerDelegate

-(void)showIndicatorSettingsController:( PFIndicatorSettingsViewController* )controller_
{
   controller_.closeBlock = ^{ [ self done ]; };
   
   [ self.pfNavigationController pushViewController: controller_
                                      previousTitle: self.title
                                           animated: YES ];
}

-(void)showAllIndicatorsController:( PFIndicatorsViewController* )controller_
{
   controller_.delegate = self;
   controller_.closeBlock = ^{ [ self done ]; };
   
   [ self.pfNavigationController pushViewController: controller_
                                      previousTitle: self.title
                                           animated: YES ];
}

#pragma mark - PFIndicatorsViewControllerDelegate

-(void)indicatorsController:( PFIndicatorsViewController* )controller_
         didSelectIndicator:( PFIndicator* )indicator_
{
   [ self.pfNavigationController popViewControllerAnimated: YES ];
   [ [ (PFEnabledIndicatorsInfoController*)self.contentController settings ] addIndicator: indicator_ ];
   [ (PFEnabledIndicatorsInfoController*)self.contentController updateTable ];
}

@end
