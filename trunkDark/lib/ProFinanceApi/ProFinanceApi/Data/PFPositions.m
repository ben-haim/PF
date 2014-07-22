#import "PFPositions.h"

#import "PFPosition.h"
#import "PFSymbols.h"

#import "PFMessage.h"
#import "PFField.h"

#import "PFOrderedDictionary+PFConstructors.h"

@interface PFPositions ()

@property ( nonatomic, strong ) PFMutableOrderedDictionary* positionById;
@property ( nonatomic, strong ) PFSymbols* symbols;

@end

@implementation PFPositions

@synthesize positionById;
@synthesize symbols;

-(id)init
{
   self = [ super init ];
   if ( self )
   {
      self.positionById = [ PFMutableOrderedDictionary new ];
   }
   return self;
}

-(NSArray*)positions
{
   return self.positionById.array;
}

-(PFPosition*)positionWithId:( PFInteger )position_id_
{
   return [ self.positionById objectForKey: @(position_id_) ];
}

-(PFPosition*)positionWithOpenOrderId:( PFInteger )order_id_
{
   for ( PFPosition* position_ in self.positions )
   {
      if ( position_.orderId == order_id_ )
         return position_;
   }
   
   return nil;
}

-(void)removePosition:( PFPosition* )position_
             delegate:( id< PFPositionsDelegate > )delegate_
{
   [ self.positionById removeObjectForKey: @(position_.positionId) ];
   [ delegate_ openPositions: self didRemovePosition: position_ ];
}

-(PFPosition*)positionWithMessageMessage:( PFMessage* )message_
{
   PFInteger position_id_ = [ (PFIntegerField*)[ message_ fieldWithId: PFFieldPositionId ] integerValue ];

   PFPosition* position_ = [ self positionWithId: position_id_ ];
   if ( !position_ )
   {
      return [ PFPosition objectWithFieldOwner: message_ ];
   }

   [ position_ readFromFieldOwner: message_ ];
   
   return position_;
}

-(PFPosition*)updatePositionWithMessage:( PFMessage* )message_
                               delegate:( id< PFPositionsDelegate > )delegate_
{
   PFPosition* position_ = [ self positionWithMessageMessage: message_ ];
   [ self updatePosition: position_ delegate: delegate_ ];
   return position_;
}

-(void)updatePosition:( PFPosition* )position_
             delegate:( id< PFPositionsDelegate > )delegate_
{
   BOOL inconnected_ = self.symbols && [ self.symbols addSymbolConnection: position_ ] == nil;

   if ( position_.amount == 0.0 )
   {
      [ self removePosition: position_ delegate: delegate_ ];
      return;
   }

   if ( inconnected_ )
   {
      NSLog( @"Could not connect position: %@", position_ );
      return;
   }

   BOOL is_new_ = [ self positionWithId: position_.positionId ] == nil;
   [ self.positionById setObject: position_ forKey: @(position_.positionId) ];

   if ( is_new_ )
   {
      [ delegate_ openPositions: self didAddPosition: position_ ];
   }
   else
   {
      [ delegate_ openPositions: self didUpdatePosition: position_ ];
   }
}

-(void)connectToSymbols:( PFSymbols* )symbols_
{
   NSArray* connected_ = [ symbols_ addSymbolConnections: self.positionById.array ];
   if ( [ connected_ count ] != [ self.positionById count ] )
   {
      self.positionById = [ PFMutableOrderedDictionary dictionaryWithPositions: connected_ ];
   }

   self.symbols = symbols_;
}

@end
