#import "../PFTypes.h"

#import "PFSymbolConnection.h"

#import "Detail/PFSymbolId.h"

#import <Foundation/Foundation.h>

@protocol PFLevel3Quote <PFSymbolId>

-(PFDouble)price;
-(PFDouble)size;
-(NSDate*)date;
-(NSString*)exchange;

-(NSString*)symbolName;

@end

@class PFSymbol;

@interface PFLevel3Quote : PFSymbolId< PFLevel3Quote, PFSymbolConnection >

@property ( nonatomic, assign ) PFDouble price;
@property ( nonatomic, assign ) PFDouble size;
@property ( nonatomic, strong ) NSDate* date;
@property ( nonatomic, strong ) NSString* exchange;

@property ( nonatomic, strong, readonly ) NSString* symbolName;

@end
