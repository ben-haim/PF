#import "Detail/PFObject.h"

#import "PFSymbolConnection.h"

#import "Detail/PFSymbolId.h"

#import <Foundation/Foundation.h>

@protocol PFSymbol;
@protocol PFLevel4Quote;

@protocol PFLevel4QuotePackage

-(NSDictionary*)putQuotes;
-(NSDictionary*)callQuotes;
-(NSDictionary*)putBinaryQuotes;
-(NSDictionary*)callBinaryQuotes;

-(id<PFSymbol>)symbol;

-(double)bidForSymbolId:( id<PFSymbolId> )symbol_id_;
-(double)askForSymbolId:( id<PFSymbolId> )symbol_id_;
-(double)crossPriceForSymbolId:( id<PFSymbolId> )symbol_id_;

-(void)updateQuote:( id< PFLevel4Quote > )quote_;

@end

@class PFSymbol;

@interface PFLevel4QuotePackage : PFSymbolId< PFLevel4QuotePackage >

@property ( nonatomic, weak ) PFSymbol* symbol;

@end

