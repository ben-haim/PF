#import "../PFTypes.h"

#import "PFMarketOperation.h"

#import <Foundation/Foundation.h>

@protocol PFTrade< PFMarketOperation >

-(PFInteger)tradeId;
-(PFDouble)commission;
-(PFDouble)grossPl;
-(PFDouble)netPl;
-(NSString*)extId;
-(PFBool)isBuy;
-(NSString*)login;
-(PFDouble)externalPrice;
-(NSString*)exchange;
-(PFDouble)exposure;

@end

@interface PFTrade : PFMarketOperation< PFTrade >

@property ( nonatomic, assign ) PFInteger tradeId;
@property ( nonatomic, assign ) PFDouble commission;
@property ( nonatomic, assign ) PFDouble grossPl;
@property ( nonatomic, strong ) NSString* extId;
@property ( nonatomic, assign ) PFBool isBuy;
@property ( nonatomic, strong ) NSString* login;
@property ( nonatomic, assign ) PFDouble externalPrice;
@property ( nonatomic, strong ) NSString* exchange;
@property ( nonatomic, assign ) PFDouble exposure;

@end
