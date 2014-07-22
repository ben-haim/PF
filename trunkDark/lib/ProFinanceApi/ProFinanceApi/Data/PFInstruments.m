#import "PFInstruments.h"

#import "PFInstrument.h"
#import "PFInstrumentGroup.h"
#import "PFRoutes.h"
#import "PFSymbol.h"

@interface PFInstruments ()

@property ( nonatomic, strong ) NSMutableDictionary* instrumentsById;
@property ( nonatomic, strong ) NSMutableDictionary* groupsById;
@property ( nonatomic, strong ) PFRoutes* routes;

@end

@implementation PFInstruments

@synthesize instrumentsById;
@synthesize groupsById;
@synthesize routes;

-(void)dealloc
{
   NSEnumerator* instrument_enumerator_ = [ self.instrumentsById objectEnumerator ];
   PFInstrument* instrument_ = nil;

   while ( ( instrument_ = [ instrument_enumerator_ nextObject ] ) )
   {
      [ instrument_ disconnectFromGroup ];
   }
}

-(id)init
{
   self = [ super init ];
   if ( self )
   {
      self.instrumentsById = [ NSMutableDictionary new ];
      self.groupsById = [ NSMutableDictionary new ];
      self.routes = [ PFRoutes new ];
   }
   return self;
}

-(NSArray*)instruments
{
   return [ self.instrumentsById allValues ];
}

-(NSArray*)groups
{
   return [ self.groupsById allValues ];
}

-(NSArray*)instrumentIds
{
   return [ self.instrumentsById allKeys ];
}

-(PFInstrument*)instrumentWithId:( PFInteger )instrument_id_
{
   return (self.instrumentsById)[@(instrument_id_)];
}

-(void)updateRouteWithMessage:( PFMessage* )message_
{
   [ self.routes updateRouteWithMessage: message_ ];
}

-(void)addInstrument:( PFInstrument* )instrument_
{
   PFInstrument* found_instrument_ = (self.instrumentsById)[@(instrument_.instrumentId)];
   (self.instrumentsById)[@(instrument_.instrumentId)] = instrument_;

   if ( found_instrument_ )
   {
      [ instrument_ synchronizeWithInstrument: found_instrument_ ];
   }
   else
   {
      instrument_.routes = [ self.routes writeRoutesWithNames: instrument_.routeNames ];

      PFInstrumentGroup* group_ = [ self writeGroupWithId: instrument_.groupId ];
      [ instrument_ connectToGroup: group_ ];

      if ( [ instrument_.symbols count ] > 0 )
      {
         [ group_ addSymbols: instrument_.symbols ];
      }
   }
}

-(void)addInstrumentGroup:( PFInstrumentGroup* )group_
{
   PFInstrumentGroup* existent_group_ = [ self writeGroupWithId: group_.groupId ];
   //Just update name
   existent_group_.name = group_.name;
}

-(PFInstrumentGroup*)writeGroupWithId:( PFInteger )group_id_
{
   PFInstrumentGroup* group_ = (self.groupsById)[@(group_id_)];
   if ( !group_ )
   {
      group_ = [ PFInstrumentGroup groupWithId: group_id_ ];
      (self.groupsById)[@(group_id_)] = group_;
   }
   return group_;
}

-(NSString*)description
{
   return [ self.groups componentsJoinedByString: @"\n" ];
}
@end
