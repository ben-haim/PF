//
//  PFAccountInfoViewController_iPad.h
//  PFTrader
//
//  Created by Denis on 19.06.14.
//  Copyright (c) 2014 profinancesoft. All rights reserved.
//

#import "PFViewController.h"

@class PFAccountSpeedometr;
@class PFTableView;
@protocol PFAccount;

@interface PFAccountInfoViewController_iPad : PFViewController

@property ( nonatomic, weak ) IBOutlet UIImageView* headerView;
@property ( nonatomic, weak ) IBOutlet PFTableView* assetTable;
@property ( nonatomic, weak ) IBOutlet PFTableView* assetInfoTable;

@property ( nonatomic, weak ) IBOutlet UIScrollView* contentScrollView;
@property ( nonatomic, weak ) IBOutlet UIView *fundView;

// Today
@property ( nonatomic, weak ) IBOutlet UILabel* firstTitleTodayLabel;
@property ( nonatomic, weak ) IBOutlet UILabel* firstValueTodayLabel;
@property ( nonatomic, weak ) IBOutlet UILabel* secondTitleTodayLabel;
@property ( nonatomic, weak ) IBOutlet UILabel* secondValueTodayLabel;
@property ( nonatomic, weak ) IBOutlet UILabel* thirdTitleTodayLabel;
@property ( nonatomic, weak ) IBOutlet UILabel* thirdValueTodayLabel;
@property ( nonatomic, weak ) IBOutlet UILabel* fifthTitleTodayLabel;
@property ( nonatomic, weak ) IBOutlet UILabel* fifthValueTodayLabel;

@property ( nonatomic, weak ) IBOutlet UILabel* currentFundCapitalActivityTitleLabel;
@property ( nonatomic, weak ) IBOutlet UILabel* fundCapitalGainActivityTitleLabel;
@property ( nonatomic, weak ) IBOutlet UILabel* investedFundCapitalActivityTitleLabel;

@property ( nonatomic, weak ) IBOutlet UILabel* todayLabel;

// Activity
@property ( nonatomic, weak ) IBOutlet UILabel* firstTitleActivityLabel;
@property ( nonatomic, weak ) IBOutlet UILabel* firstValueActivityLabel;
@property ( nonatomic, weak ) IBOutlet UILabel* secondTitleActivityLabel;
@property ( nonatomic, weak ) IBOutlet UILabel* secondValueActivityLabel;
@property ( nonatomic, weak ) IBOutlet UILabel* thirdTitleActivityLabel;
@property ( nonatomic, weak ) IBOutlet UILabel* thirdValueActivityLabel;
@property ( nonatomic, weak ) IBOutlet UILabel* fifthTitleActivityLabel;
@property ( nonatomic, weak ) IBOutlet UILabel* fifthValueActivityLabel;
@property ( nonatomic, weak ) IBOutlet UILabel* sixthTitleActivityLabel;
@property ( nonatomic, weak ) IBOutlet UILabel* sixthValueActivityLabel;

@property ( nonatomic, weak ) IBOutlet UILabel* currentFundCapitalActivityValueLabel;
@property ( nonatomic, weak ) IBOutlet UILabel* fundCapitalGainActivityValueLabel;
@property ( nonatomic, weak ) IBOutlet UILabel* investedFundCapitalActivityValueLabel;

@property ( nonatomic, weak ) IBOutlet UILabel* activeLabel;

@property (nonatomic, weak) IBOutlet PFAccountSpeedometr* accountSpeedometrTodayView;
@property (nonatomic, weak) IBOutlet PFAccountSpeedometr* accountSpeedometrActivityView;
@property (nonatomic, weak) IBOutlet UILabel* realizedNetPLValueTodayLabel;
@property (nonatomic, weak) IBOutlet UILabel* realizedNetPLValueActivityLabel;

+(id)infoControllerWithAccount:( id< PFAccount > )account_;

@end
