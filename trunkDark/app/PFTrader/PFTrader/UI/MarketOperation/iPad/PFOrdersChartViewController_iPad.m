//
//  PFOrdersChartViewController_iPad.m
//  PFTrader
//
//  Created by Denis on 12.06.14.
//  Copyright (c) 2014 profinancesoft. All rights reserved.
//

#import "PFOrdersChartViewController_iPad.h"
#import "PFSplitViewController.h"

#import <ProFinanceApi/ProFinanceApi.h>

@interface PFOrdersChartViewController_iPad ()

@property ( nonatomic, strong ) id< PFOrder > currentOrder;

@end

@implementation PFOrdersChartViewController_iPad

@synthesize currentOrder;

-(id)initWithOrder:( id< PFOrder > )order_
       andInfoView:( UIView< PFChartInfoView >* )info_view_
{
   self = [ super initWithSybol: order_.symbol
                    andInfoView: info_view_ ];
   
   if ( self )
   {
      self.currentOrder = order_;
   }
   
   return self;
}

-(void)processOrderRemoving:( id< PFOrder > )order_
{
   [ super processOrderRemoving: order_ ];
   
   if ( order_.orderId == self.currentOrder.orderId )
   {
      UIViewController* current_controller_ = self.ownedController ? self.ownedController : self;
      if ( [ current_controller_.splitViewController isKindOfClass: [ PFSplitViewController class ] ] )
      {
         [ (PFSplitViewController*)current_controller_.splitViewController showDetailController: nil ];
      }
   }
}

@end
