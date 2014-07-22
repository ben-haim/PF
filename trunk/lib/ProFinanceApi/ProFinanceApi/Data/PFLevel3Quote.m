#import "PFLevel3Quote.h"

#import "PFSymbol.h"

#import "PFMetaObject.h"
#import "PFField.h"

@interface PFLevel3Quote ()

@property ( nonatomic, weak ) PFSymbol* symbol;

@end

@implementation PFLevel3Quote

@synthesize price;
@synthesize size;
@synthesize date;
@synthesize exchange;
@synthesize symbol;

+(PFMetaObject*)metaObject
{
   return [ PFMetaObject metaObjectWithFields:
           [ NSArray arrayWithObjects:  [ PFMetaObjectField fieldWithId: PFFieldPrice name: @"price" ]
            , [ PFMetaObjectField fieldWithId: PFFieldSize name: @"size" ]            
            , [ PFMetaObjectField fieldWithId: PFFieldExchange name: @"exchange" ]
            , [ PFMetaObjectField fieldWithId: PFFieldDate name: @"date" ]
            , nil ] ];
}

-(NSString*)symbolName
{
   return self.symbol.name;
}

-(void)connectToSymbol:( PFSymbol* )symbol_
{
   self.symbol = symbol_;
   symbol_.tradeQuote = self;
}

@end
