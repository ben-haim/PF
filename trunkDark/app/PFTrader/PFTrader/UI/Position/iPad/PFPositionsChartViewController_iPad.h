//
//  PFPositionsChartViewController_iPad.h
//  PFTrader
//
//  Created by Denis on 12.06.14.
//  Copyright (c) 2014 profinancesoft. All rights reserved.
//

#import "PFChartViewController_iPad.h"

@protocol PFPosition;

@interface PFPositionsChartViewController_iPad : PFChartViewController_iPad

-(id)initWithPosition:( id< PFPosition > )position_
          andInfoView:( UIView< PFChartInfoView >* )info_view_;

@end
