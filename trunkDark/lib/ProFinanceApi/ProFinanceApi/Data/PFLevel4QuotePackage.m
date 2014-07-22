#import "PFLevel4QuotePackage.h"

#import "PFSymbol.h"
#import "PFLevel4Quote.h"

#import "PFField.h"
#import "PFMessage.h"

#import "PFSymbolOptionType.h"

@interface PFLevel4QuotePackage ()

@property ( strong ) NSMutableDictionary* mutablePutQuotes;
@property ( strong ) NSMutableDictionary* mutableCallQuotes;
@property ( strong ) NSMutableDictionary* mutablePutBinaryQuotes;
@property ( strong ) NSMutableDictionary* mutableCallBinaryQuotes;

-(BOOL)isValidExpirationDate: (NSDate*)date_;

@end

@implementation PFLevel4QuotePackage

@synthesize symbol;

@synthesize mutablePutQuotes;
@synthesize mutableCallQuotes;
@synthesize mutablePutBinaryQuotes;
@synthesize mutableCallBinaryQuotes;

-(NSDictionary*)putQuotes
{
   return self.mutablePutQuotes;
}

-(NSDictionary*)callQuotes
{
   return self.mutableCallQuotes;
}

-(NSDictionary*)putBinaryQuotes
{
   return self.mutablePutBinaryQuotes;
}

-(NSDictionary*)callBinaryQuotes
{
   return self.mutableCallBinaryQuotes;
}

-(id)init
{
   self = [ super init ];
   if ( self )
   {
      self.mutablePutQuotes = [ NSMutableDictionary new ];
      self.mutableCallQuotes = [ NSMutableDictionary new ];
      self.mutablePutBinaryQuotes = [ NSMutableDictionary new ];
      self.mutableCallBinaryQuotes = [ NSMutableDictionary new ];
   }
   return self;
}

-(void)dealloc
{
   self.mutablePutQuotes = nil;
   self.mutableCallQuotes = nil;
   self.mutablePutBinaryQuotes = nil;
   self.mutableCallBinaryQuotes = nil;
}

-(void)updateQuote:( id< PFLevel4Quote > )quote_
{
   if ( ![ self isValidExpirationDate: quote_.expirationDate ] || quote_.strikePrice <= 0 )
      return;
   
   NSMutableDictionary* quotes_;
   
   switch ( quote_.optionType )
   {
      case PFSymbolOptionTypePutVanilla:
         quotes_ = self.mutablePutQuotes;
         break;
         
      case PFSymbolOptionTypeCallVanilla:
         quotes_ = self.mutableCallQuotes;
         break;
         
      case PFSymbolOptionTypePutBinary:
         quotes_ = self.mutablePutBinaryQuotes;
         break;
         
      case PFSymbolOptionTypeCallBinary:
         quotes_ = self.mutableCallBinaryQuotes;
         break;
   }
   
   NSMutableSet* quotes_grop_ = quotes_[quote_.expirationDate];
   
   if (  ! quotes_grop_ )
   {
      quotes_grop_ = [ NSMutableSet new ];
      quotes_[quote_.expirationDate] = quotes_grop_;
   }
   else
   {
      [ quotes_grop_ removeObject: quote_ ];
   }
   
   [ quotes_grop_ addObject: quote_ ];
}

-(BOOL)isValidExpirationDate: (NSDate*)date_
{
   return !( [ date_ compare: [ NSDate date ] ] == NSOrderedAscending );
}

-(PFLevel4Quote*)level4QuoteForSymbolId:( id<PFSymbolId> )symbol_id_
{
   NSMutableDictionary* quotes_;
   
   switch ( symbol_id_.optionType )
   {
      case PFSymbolOptionTypePutVanilla:
         quotes_ = self.mutablePutQuotes;
         break;
         
      case PFSymbolOptionTypeCallVanilla:
         quotes_ = self.mutableCallQuotes;
         break;
         
      case PFSymbolOptionTypePutBinary:
         quotes_ = self.mutablePutBinaryQuotes;
         break;
         
      case PFSymbolOptionTypeCallBinary:
         quotes_ = self.mutableCallBinaryQuotes;
         break;
   }
   
   for ( PFLevel4Quote* level4Quote_ in [ quotes_[symbol_id_.expirationDate] allObjects ] )
   {
      if ( level4Quote_.strikePrice == symbol_id_.strikePrice )
      {
         return level4Quote_;
      }
   }
   
   return nil;
}

-(double)bidForSymbolId:( id<PFSymbolId> )symbol_id_
{
   PFLevel4Quote* level4_quote_ = [ self level4QuoteForSymbolId: symbol_id_ ];
   return level4_quote_ ? level4_quote_.bid : 0.0;
}

-(double)askForSymbolId:( id<PFSymbolId> )symbol_id_
{
   PFLevel4Quote* level4_quote_ = [ self level4QuoteForSymbolId: symbol_id_ ];
   return level4_quote_ ? level4_quote_.ask : 0.0;
}

-(double)crossPriceForSymbolId:( id<PFSymbolId> )symbol_id_
{
   PFLevel4Quote* level4_quote_ = [ self level4QuoteForSymbolId: symbol_id_ ];
   return level4_quote_ ? level4_quote_.crossPrice : 0.0;
}

@end
