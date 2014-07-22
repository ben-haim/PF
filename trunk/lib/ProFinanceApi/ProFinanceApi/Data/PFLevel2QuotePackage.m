#import "PFLevel2QuotePackage.h"

#import "PFSymbol.h"
#import "PFLevel2Quote.h"

#import "PFField.h"
#import "PFMessage.h"

@interface PFLevel2QuotePackage ()

@property ( nonatomic, strong ) NSMutableSet* bidQuotes;
@property ( nonatomic, strong ) NSMutableSet* askQuotes;

@end

@implementation PFLevel2QuotePackage

@synthesize symbol;

@synthesize bidQuotes;
@synthesize askQuotes;

-(void)dealloc
{
   [ self.bidQuotes makeObjectsPerformSelector: @selector(disconnectFromPackage) ];
   [ self.askQuotes makeObjectsPerformSelector: @selector(disconnectFromPackage) ];
   
}

-(NSArray*)sortedBidQuotes
{
   return [ [ self.bidQuotes allObjects ] sortedArrayUsingSelector: @selector(compare:) ];
}

-(NSArray*)sortedAskQuotes
{
   return [ [ self.askQuotes allObjects ] sortedArrayUsingSelector: @selector(compare:) ];
}

-(id)init
{
   self = [ super init ];
   if ( self )
   {
      self.bidQuotes = [ NSMutableSet new ];
      self.askQuotes = [ NSMutableSet new ];
   }
   return self;
}

-(void)updateQuote:( id< PFLevel2Quote > )quote_
{
   NSMutableSet* quotes_ = quote_.side == PFLevel2QuoteSideBid
      ? self.bidQuotes
      : self.askQuotes;

   [ quotes_ removeObject: quote_ ];
   
   BOOL should_remove_ = quote_.isClosed || quote_.realPrice == 0.0 || quote_.size == 0.0;
   if ( !should_remove_ )
   {
      [ quote_ connectToPackage: self ];
      [ quotes_ addObject: quote_ ];
   }
}

-(void)connectToSymbol:( PFSymbol* )symbol_
{
   self.symbol = symbol_;
   symbol_.level2Quotes = self;
}

-(void)didUpdateWithFieldOwner:( PFFieldOwner* )field_owner_
{
   NSArray* quote_groups_ = [ field_owner_ groupFieldsWithId: PFGroupPrice ];

   for ( PFGroupField* quote_group_ in quote_groups_ )
   {
      PFLevel2Quote* quote_ = [ PFLevel2Quote objectWithFieldOwner: quote_group_.fieldOwner ];
      quote_.price = quote_.realPrice;
      [ self updateQuote: quote_ ];
   }
}

-(NSUInteger)count
{
   return [ self.bidQuotes count ] + [ self.askQuotes count ];
}

@end
