#import <Foundation/Foundation.h>

@interface SymbolGroup : NSObject 

@property( assign ) int MinSymbolIndex;
@property( assign ) int index;
@property( nonatomic, retain ) NSString *name;
@property( nonatomic, retain ) NSString *desc;
@property( assign ) int trade;
@property( nonatomic, retain, readonly ) NSArray *symbols;

@end

@protocol PFInstrumentGroup;

@interface SymbolGroup (PFInstrumentGroup)

+(id)groupWithInstrumentGroup:( id< PFInstrumentGroup > )instrument_group_;

@end
