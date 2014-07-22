#import "PFSymbolConnection.h"
#import "Detail/PFSymbolId.h"

@protocol PFSymbol;
@protocol PFLevel4QuotePackage;

@protocol PFLevel4Quote <PFSymbolId >

-(PFInteger)bidSize;
-(PFInteger)askSize;
-(PFDouble)bid;
-(PFDouble)ask;
-(PFDouble)close;
-(PFDouble)open;
-(PFDouble)high;
-(PFDouble)low;
-(NSString*)underlier;
-(NSDate*)date;
-(PFDouble)lastSize;
-(PFDouble)crossPrice;
-(PFDouble)volume;
-(PFDouble)lastPrice;
-(NSDate*)expirationDate;
-(PFDouble)bidAmount;
-(PFDouble)askAmount;

-(id<PFSymbol>)symbol;

-(NSComparisonResult)compare:( id< PFLevel4Quote > )quote_;

-(PFDouble)delta;
-(void)setDelta:( PFDouble )delta_;

-(PFDouble)gamma;
-(void)setGamma:( PFDouble )gamma_;

-(PFDouble)vega;
-(void)setVega:( PFDouble )vega_;

-(PFDouble)theta;
-(void)setTheta:( PFDouble )theta_;

@end

@interface PFLevel4Quote : PFSymbolId< PFLevel4Quote, PFSymbolConnection >

@property ( nonatomic, assign ) PFInteger bidSize;
@property ( nonatomic, assign ) PFInteger askSize;
@property ( nonatomic, assign ) PFDouble bid;
@property ( nonatomic, assign ) PFDouble ask;
@property ( nonatomic, assign ) PFDouble close;
@property ( nonatomic, assign ) PFDouble open;
@property ( nonatomic, assign ) PFDouble high;
@property ( nonatomic, assign ) PFDouble low;
@property ( nonatomic, strong ) NSString* underlier;
@property ( nonatomic, strong ) NSDate* date;
@property ( nonatomic, assign ) PFDouble lastSize;
@property ( nonatomic, assign ) PFDouble crossPrice;
@property ( nonatomic, assign ) PFDouble volume;
@property ( nonatomic, assign ) PFDouble lastPrice;
@property ( nonatomic, assign ) PFDouble delta;
@property ( nonatomic, assign ) PFDouble gamma;
@property ( nonatomic, assign ) PFDouble vega;
@property ( nonatomic, assign ) PFDouble theta;

@property ( nonatomic, weak ) id< PFSymbol > symbol;

@end
