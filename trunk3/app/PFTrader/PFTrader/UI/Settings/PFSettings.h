#import <Foundation/Foundation.h>

#import "PFSplittedViewState.h"

#import <ProFinanceApi/ProFinanceApi.h>

@interface PFSettings : NSObject

@property ( nonatomic, assign ) double lots;
@property ( nonatomic, assign ) PFOrderValidityType orderValidity;
@property ( nonatomic, assign ) PFOrderType orderType;
@property ( nonatomic, assign ) BOOL shouldConfirmPlaceOrder;
@property ( nonatomic, assign ) BOOL shouldConfirmModifyOrder;
@property ( nonatomic, assign ) BOOL shouldConfirmCancelOrder;
@property ( nonatomic, assign ) BOOL shouldConfirmModifyPosition;
@property ( nonatomic, assign ) BOOL shouldConfirmClosePosition;
@property ( nonatomic, assign ) BOOL shouldConfirmExecuteAsMarket;
@property ( nonatomic, assign ) double chartCacheMaxSize;
@property ( nonatomic, assign ) BOOL showModalForms;
@property ( nonatomic, assign ) float splitterTopPart;
@property ( nonatomic, assign ) PFSplittedViewState splitterState;
@property ( nonatomic, assign ) PFChartPeriodType defaultChartPeriod;
@property ( nonatomic, assign ) BOOL useSLTPOffset;
@property ( nonatomic, assign ) BOOL playSounds;
@property ( nonatomic, assign ) BOOL showTradingHalt;
@property ( nonatomic, assign ) BOOL showQuantityInLots;

+(PFSettings*)sharedSettings;

-(void)save;

@end
