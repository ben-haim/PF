//
//  JCNotificationBannerViewController.m
//  GlobalDriver2ClientBooking
//
//  Created by James Coleman on 8/26/12.
//
//

#import "JCNotificationBannerViewController.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ( [ [ [ UIDevice currentDevice ] systemVersion ] compare: v options: NSNumericSearch ] != NSOrderedAscending )

@interface JCNotificationBannerViewController ()

@end

@implementation JCNotificationBannerViewController

-(void)viewDidLoad
{
   [ super viewDidLoad ];
   
   if ( SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO( @"7.0" ) )
   {
      [ self setNeedsStatusBarAppearanceUpdate ];
   }
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
   return UIStatusBarStyleLightContent;
}

-(BOOL)shouldAutorotate
{
   return YES;
}

-(NSUInteger)supportedInterfaceOrientations
{
   return UIInterfaceOrientationMaskAll;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return YES;
}

@end
