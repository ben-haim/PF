
#import "AggrOpenPosWatch.h"
#import "HeaderGridCell.h"
#import "OpenPosWatch.h"
#import "AggrOpenPosGridCell.h"
#import "AggrPendingPosGridCell.h"
#import "AggragateTradeRecord.h"

@implementation AggrOpenPosWatch

@synthesize gridCtl;
@synthesize parent;
@synthesize dicOpen;
@synthesize dicPending;
@synthesize openOrderKeys;
@synthesize pendingOrderKeys;

- (id)init 
{
    self = [super init];
    if (self) 
    {
        
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

#pragma mark - Aggragate view control

- (void)rebild:(BOOL)keepScroll
{
    CGPoint old_contentOffset = [gridCtl.grid_view contentOffset]; 
	
	[gridCtl.grid_view ClearCells];	
    
    if(parent.storage==nil)
		return;
	
	BOOL firstHeader = YES;
	
	HeaderGridCell *gs_sep;
    
	int instantCount = [parent.open_items count];
    int pendingCount = [parent.pending_items count];
    
    dicOpen = [NSMutableDictionary new];
    dicPending = [NSMutableDictionary new];
    
    openOrderKeys = [NSMutableArray new];
    pendingOrderKeys = [NSMutableArray new];
    
    NSArray *open_items = parent.open_items;
	NSArray *pending_items = parent.pending_items;
    
 	if (instantCount > 0)
	{
		gs_sep = [[HeaderGridCell alloc] initWithText:NSLocalizedString(@"HEADER_OPEN_POSITIONS", nil) isFirst:YES];
		gs_sep.isGroupRow = YES;
		//gs_sep.Height = 50;
		[gridCtl.grid_view AddCell:gs_sep];
		[gs_sep autorelease];
		firstHeader = NO;
	}
	
	int sym_index = 0;
	int sym_pending_index = 0;
	
	for(int i=0; i<instantCount; i++)
	{	
        TradeRecord *tr = [open_items objectAtIndex:i];
        AggragateTradeRecord *aggrTr;
    
        if (![dicOpen objectForKey:tr.symbol])
        {
            aggrTr = [AggragateTradeRecord new];
            aggrTr.symbol = tr.symbol;
            aggrTr.type = AGGREGATE_ORDER_TYPE_INSTANT;
            [dicOpen setObject:aggrTr forKey:tr.symbol];//add aggregate trade record
            [openOrderKeys addObject:tr.symbol];//add symbol to the index array
            
            SymbolInfo *si = [parent.storage.Symbols objectForKey:tr.symbol];
            aggrTr.conv1 = si.Conv1;
            aggrTr.conv2 = si.Conv2;
            aggrTr.digits = (si == nil) ? 5 : si.Digits;
            aggrTr.profitMode = si.ProfitMode;
            
            AggrOpenPosGridCell *gs = [AggrOpenPosGridCell new];
            gs.firstInGroup = ( i == 0 );
            gs.lastInGroup = ( i == [open_items count]-1 && [pending_items count] != 0 );
            gs.watch = self;
            gs.storage = parent.storage;
            gs.group_index = 0;
            gs.symbol_index = sym_index;//i;
			sym_index++;
            
            [gridCtl.grid_view AddCell:gs];//add aggregate trade cell
            [gs autorelease];
        }
        else
        {
            aggrTr = [dicOpen objectForKey:tr.symbol];
        }
        aggrTr.storage += tr.storage;
        aggrTr.commission += tr.commission;
        
		if (tr.cmd % 2 == 0) //buy
        {
            aggrTr.buyOrdersCount++;
            aggrTr.volBuy += tr.volume;
            [aggrTr putOpenBuyPrice:tr.open_price withVolume:tr.volume];
        }        
        else //sell
        {
            aggrTr.sellOrdersCount++;
            aggrTr.volSell += tr.volume;
            [aggrTr putOpenSellPrice:tr.open_price withVolume:tr.volume];
        }
	}
	
    for (NSString *aggrKey in dicOpen)
    {
        [[dicOpen objectForKey:aggrKey] calculateWeightedAverage];
        
        [[dicOpen objectForKey:aggrKey] updateProfit:parent.storage];
    }
    
    if (pendingCount > 0)
    {
        gs_sep = [[HeaderGridCell alloc] initWithText:NSLocalizedString(@"HEADER_PENDING_ORDERS", nil)];
        gs_sep.isGroupRow = YES;
        //gs_sep.Height = 50;
        [gridCtl.grid_view AddCell:gs_sep];
        [gs_sep autorelease];
    }
    
    for(int i=0; i< pendingCount; i++)
    {	
        TradeRecord *tr = [pending_items objectAtIndex:i];
        AggragateTradeRecord *aggrTr;
        
        if (![dicPending objectForKey:tr.symbol])
        {
            aggrTr = [AggragateTradeRecord new];
            aggrTr.symbol = tr.symbol;
            aggrTr.type = AGGREGATE_ORDER_TYPE_PENDING;
            [dicPending setObject:aggrTr forKey:tr.symbol];//add aggregate trade record
            [pendingOrderKeys addObject:tr.symbol];//add symbol to the index array
            
            SymbolInfo *si = [parent.storage.Symbols objectForKey:tr.symbol];
            aggrTr.conv1 = si.Conv1;
            aggrTr.conv2 = si.Conv2;
            aggrTr.digits = (si == nil) ? 5 : si.Digits;;
            aggrTr.profitMode = si.ProfitMode;
            
            AggrPendingPosGridCell *gs = [AggrPendingPosGridCell new];
            gs.firstInGroup = ( i == 0 );
            gs.lastInGroup = ( i == [open_items count]-1 && [pending_items count] != 0 );
            gs.watch = self;
            gs.storage = parent.storage;
            gs.group_index = 0;
            gs.symbol_index = sym_pending_index; //i;
			sym_pending_index++;
            
            [gridCtl.grid_view AddCell:gs];//add aggregate trade cell
            [gs autorelease];
        }
        else
        {
            aggrTr = [dicPending objectForKey:tr.symbol];
        }
        aggrTr.storage += tr.storage;
        aggrTr.commission += tr.commission;
        
		if (tr.cmd % 2 == 0) //buy
        {
            aggrTr.buyOrdersCount++;
            aggrTr.volBuy += tr.volume;
        }        
        else //sell
        {
            aggrTr.sellOrdersCount++;
            aggrTr.volSell += tr.volume;
        }

    }
	
	[gridCtl.grid_view RecalcScroll:keepScroll]; 
	
	if(keepScroll)
		[gridCtl.grid_view setContentOffset:old_contentOffset];
	
	[gridCtl.grid_view setNeedsDisplay];    
}

- (BOOL)updateProfits:(BOOL)forceChanged
{
	NSEnumerator *e = [openOrderKeys objectEnumerator];
	id object;
	while (object = [e nextObject])
	{
		AggragateTradeRecord *aggTR = [dicOpen objectForKey:object];
		if(aggTR==nil)
			return NO;
		[aggTR updateProfit:parent.storage];
		//NSLog(@"%f", aggTR.profit);
	}
	
	[self updateSummaryData];
    return true;
}

- (void)updateSummaryData
{
	ParamsStorage *storage = parent.storage;
    storage.SumSwap = 0.0;
	storage.SumSwapOrig = 0.0;
	storage.SumProfit = 0.0;
	storage.SumProfits = 0.0;
	storage.SumLosses = 0.0;
	NSEnumerator *enumerator = [openOrderKeys objectEnumerator];
	id value;	
	while ((value = [enumerator nextObject])) 
	{
		AggragateTradeRecord *atr = [dicOpen objectForKey:value];
		if(atr==nil)
			return;
		storage.SumProfit += (atr.profit + atr.storage + atr.commission);
		storage.SumSwap += round(atr.storage*100.0)/100.0;
		storage.SumSwapOrig += atr.storage;
		
		
		
		if (atr.profit > 0) 
			storage.SumProfits += (atr.profit + atr.storage + atr.commission);
		else 
			storage.SumLosses += (atr.profit + atr.storage + atr.commission);
	}
		
	[parent updateBalanceValues];
}
@end
