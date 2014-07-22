//
//  PFOperationsChartViewController_iPad.m
//  PFTrader
//
//  Created by Denis on 12.06.14.
//  Copyright (c) 2014 profinancesoft. All rights reserved.
//

#import "PFOperationsChartViewController_iPad.h"

#import <ProFinanceApi/ProFinanceApi.h>

@interface PFOperationsChartViewController_iPad ()

@property ( nonatomic, strong ) id< PFMarketOperation > currentOperation;

@end

@implementation PFOperationsChartViewController_iPad

@synthesize currentOperation;

-(id)initWithOperation:( id< PFMarketOperation > )operation_
           andInfoView:( UIView< PFChartInfoView >* )info_view_
{
   self = [ super initWithSybol: operation_.symbol
                    andInfoView: info_view_ ];
   
   if ( self )
   {
      self.currentOperation = operation_;
   }
   
   return self;
}

@end
