#import "PFPositionsViewController_iPad.h"

#import "PFPositionColumn.h"
#import "PFPositionColumn_iPad.h"

#import "PFGridFooterView.h"

#import "NSString+DoubleFormatter.h"
#import "UILabel+Price.h"

@implementation PFPositionsViewController_iPad

-(NSArray*)positionsColumns
{
   return [ NSArray arrayWithObjects: [ PFPositionColumn_iPad symbolColumn ]
           , [ PFPositionColumn_iPad quantityColumn ]
           , [ PFPositionColumn_iPad sideColumn ]
           , [ PFPositionColumn_iPad netPLColumn ]
           , [ PFPositionColumn_iPad commissionColumn ]
           , [ PFPositionColumn_iPad grossPlColumn ]
           , [ PFPositionColumn_iPad plTicksColumn ]
           , [ PFPositionColumn_iPad openPriceColumn ]
           , [ PFPositionColumn_iPad accountColumn ]
           , [ PFPositionColumn_iPad slColumn ]
           , [ PFPositionColumn_iPad tpColumn ]
           , [ PFPositionColumn_iPad swapsColumn ]
           , [ PFPositionColumn_iPad positionIdColumn ]
           , [ PFPositionColumn_iPad dateTimeColumn ]
           , [ PFPositionColumn_iPad instrumentTypeColumn ]
           , [ PFPositionColumn expirationDateColumn ]
           , nil ];
}

-(void)reloadBottomText
{
   id< PFAccount > default_account_ = [ PFSession sharedSession ].accounts.defaultAccount;
   
   self.footerView.firstTitleLabel.text = NSLocalizedString( @"ACCOUNT_BALANCE", nil );
   self.footerView.firstValueLabel.text = [ NSString stringWithFormat: @"%@ %@", [ NSString stringWithMoney: default_account_.balance ], default_account_.currency ];
   self.footerView.secondTitleLabel.text = NSLocalizedString( @"OPEN_NET_PL", nil );
   [ self.footerView.secondValueLabel showColouredValue: default_account_.totalNetPl precision: 2 suffix: default_account_.currency ];
   self.footerView.thirdTitleLabel.text = NSLocalizedString( @"CURRENT_MARGIN", nil );
   self.footerView.thirdValueLabel.text = [ NSString stringWithPercent: default_account_.currentMargin showPercentSign: YES ];
}

@end
