#import "../PFTypes.h"

#import "PFQuoteDependence.h"

#import <Foundation/Foundation.h>

@protocol PFSymbol;

@protocol PFWatchlist <NSObject>

-(NSArray*)symbols;
-(NSString*)watchlistId;

-(void)addSymbol:( id< PFSymbol > )symbol_;
-(void)removeSymbol:( id< PFSymbol > )symbol_;

-(void)removeAllSymbols;

-(BOOL)containsSymbol:( id< PFSymbol > )symbol_;

@end

@class PFSession;

@interface PFWatchlist : NSObject< PFWatchlist, PFQuoteDependence >

@property ( nonatomic, strong, readonly ) NSString* watchlistId;
@property ( nonatomic, strong, readonly ) NSArray* symbols;

+(id)watchlistWithId:( NSString* )watchlist_id_;

-(void)connectToSession:( PFSession* )session_;

@end

@protocol PFSymbol;

@protocol PFWatchlistDelegate <NSObject>

-(void)watchlist:( PFWatchlist* )watchlist_
    didAddSymbol:( id< PFSymbol > )symbol_;

-(void)watchlist:( PFWatchlist* )watchlist_
didRemoveSymbols:( NSArray* )symbols_;

@end
