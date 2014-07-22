#import "PFInstrumentGroup.h"

#import "PFInstrument.h"
#import "PFSymbol.h"

@interface PFInstrumentGroup ()

@property ( nonatomic, assign ) PFInteger groupId;
@property ( nonatomic, strong ) NSMutableArray* mutableSymbols;

@end

@implementation PFInstrumentGroup

@synthesize groupId;
@synthesize superId;
@synthesize name = _name;
@synthesize mutableSymbols;

-(id)initWithId:( PFInteger )group_id_
{
   self = [ super init ];
   if ( self )
   {
      self.groupId = group_id_;
      self.mutableSymbols = [ NSMutableArray new ];
   }
   return self;
}

+(id)groupWithId:( PFInteger )group_id_
{
   return [ [ self alloc ] initWithId: group_id_ ];
}

-(NSArray*)symbols
{
   return self.mutableSymbols;
}

-(void)addSymbols:( NSArray* )symbols_
{
   if ( symbols_ )
   {
      [ self.mutableSymbols addObjectsFromArray: symbols_ ];
   }
}

-(void)removeSymbols:( NSArray* )symbols_
{
   if ( symbols_ )
   {
      [ self.mutableSymbols removeObjectsInArray: symbols_ ];
   }
}

-(NSString*)description
{
   return [ NSString stringWithFormat: @"%@: {%@}"
           , self.name
           , [ self.symbols componentsJoinedByString: @", " ] ];
}

@end
