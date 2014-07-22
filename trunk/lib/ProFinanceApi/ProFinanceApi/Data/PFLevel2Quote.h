#import "../PFTypes.h"

#import "PFSymbolConnection.h"

#import "Detail/PFSymbolId.h"

#import <Foundation/Foundation.h>

typedef enum
{
   PFLevel2QuoteSideBid = 1
   , PFLevel2QuoteSideAsk = 2
} PFLevel2QuoteSide;

@protocol PFSymbol;
@protocol PFLevel2QuotePackage;

@protocol PFLevel2Quote <PFSymbolId >

-(PFDouble)price;
-(PFDouble)realPrice;
-(PFByte)side;
-(PFLong)size;
-(NSString*)source;
-(NSString*)quoteId;
-(NSDate*)date;
-(PFDouble)dayTradeVolume;
-(PFBool)isClosed;
-(id<PFSymbol>)symbol;

-(NSComparisonResult)compare:( id< PFLevel2Quote > )quote_;

-(void)connectToPackage:( id< PFLevel2QuotePackage > )package_;
-(void)disconnectFromPackage;

@end

@class PFSymbol;

@interface PFLevel2Quote : PFSymbolId< PFLevel2Quote, PFSymbolConnection >

@property ( nonatomic, assign ) PFDouble price;
@property ( nonatomic, assign ) PFDouble realPrice;
@property ( nonatomic, assign ) PFByte side;
@property ( nonatomic, assign ) PFLong size;
@property ( nonatomic, strong ) NSString* source;
@property ( nonatomic, strong ) NSString* quoteId;
@property ( nonatomic, strong ) NSDate* date;
@property ( nonatomic, assign ) PFDouble dayTradeVolume;
@property ( nonatomic, assign ) PFBool isClosed;

@end
