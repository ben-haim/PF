#import "../../PFTypes.h"

#import "../../Data/PFChartPeriodType.h"
#import "../../Data/PFDoneBlockDefs.h"

#import <Foundation/Foundation.h>

@class PFServerInfo;

@interface PFChartApi : NSObject

-(id)initWithServerInfo:( PFServerInfo* )server_info_;

+(id)apiWithServerInfo:( PFServerInfo* )server_info_;

-(void)historyForInstrumentWithId:( PFInteger )instrument_id_
                        routeName:( NSString* )route_name_
                           userId:( PFInteger )user_id_
                        sessionId:( NSString* )session_id_
                           period:( PFChartPeriodType )period_
                             type:( PFByte )type_
                         fromDate:( NSDate* )from_date_
                           toDate:( NSDate* )to_date_
                        doneBlock:( PFHistoryDoneBlock )done_block_;

@end
