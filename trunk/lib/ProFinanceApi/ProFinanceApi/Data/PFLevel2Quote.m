#import "PFLevel2Quote.h"

#import "PFSymbol.h"
#import "PFLevel2QuotePackage.h"

#import "PFMetaObject.h"
#import "PFField.h"

@interface PFLevel2Quote ()

@property ( nonatomic, weak ) id< PFLevel2QuotePackage > package;

@end

@implementation PFLevel2Quote

@synthesize price;
@synthesize realPrice;
@synthesize side;
@synthesize size;
@synthesize source;
@synthesize quoteId;
@synthesize date;
@synthesize dayTradeVolume;
@synthesize isClosed;

@synthesize package;

+(PFMetaObject*)metaObject
{
   return [ PFMetaObject metaObjectWithFields:
           [ NSArray arrayWithObjects: [ PFMetaObjectField fieldWithId: PFFieldPrice name: @"realPrice" ]
            , [ PFMetaObjectField fieldWithId: PFFieldSide name: @"side" ]
            , [ PFMetaObjectField fieldWithId: PFFieldSize name: @"size" ]
            , [ PFMetaObjectField fieldWithId: PFFieldSource name: @"source" ]
            , [ PFMetaObjectField fieldWithId: PFFieldQuoteId name: @"quoteId" ]
            , [ PFMetaObjectField fieldWithId: PFFieldDate name: @"date" ]
            , [ PFMetaObjectField fieldWithId: PFFieldDayTradeVolume name: @"dayTradeVolume" ]
            , [ PFMetaObjectField fieldWithId: PFFieldIsClosed name: @"isClosed" ]
            , nil ] ];
}

-(id<PFSymbol>)symbol
{
   return self.package.symbol;
}

-(void)connectToSymbol:( PFSymbol* )symbol_
{
   [ symbol_.level2Quotes updateQuote: self ];
}

-(void)connectToPackage:( id< PFLevel2QuotePackage > )package_
{
   self.package = package_;
}

-(void)disconnectFromPackage
{
   self.package = nil;
}

-(NSComparisonResult)compare:( id< PFLevel2Quote > )quote_
{
   if ( self.realPrice == quote_.realPrice )
      return NSOrderedSame;

   if ( self.side == PFLevel2QuoteSideAsk )
   {
      return self.realPrice < quote_.realPrice ? NSOrderedAscending : NSOrderedDescending;
   }

   return self.realPrice > quote_.realPrice ? NSOrderedAscending : NSOrderedDescending;
}

-(NSUInteger)hash
{
   return [ self.quoteId hash ];
}

-(BOOL)isEqual:( id )other_
{
   if ( [ self class ] != [ other_ class ] )
      return NO;
   
   PFLevel2Quote* other_quote_ = ( PFLevel2Quote* )other_;
   return [ other_quote_.quoteId isEqual: self.quoteId ];
}

@end
