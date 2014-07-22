
#import <Foundation/Foundation.h>
#import "../Controls/Chart/ChartStorage.h"
#import "../Controls/Trading/TradeProgress.h"
#import "ServerInfo.h"
#import "ServerConnection.h"
#import "DemoRegistration.h"
#import "ClientSettings.h"

#define MARGIN_DONT_USE 0
#define MARGIN_USE_ALL 1
#define MARGIN_USE_PROFIT 2
#define MARGIN_USE_LOSS 3

typedef enum
{
    OPEN_TRADE_VIEW_DEPOSIT_CUR,
    OPEN_TRADE_VIEW_POINTS,
    OPEN_TRADE_VIEW_AGR,
    
    OPEN_TRADE_VIEW_TOTAL
}OpenTradesViewType;

@class Conversion;

@protocol PFAccount;

@interface ParamsStorage : NSObject  
{
	NSMutableArray *Servers;
	NSString *ContactsURL;
	ServerConnection *serverConn;
	NSMutableSet *ExtSymbols;
	NSMutableDictionary *Symbols;
	NSMutableArray *SymGroups;
	NSMutableArray *mailItems;
	NSMutableDictionary *Prices;
	
	NSMutableArray *FavSymbols;
	ChartStorage *charts;
	TradeProgress *trade_progress;
	NSString* login;
	NSString* password;
	NSString* selected_server;
	NSTimer *timer;
	////
	double Credit;
	double Margin;	
	double SumSwap;
	double SumSwapOrig;
	double SumProfit;
	double SumProfits;
	double SumLosses;
	int Margin_Mode;
	/////
	NSDate *history_start;
	NSDate *history_finish;
	
	////
	NSNumberFormatter *volumeFormatter;
	NSNumberFormatter *profitFormatter;
	NSNumberFormatter *priceFormatter; 
	
	NSString *chartInterval;
	NSString* currentChartInterval;
	NSString* chartDefSettings;
    NSString* chartSettings;
    
	ClientSettings *clientSettings;
	
	NSMutableArray *accounts;
	BOOL isOnBackupServer;
	
	// Localized Grid Strings
	/*NSString *MinString;
	NSString *MaxString;
	NSString *AskString;
	NSString *BidString;
	
	NSString *OrderString;
	NSString *TypeString;
	NSString *VolumeString;
	NSString *ProfitString;*/
    NSString *userCurrency;
    NSInteger userDecimals;
    
    BOOL isUsingCachedPath;
    NSString *serverResult;
    NSString *tokkenResult;
    
    OpenTradesViewType openTradesView;
}

@property( nonatomic, retain) NSMutableArray *Servers;
@property( nonatomic, assign) ServerConnection *serverConn;
@property( nonatomic, retain) NSMutableSet *ExtSymbols;
@property( nonatomic, retain) NSMutableDictionary *Symbols;
@property( nonatomic, retain) NSMutableArray *SymGroups;
@property( nonatomic, retain) NSMutableArray *mailItems;
@property( nonatomic, retain) NSMutableDictionary *Prices;
@property( nonatomic, retain) NSMutableArray *FavSymbols;
@property ( nonatomic, strong ) NSMutableArray* trades;
@property( nonatomic, retain) ChartStorage *charts;
@property( nonatomic, retain) TradeProgress *trade_progress;
@property(assign) NSString* currentChartInterval;
@property( nonatomic, retain) NSMutableArray *accounts;

@property(nonatomic, retain) NSString *chartInterval;
@property(assign) int Margin_Mode;
@property(assign) double Credit;
@property(assign, readonly) double Balance;
@property(assign) double Margin;
@property(assign) double SumSwap;
@property(assign) double SumSwapOrig;
@property(assign) double SumProfit;
@property(assign) double SumProfits;
@property(assign) double SumLosses;
@property(nonatomic, retain) NSString* login;
@property(nonatomic, retain) NSString* password;
@property(nonatomic, retain) NSString* selected_server;
@property(assign) NSString* ContactsURL;

/*@property(assign) NSString* MinString;
@property(assign) NSString* MaxString;
@property(assign) NSString* AskString;
@property(assign) NSString* BidString;
@property(assign) NSString* OrderString;
@property(assign) NSString* TypeString;
@property(assign) NSString* VolumeString;
@property(assign) NSString* ProfitString;*/

@property( nonatomic, retain) NSNumberFormatter *profitFormatter;
@property( nonatomic, retain) NSNumberFormatter *volumeFormatter;
@property( nonatomic, retain) NSNumberFormatter *priceFormatter;

@property( nonatomic, retain) NSDate *history_start;
@property( nonatomic, retain) NSDate *history_finish;
@property( nonatomic, assign) BOOL isOnBackupServer;

@property(nonatomic, retain) NSString *userCurrency;
@property(nonatomic, assign) NSInteger userDecimals;

@property( nonatomic, retain) NSString* chartDefSettings;
@property( nonatomic, retain) NSString* chartSettings;

@property(assign) ClientSettings *clientSettings;

@property(nonatomic, assign) BOOL isUsingCachedPath;
@property(nonatomic, retain) NSString *serverResult;
@property(nonatomic, retain) NSString *tokkenResult;

@property(nonatomic, assign) OpenTradesViewType openTradesView;

@property ( nonatomic, strong, readonly ) id< PFAccount > account;

-(void)SaveSettings;
- (NSString*)getServerResult;
- (NSString*)getTokkenrResult;
- (void)clearServerResults;
- (void)saveFavorites;
- (void)loadFavorites;
-(NSString*)getServerURL:(NSString*)alias;
-(NSString*)getBackupServerURL:(NSString*)alias;
- (void) ReleaseMailItems;
-(Conversion*)Pair2Cur:(NSString*)pair ForCur:(NSString*)cur isFirstConversion:(BOOL)firstConv;
-(Conversion*)Pair2Cur:(NSString *)pair ForCur:(NSString *)cur SymbolNameLength:(int)len isFirstConversion:(BOOL)firstConv;
-(Conversion*)GetConversion:(NSString*)cur1 AndC2:(NSString*)cur2;
-(Conversion*)GetConversion:(NSString*)cur1 AndC2:(NSString*)cur2 SymbolNameLength:(int)len;
-(Conversion*)GetConversionInternal:(NSString*)cur1 AndC2:(NSString*)cur2 SymbolNameLength:(int)len;
-(SymbolInfo*)getSymbolIgnorePrefix:(NSString *)symbolName prefixLength:(int)len;
-(SymbolInfo*) getContainedSymbol:(NSString *)symbolName;
//- (NSMutableArray *)GetGroupSymbols:(int)GroupIndex;
- (void) ProcessMargin:(NSArray *)margin;
-(NSString*) formatPrice:(double)value forSymbol:(NSString*)symbol;
-(NSString*) formatVolume:(double)value; 
-(NSString*) formatProfit:(double)value;
-(NSString*)formatPercentage:(double)value;
-(BOOL)validateFloat:(NSString *)val;
-(void)SplitPrice:(NSString *)Price P1:(NSString**)p1 P2:(NSString**)p2 P3:(NSString**)p3 forSymbol:(NSString*)symbol;

-(NSMutableArray*)getSavedAccounts;
-(void)saveAccounts:(NSMutableArray*)mutArray;
-(void)saveAccount;
-(BOOL)isServerValid:(NSString*)server;

@end

@protocol PFInstruments;
@protocol PFQuote;
@protocol PFPositions;
@protocol PFPosition;
@protocol PFAccounts;
@protocol PFAccount;
@protocol PFOrders;

@interface ParamsStorage (PF)

-(void)addInstruments:( id< PFInstruments > )instruments_;
-(void)addQuote:( id< PFQuote > )quote_;
-(void)addPositions:( id< PFPositions > )positions_;
-(void)addOrders:( id< PFOrders > )orders_;
-(void)addAccounts:( id< PFAccounts > )accounts_;

-(void)addOrder:( id< PFOrder > )order_;
-(void)removeOrder:( id< PFOrder > )order_;
-(void)updateOrder:( id< PFOrder > )order_;

-(void)addPosition:( id< PFPosition > )position_;
-(void)removePosition:( id< PFPosition > )position_;
-(void)updatePosition:( id< PFPosition > )position_;

@end

