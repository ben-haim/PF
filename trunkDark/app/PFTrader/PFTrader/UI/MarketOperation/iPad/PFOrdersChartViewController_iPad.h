//
//  PFOrdersChartViewController_iPad.h
//  PFTrader
//
//  Created by Denis on 12.06.14.
//  Copyright (c) 2014 profinancesoft. All rights reserved.
//

#import "PFChartViewController_iPad.h"

@protocol PFOrder;

@interface PFOrdersChartViewController_iPad : PFChartViewController_iPad

-(id)initWithOrder:( id< PFOrder > )order_
       andInfoView:( UIView< PFChartInfoView >* )info_view_;

@end
