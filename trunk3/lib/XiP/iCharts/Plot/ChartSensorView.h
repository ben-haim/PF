//
//  ChartSensorView.h
//  XiP
//
//  Created by Xogee MacBook on 04/06/2011.
//  Copyright 2011 Xogee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FinanceChart;
@interface ChartSensorView : UIView 
{
    FinanceChart *chart;
}
@property (assign) FinanceChart *chart;
@end
