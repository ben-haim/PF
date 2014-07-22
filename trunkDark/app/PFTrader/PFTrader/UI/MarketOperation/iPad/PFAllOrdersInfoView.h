//
//  PFOrdersInfo.h
//  PFTrader
//
//  Created by Vit on 18.06.14.
//  Copyright (c) 2014 profinancesoft. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PFChartViewController_iPad.h"

@protocol PFMarketOperation;

@interface PFAllOrdersInfoView : UIView < PFChartInfoView >

+(id)marketOperationsInfoViewWithMarketOperation:( id< PFMarketOperation > )market_operation_;

@property (nonatomic, weak) IBOutlet UILabel* sideLabel;
@property (nonatomic, weak) IBOutlet UILabel* dateTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel* tifLabel;
@property (nonatomic, weak) IBOutlet UILabel* orderIdLabel;
@property (nonatomic, weak) IBOutlet UILabel* boughtLabel;
@property (nonatomic, weak) IBOutlet UILabel* soldLabel;
@property (nonatomic, weak) IBOutlet UILabel* accountLabel;
@property (nonatomic, weak) IBOutlet UILabel* symbolTypeLabel;
@property (nonatomic, weak) IBOutlet UILabel* quantityOpenPriceLabel;
@property (nonatomic, weak) IBOutlet UILabel* typeLabel;

@property (nonatomic, weak) IBOutlet UILabel* sideValueLabel;
@property (nonatomic, weak) IBOutlet UILabel* dateTimeValueLabel;
@property (nonatomic, weak) IBOutlet UILabel* tifValueLabel;
@property (nonatomic, weak) IBOutlet UILabel* orderIdValueLabel;
@property (nonatomic, weak) IBOutlet UILabel* boughtValueLabel;
@property (nonatomic, weak) IBOutlet UILabel* soldValueLabel;
@property (nonatomic, weak) IBOutlet UILabel* accountValueLabel;
@property (nonatomic, weak) IBOutlet UILabel* symbolTypeValueLabel;
@property (nonatomic, weak) IBOutlet UILabel* quantityOpenPriceValueLabel;
@property (nonatomic, weak) IBOutlet UILabel* typeValueLabel;

@end
