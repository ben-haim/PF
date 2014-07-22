//
//  PFOrdersInfo.h
//  PFTrader
//
//  Created by Vit on 18.06.14.
//  Copyright (c) 2014 profinancesoft. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PFChartViewController_iPad.h"

@protocol PFOrder;

@interface PFWatchlistInfoView : UIView < PFChartInfoView >

+(id)watchlistInfoViewWithSymbol:( id< PFSymbol > )symbol_;

@property ( nonatomic, weak ) IBOutlet UILabel* bidNameLabel;
@property ( nonatomic, weak ) IBOutlet UILabel* spreadNameLabel;
@property ( nonatomic, weak ) IBOutlet UILabel* askNameLabel;
@property ( nonatomic, weak ) IBOutlet UILabel* changeNameLabel;
@property ( nonatomic, weak ) IBOutlet UILabel* lastNameLabel;
@property ( nonatomic, weak ) IBOutlet UILabel* closeNameLabel;
@property ( nonatomic, weak ) IBOutlet UILabel* highNameLabel;
@property ( nonatomic, weak ) IBOutlet UILabel* lowNameLabel;
@property ( nonatomic, weak ) IBOutlet UILabel* openNameLabel;

@property ( nonatomic, weak ) IBOutlet UILabel* valueNameLabel;
@property ( nonatomic, weak ) IBOutlet UILabel* openInterNameLabel;
@property ( nonatomic, weak ) IBOutlet UILabel* symbolTypeNameLabel;
@property ( nonatomic, weak ) IBOutlet UILabel* tickSizeNameLabel;
@property ( nonatomic, weak ) IBOutlet UILabel* prevSettlPriceNameLabel;
@property ( nonatomic, weak ) IBOutlet UILabel* settlPriceNameLabel;

@property ( nonatomic, weak ) IBOutlet UILabel* bidValueLabel;
@property ( nonatomic, weak ) IBOutlet UILabel* spreadValueLabel;
@property ( nonatomic, weak ) IBOutlet UILabel* askValueLabel;
@property ( nonatomic, weak ) IBOutlet UILabel* changeValueLabel;
@property ( nonatomic, weak ) IBOutlet UILabel* lastValueLabel;
@property ( nonatomic, weak ) IBOutlet UILabel* closeValueLabel;
@property ( nonatomic, weak ) IBOutlet UILabel* highValueLabel;
@property ( nonatomic, weak ) IBOutlet UILabel* lowValueLabel;
@property ( nonatomic, weak ) IBOutlet UILabel* openValueLabel;

@property ( nonatomic, weak ) IBOutlet UILabel* valueValueLabel;
@property ( nonatomic, weak ) IBOutlet UILabel* openInterValueLabel;
@property ( nonatomic, weak ) IBOutlet UILabel* symbolValueLabel;
@property ( nonatomic, weak ) IBOutlet UILabel* tickValueLabel;
@property ( nonatomic, weak ) IBOutlet UILabel* prevSettlPriceValueLabel;
@property ( nonatomic, weak ) IBOutlet UILabel* settlPriceValueLabel;

@property ( nonatomic, weak ) IBOutlet UIButton* orederEntryButton;
@property ( nonatomic, weak ) IBOutlet UILabel* createOrderLabel;

@end
