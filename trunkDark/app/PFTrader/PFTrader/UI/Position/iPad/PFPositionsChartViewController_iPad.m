//
//  PFPositionsChartViewController_iPad.m
//  PFTrader
//
//  Created by Denis on 12.06.14.
//  Copyright (c) 2014 profinancesoft. All rights reserved.
//

#import "PFPositionsChartViewController_iPad.h"
#import "PFSplitViewController.h"

#import <ProFinanceApi/ProFinanceApi.h>

@interface PFPositionsChartViewController_iPad ()

@property ( nonatomic, strong ) id< PFPosition > currentPosition;

@end

@implementation PFPositionsChartViewController_iPad

@synthesize currentPosition;

-(id)initWithPosition:( id< PFPosition > )position_
          andInfoView:( UIView< PFChartInfoView >* )info_view_
{
   self = [ super initWithSybol: position_.symbol
                    andInfoView: info_view_ ];
   
   if ( self )
   {
      self.currentPosition = position_;
   }
   
   return self;
}

-(void)processPositionRemoving:( id< PFPosition > )position_
{
   [ super processPositionRemoving: position_ ];
   
   if ( position_.positionId == self.currentPosition.positionId )
   {
      UIViewController* current_controller_ = self.ownedController ? self.ownedController : self;
      if ( [ current_controller_.splitViewController isKindOfClass: [ PFSplitViewController class ] ] )
      {
         [ (PFSplitViewController*)current_controller_.splitViewController showDetailController: nil ];
      }
   }
}

@end
