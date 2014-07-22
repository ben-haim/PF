#import "../PFTypes.h"

#import <Foundation/Foundation.h>

@protocol PFPositions <NSObject>

-(NSArray*)positions;

@end

@class PFMessage;

@class PFPosition;
@class PFSymbols;

@protocol PFPositionsDelegate;

@interface PFPositions : NSObject< PFPositions >

@property ( nonatomic, strong, readonly ) NSArray* positions;

-(PFPosition*)updatePositionWithMessage:( PFMessage* )message_
                               delegate:( id< PFPositionsDelegate > )delegate_;

-(void)updatePosition:( PFPosition* )position_
             delegate:( id< PFPositionsDelegate > )delegate_;

-(void)removePosition:( PFPosition* )position_
             delegate:( id< PFPositionsDelegate > )delegate_;

-(PFPosition*)positionWithId:( PFInteger )position_id_;
-(PFPosition*)positionWithOpenOrderId:( PFInteger )order_id_;

-(void)connectToSymbols:( PFSymbols* )symbols_;

@end

@protocol PFPositionsDelegate <NSObject>

-(void)openPositions:( PFPositions* )positions_
   didUpdatePosition:( PFPosition* )position_;

-(void)openPositions:( PFPositions* )positions_
   didRemovePosition:( PFPosition* )position_;

-(void)openPositions:( PFPositions* )positions_
      didAddPosition:( PFPosition* )position_;

@end
