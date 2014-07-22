#import "../PFTypes.h"

#import <Foundation/Foundation.h>

@protocol PFInstruments <NSObject>

-(NSArray*)instruments;
-(NSArray*)groups;

@end

@class PFInstrument;
@class PFInstrumentGroup;
@class PFMessage;

@interface PFInstruments : NSObject< PFInstruments >

@property ( nonatomic, strong, readonly ) NSArray* instruments;
@property ( nonatomic, strong, readonly ) NSArray* groups;
@property ( nonatomic, strong, readonly ) NSArray* instrumentIds;

-(void)updateRouteWithMessage:( PFMessage* )message_;
-(void)addInstrument:( PFInstrument* )instrument_;
-(void)addInstrumentGroup:( PFInstrumentGroup* )group_;

-(PFInstrument*)instrumentWithId:( PFInteger )instrument_id_;

-(PFInstrumentGroup*)writeGroupWithId:( PFInteger )group_id_;

@end
