#import "SymbolGroup.h"

#import "SymbolInfo.h"

#import <ProFinanceApi/ProFinanceApi.h>

@interface SymbolGroup ()

@property ( nonatomic, strong ) NSMutableArray* mutableSymbols;

@end

@implementation SymbolGroup

@synthesize index;
@synthesize name = _name;
@synthesize desc = _desc;
@synthesize trade;
@synthesize MinSymbolIndex;
@synthesize mutableSymbols = _mutableSymbols;

-(id)init
{
	self = [super init];
   if ( self )
   {
      self.mutableSymbols = [ NSMutableArray array ];
   }
	return self;
	
}

- (void)dealloc 
{
   [_name release];
   [_desc release];
   [_mutableSymbols release];		
	[super dealloc];
}

-(NSArray*)symbols
{
   return self.mutableSymbols;
}

@end

@implementation SymbolGroup (PFInstrumentGroup)

+(id)groupWithInstrumentGroup:( id< PFInstrumentGroup > )instrument_group_
{
   SymbolGroup* group_ = [ self new ];

   group_.index = instrument_group_.groupId;
   group_.name = instrument_group_.name;
   group_.desc = instrument_group_.name;
   group_.trade = 1;

   for ( id< PFSymbol > pf_symbol_ in instrument_group_.symbols )
   {
      SymbolInfo* info_ = [ SymbolInfo symbolInfoWithSymbol: pf_symbol_ ];
      [ group_.mutableSymbols addObject: info_ ];
   }

   return [ group_ autorelease ];
}

@end
