//
//  PFTableViewSelectedAccountCardItemCell.h
//  PFTrader
//
//  Created by Denis on 19.06.14.
//  Copyright (c) 2014 profinancesoft. All rights reserved.
//

#import "PFTableViewItemCell.h"

@interface PFTableViewSelectedAccountCardItemCell : PFTableViewItemCell

@property (nonatomic, weak) IBOutlet UIImageView* headerView;
@property (nonatomic, weak) IBOutlet UILabel* accountTitleLabel;
@property (nonatomic, weak) IBOutlet UIImageView* arrowImageView;
@property (nonatomic, weak) IBOutlet UIView* contentView;

@property (nonatomic, weak) IBOutlet UILabel* accountBalanceLabel;
@property (nonatomic, weak) IBOutlet UILabel* projectedBalanceLabel;
@property (nonatomic, weak) IBOutlet UILabel* accountValueLabel;
@property (nonatomic, weak) IBOutlet UILabel* marginAvaliableLabel;
@property (nonatomic, weak) IBOutlet UILabel* currentMarginLabel;
@property (nonatomic, weak) IBOutlet UILabel* marginWarningLabel;
@property (nonatomic, weak) IBOutlet UILabel* blockedBalanceLabel;
@property (nonatomic, weak) IBOutlet UILabel* cashBalanceLabel;
@property (nonatomic, weak) IBOutlet UILabel* withdrawalLabel;

@property (nonatomic, weak) IBOutlet UILabel* accountBalanceValueLabel;
@property (nonatomic, weak) IBOutlet UILabel* projectedBalanceValueLabel;
@property (nonatomic, weak) IBOutlet UILabel* accountValueValueLabel;
@property (nonatomic, weak) IBOutlet UILabel* marginAvaliableValueLabel;
@property (nonatomic, weak) IBOutlet UILabel* currentMarginValueLabel;
@property (nonatomic, weak) IBOutlet UILabel* marginWarningValueLabel;
@property (nonatomic, weak) IBOutlet UILabel* blockedBalanceValueLabel;
@property (nonatomic, weak) IBOutlet UILabel* cashBalanceValueLabel;
@property (nonatomic, weak) IBOutlet UILabel* withdrawalValueLabel;

@property (nonatomic, weak) IBOutlet UIView* assetView;
@property (nonatomic, weak) IBOutlet UILabel* currentAssetTitleLable;
@property (nonatomic, weak) IBOutlet UILabel* currentAssetValueLabel;

@property (nonatomic, weak) IBOutlet UIButton* makeActiveButton;

@end
