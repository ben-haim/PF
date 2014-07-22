#import "../../PFTypes.h"

#import "PFObject.h"

#import <Foundation/Foundation.h>

enum
{
   PFExpYearIgnore = 2000
};

@protocol PFSymbolId <NSObject>

-(PFInteger)instrumentId;
-(PFInteger)routeId;
-(PFByte)optionType;
-(PFShort)expYear;
-(PFByte)expMonth;
-(PFByte)expDay;
-(PFDouble)strikePrice;
-(BOOL)isGeneralOptionKey;
-(NSDate*)expirationDate;

@end

@protocol PFSymbol;
@protocol PFSymbolConnection;

@interface PFSymbolId : PFObject< PFSymbolId >

@property ( nonatomic, assign ) PFInteger instrumentId;
@property ( nonatomic, assign ) PFInteger routeId;
@property ( nonatomic, assign ) PFByte optionType;
@property ( nonatomic, assign ) PFShort expYear;
@property ( nonatomic, assign ) PFByte expMonth;
@property ( nonatomic, assign ) PFByte expDay;
@property ( nonatomic, assign ) PFDouble strikePrice;
@property ( nonatomic, assign ) BOOL isGeneralOptionKey;

@end

@interface PFSymbolIdKey : PFSymbolId

+(id)keyWithSymbolId:( id< PFSymbolId > )symbol_id_;
+(id)quotesKeyWithSymbol:( id< PFSymbol > )symbol_;
+(id)generalOptionKeyWithSymbolId:( id< PFSymbolId > )symbol_id_;

@end
