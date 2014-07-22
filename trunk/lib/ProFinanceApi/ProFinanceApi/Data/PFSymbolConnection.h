#import "PFQuoteDependence.h"

#import "Detail/PFSymbolId.h"

#import <Foundation/Foundation.h>

@class PFSymbol;

@protocol PFSymbolConnection <PFSymbolId, PFQuoteDependence>

-(void)connectToSymbol:( PFSymbol* )symbol_;

@end
