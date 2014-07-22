

#import "HLOCDataSource.h"
#import "ArrayMath.h"
#import "Utils.h"

@implementation HLOCDataSource
@synthesize RangeType, symbol_digits, last_bid, last_ask;

- (id)initWithRangeType:(uint)_RangeType AndDigits:(uint)_sym_digits
{
    self  = [super init];
    if(self  == nil)
        return self;
    self.symbol_digits  = _sym_digits;
    self.RangeType      = _RangeType;
    return self;
}

//returns true if the new bar was added
-(bool)MergePriceWithBid:(double)bid AndAsk:(double)ask AndVolume:(int)volume AtTime:(NSDate*)timeValue
{
    
    last_ask = ask;
    last_bid = bid;
    BOOL AddNewBar = YES;
    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar] ;
    NSDateComponents *newBar = [gregorian components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:timeValue];
    [gregorian release];
    
    if(!(RangeType == 1 && [newBar second]==0))
    {
        int mins = ((int)[newBar hour]*60) + (int)[newBar minute];
        mins %= RangeType;
        
        if(mins == 0)
            AddNewBar = YES;
    }
    
    
    
    
    NSTimeInterval t1 = [timeValue timeIntervalSince1970];
    NSTimeInterval t2 = 0;//[[NSDate alloc] initWithTimeIntervalSince1970:0];
    ArrayMath* timeStamps = [self GetVector:@"timeStamps"];
    
    int length = [timeStamps getLength];
    if(length>0)
        t2 = [timeStamps getData][length-1];
    
    
    if([self isMinutePeriod])
    {
        NSCalendar *gregorian1 = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar] ;
        NSDateComponents *lastOldBar = [gregorian1 components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:[NSDate dateWithTimeIntervalSince1970:t2]];
        [gregorian1 release];
        if(lastOldBar.minute == newBar.minute && AddNewBar)
            AddNewBar = NO;
        
    }
    
    
    t2+=RangeType*60;
    if(t1 < t2 && AddNewBar)
        AddNewBar = false;
    
    if(AddNewBar)
    {
        [[self GetVector:@"openData"] addElement:last_bid];
        [[self GetVector:@"highData"] addElement:last_bid];
        [[self GetVector:@"lowData"] addElement:last_bid];
        [[self GetVector:@"closeData"] addElement:last_bid];
        [[self GetVector:@"volData"] addElement:volume];
        timeValue = [self RoundDate:timeValue ForRange:RangeType];
        [timeStamps addElement:[timeValue timeIntervalSince1970]];
        
        [[self GetVector:@"hl2Data"] addElement:last_bid];
        [[self GetVector:@"hlc3Data"] addElement:last_bid];
        [[self GetVector:@"hlcc4Data"] addElement:last_bid];
    }
    else
    {
        ArrayMath* close_data   = [self GetVector:@"closeData"];
        ArrayMath* high_data    = [self GetVector:@"highData"];
        ArrayMath* low_data     = [self GetVector:@"lowData"];
        ArrayMath* vol_data     = [self GetVector:@"volData"];
        ArrayMath* hl2_data     = [self GetVector:@"hl2Data"];
        ArrayMath* hlc3_data    = [self GetVector:@"hlc3Data"];
        ArrayMath* hlcc4_data   = [self GetVector:@"hlcc4Data"];
        
        double lastHigh     = [high_data getData][length-1];
        double lastLow      = [low_data getData][length-1];
        double lastVol      = [vol_data getData][length-1];
        
        [close_data getData][length-1] = last_bid;
        [high_data getData][length-1]  = MAX(lastHigh, last_bid);
        [low_data getData][length-1]   = MIN(lastLow, last_bid);
        [vol_data getData][length-1]   = lastVol+volume;
        
        
        double high     = [high_data getData][length-1];
        double low      = [low_data getData][length-1];
        double close    = [close_data getData][length-1];
        
        
        double hl2      = (high + low) / 2.0;
        double hlc3     = (high + low + close) / 3.0;
        double hlcc4    = (high + low + 2*close) / 4.0;
        [hl2_data getData][length-1]    = hl2;
        [hlc3_data getData][length-1]   = hlc3;
        [hlcc4_data getData][length-1]  = hlcc4;
    }
    return AddNewBar;
}

-(NSDate*)RoundDate:(NSDate*)dtDate ForRange:(uint)_RangeType
{
    int time_temp = [dtDate timeIntervalSince1970];

    time_temp = _RangeType*60*(int)(time_temp/(_RangeType*60));    
    NSDate* res = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)time_temp] ;
    return res;
}

-(NSString*)getIntervalName
{
    switch (RangeType) 
    {
        case 1:         return @"M1"; 
        case 5:         return @"M5"; 
        case 15:        return @"M15";
        case 30:        return @"M30";
        case 60:        return @"H1"; 
        case 240:       return @"H4"; 
        case 1440:      return @"D1"; 
        case 10080:     return @"W1"; 
        case 43200:     return @"MN1";
    }
    return @"";
}
-(BOOL)isMinutePeriod
{
    return
    RangeType==1||
    RangeType==5||
    RangeType==15||
    RangeType==30;
}
@end
