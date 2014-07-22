#import "../PFTypes.h"

#import <Foundation/Foundation.h>

@protocol PFInstrumentGroup <NSObject>

-(PFInteger)groupId;
-(PFInteger)superId;
-(NSString*)name;
-(NSArray*)symbols;

-(void)addSymbols:( NSArray* )symbols_;
-(void)removeSymbols:( NSArray* )symbols_;

@end

@class PFInstrument;

@interface PFInstrumentGroup : NSObject< PFInstrumentGroup >

@property ( nonatomic, assign, readonly ) PFInteger groupId;
@property ( nonatomic, assign ) PFInteger superId;
@property ( nonatomic, strong ) NSString* name;
@property ( nonatomic, strong, readonly ) NSArray* symbols;

+(id)groupWithId:( PFInteger )group_id_;

-(void)addSymbols:( NSArray* )symbols_;
-(void)removeSymbols:( NSArray* )symbols_;

@end
