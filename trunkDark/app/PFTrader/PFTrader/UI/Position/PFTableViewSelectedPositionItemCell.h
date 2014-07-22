//
//  PFTableViewSelectedPositionItemCell.h
//  PFTrader
//
//  Created by Denis on 18.04.14.
//  Copyright (c) 2014 profinancesoft. All rights reserved.
//
#import "PFTableViewItemCell.h"

@protocol PFPosition;

@interface PFTableViewSelectedPositionItemCell : PFTableViewItemCell

@property ( nonatomic, weak ) IBOutlet UIImageView* headerView;

@property (nonatomic, weak) IBOutlet UILabel* symbolLabel;
@property (nonatomic, weak) IBOutlet UILabel* netPLLabel;
@property (nonatomic, weak) IBOutlet UILabel* quantityOpenPriceLabel;
@property (nonatomic, weak) IBOutlet UIImageView* arrowImage;
@property (nonatomic, weak) IBOutlet UIImageView* thinArrowImage;

@property (nonatomic, weak) IBOutlet UILabel* grossPLLabel;
@property (nonatomic, weak) IBOutlet UILabel* timeLabel;
@property (nonatomic, weak) IBOutlet UILabel* expireDateLabel;
@property (nonatomic, weak) IBOutlet UILabel* swapsLabel;
@property (nonatomic, weak) IBOutlet UILabel* stopLossLabel;
@property (nonatomic, weak) IBOutlet UILabel* positionIDLabel;
@property (nonatomic, weak) IBOutlet UILabel* feeLabel;
@property (nonatomic, weak) IBOutlet UILabel* currentPriceLabel;
@property (nonatomic, weak) IBOutlet UILabel* posExposLabel;
@property (nonatomic, weak) IBOutlet UILabel* accountLabel;
@property (nonatomic, weak) IBOutlet UILabel* takeProfitLabel;
@property (nonatomic, weak) IBOutlet UILabel* symbolTypeLabel;

@property (nonatomic, weak) IBOutlet UILabel* grossPLValueLabel;
@property (nonatomic, weak) IBOutlet UILabel* timeValueLabel;
@property (nonatomic, weak) IBOutlet UILabel* expireDateValueLabel;
@property (nonatomic, weak) IBOutlet UILabel* swapsValueLabel;
@property (nonatomic, weak) IBOutlet UILabel* stopLossValueLabel;
@property (nonatomic, weak) IBOutlet UILabel* positionIDValueLabel;
@property (nonatomic, weak) IBOutlet UILabel* feeValueLabel;
@property (nonatomic, weak) IBOutlet UILabel* currentPriceValueLabel;
@property (nonatomic, weak) IBOutlet UILabel* posExposValueLabel;
@property (nonatomic, weak) IBOutlet UILabel* accountValueLabel;
@property (nonatomic, weak) IBOutlet UILabel* takeProfitValueLabel;
@property (nonatomic, weak) IBOutlet UILabel* symbolTypeValueLabel;

@property (nonatomic, weak) IBOutlet UIButton* closeButton;
@property (nonatomic, weak) IBOutlet UIButton* modifyButton;

@end
