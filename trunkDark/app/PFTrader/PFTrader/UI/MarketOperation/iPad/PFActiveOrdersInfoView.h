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

@interface PFActiveOrdersInfoView : UIView < PFChartInfoView >

+(id)activeOrdersInfoViewWithOrder:( id< PFOrder > )order_;

@property (nonatomic, weak) IBOutlet UILabel* sideLabel;
@property (nonatomic, weak) IBOutlet UILabel* currentPriceLabel;
@property (nonatomic, weak) IBOutlet UILabel* dateTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel* stopPriceLabel;
@property (nonatomic, weak) IBOutlet UILabel* tifLabel;
@property (nonatomic, weak) IBOutlet UILabel* orderIdLabel;
@property (nonatomic, weak) IBOutlet UILabel* stopLossLabel;
@property (nonatomic, weak) IBOutlet UILabel* takeprofitLabel;
@property (nonatomic, weak) IBOutlet UILabel* qtyFilledLabel;
@property (nonatomic, weak) IBOutlet UILabel* qtyRemainingLabel;
@property (nonatomic, weak) IBOutlet UILabel* expirationDateLabel;
@property (nonatomic, weak) IBOutlet UILabel* initialReqLabel;
@property (nonatomic, weak) IBOutlet UILabel* accountLabel;
@property (nonatomic, weak) IBOutlet UILabel* symbolTypeLabel;

@property (nonatomic, weak) IBOutlet UILabel* sideValueLabel;
@property (nonatomic, weak) IBOutlet UILabel* currentPriceValueLabel;
@property (nonatomic, weak) IBOutlet UILabel* dateTimeValueLabel;
@property (nonatomic, weak) IBOutlet UILabel* stopPriceValueLabel;
@property (nonatomic, weak) IBOutlet UILabel* tifValueLabel;
@property (nonatomic, weak) IBOutlet UILabel* orderIdValueLabel;
@property (nonatomic, weak) IBOutlet UILabel* stopLossValueLabel;
@property (nonatomic, weak) IBOutlet UILabel* takeprofitValueLabel;
@property (nonatomic, weak) IBOutlet UILabel* qtyFilledValueLabel;
@property (nonatomic, weak) IBOutlet UILabel* qtyRemainingValueLabel;
@property (nonatomic, weak) IBOutlet UILabel* expirationDateValueLabel;
@property (nonatomic, weak) IBOutlet UILabel* initialReqValueLabel;
@property (nonatomic, weak) IBOutlet UILabel* accountValueLabel;
@property (nonatomic, weak) IBOutlet UILabel* symbolTypeValueLabel;

@property (nonatomic, weak) IBOutlet UIButton* cancelButton;
@property (nonatomic, weak) IBOutlet UIButton* modifyButton;

@end
