#import "Detail/PFObject.h"

#import "PFSymbolConnection.h"

#import "Detail/PFSymbolId.h"

#import <Foundation/Foundation.h>

@protocol PFSymbol;
@protocol PFLevel2Quote;

@protocol PFLevel2QuotePackage <PFSymbolId>

-(NSSet*)bidQuotes;
-(NSSet*)askQuotes;

-(NSArray*)sortedAndAgregatedBidQuotes;
-(NSArray*)sortedAndAgregatedAskQuotes;

-(id<PFSymbol>)symbol;

-(void)updateQuote:( id< PFLevel2Quote > )quote_;

-(NSUInteger)count;

@end

@interface PFLevel2QuotePackage : PFSymbolId< PFLevel2QuotePackage, PFSymbolConnection >

@property ( nonatomic, weak ) PFSymbol* symbol;

@end
