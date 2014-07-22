#import "PFQuoteFilesReader.h"

#import "PFQuoteFile.h"
#import "PFQuoteFileLoader.h"

#import "PFQuotesConverter.h"

#import "NSError+ProFinanceApi.h"
#import "NSBundle+PFResources.h"

#import "PFQuoteInfo.h"
#import "PFServerInfo.h"


@interface PFQuoteFilesReader ()< PFQuoteFileLoaderDelegate >

@property ( nonatomic, strong ) PFServerInfo* serverInfo;
@property ( nonatomic, strong ) NSArray* files;
@property ( nonatomic, strong ) id lastBar;
@property ( nonatomic, strong ) NSDate* fromDate;
@property ( nonatomic, assign ) PFChartPeriodType basePeriod;
@property ( nonatomic, assign ) PFChartPeriodType destinationPeriod;
@property ( nonatomic, assign ) PFInteger timeZoneOffset;
@property ( strong ) NSArray* loaders;
@property ( strong ) NSMutableArray* completedLoaders;
@property ( nonatomic, weak ) id< PFQuoteFilesReaderDelegate > delegate;

@end

@implementation PFQuoteFilesReader

@synthesize serverInfo;
@synthesize files;
@synthesize lastBar;
@synthesize fromDate;
@synthesize basePeriod;
@synthesize destinationPeriod;
@synthesize timeZoneOffset;
@synthesize loaders;
@synthesize completedLoaders;
@synthesize delegate;

-(void)disconnectLoaders:( NSArray* )loaders_
                   error:( NSError* )error_
{
   [ loaders_ makeObjectsPerformSelector: @selector( disconnect ) ];
   [ self.delegate reader: self didFailWithError: error_ ];
}

-(void)startWithDelegate:( id< PFQuoteFilesReaderDelegate > )delegate_
{
   if ( [ self.files count ] == 0 )
   {
      [ delegate_ reader: self didLoadQuotes: self.lastBar ? [ NSArray arrayWithObject: self.lastBar ] : nil ];
      return;
   }

   NSAssert( !self.loaders, @"already started" );

   NSMutableArray* loaders_ = [ NSMutableArray arrayWithCapacity: [ self.files count ] ];
   NSMutableDictionary* local_loaders_ = [ NSMutableDictionary dictionaryWithCapacity: [ self.files count ] ];
   
   for ( PFQuoteFile* file_ in  self.files )
   {
      PFQuoteFileLoader* loader_ = [ PFQuoteFileLoader loaderWithFile: file_ delegate: self ];
      
      NSData* file_data_ = [ delegate_ reader: self dataFromFile: file_.name WithSignature: file_.signature ];
      
      if( file_data_ )
      {
         [ local_loaders_ setObject: loader_ forKey: file_data_ ];
      }
      else
      {
         if ( ![ loader_ connectToServerWithInfo: self.serverInfo ] )
         {
            [ self disconnectLoaders: loaders_
                               error: [ NSError PFErrorWithDescription: PFLocalizedString( @"CONNECTION_ERROR", nil ) ] ];
            return;
         }
         
         [ loaders_ addObject: loader_ ];
      }
   }
   
   [ loaders_ addObjectsFromArray: [ local_loaders_ allValues ] ];
   
   self.delegate = delegate_;
   self.completedLoaders = [ NSMutableArray array ];
   self.loaders = loaders_;
   
   for ( NSData* data_ in [ local_loaders_ allKeys ] )
   {
      dispatch_async( dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ), ^{
         [ (PFQuoteFileLoader*)[ local_loaders_ objectForKey: data_ ] loadData: data_ ];
      } );
   }
}

-(void)stop
{
    self.delegate = nil;
    [ self.loaders makeObjectsPerformSelector: @selector( disconnect ) ];
    self.loaders = nil;
}

+(id)readerWithServerInfo:( PFServerInfo* )server_info_
                    files:( NSArray* )files_
                  lastBar:( id )last_bar_
                 fromDate:( NSDate* )from_date_
               basePeriod:( PFChartPeriodType )base_period_
        destinationPeriod:( PFChartPeriodType )period_
           timeZoneOffset:( PFInteger )time_zone_offset_
{
   PFQuoteFilesReader* reader_ = [ self new ];
   reader_.files = files_;
   reader_.lastBar = last_bar_;
   reader_.serverInfo = server_info_;
   reader_.fromDate = from_date_;
   reader_.basePeriod = base_period_;
   reader_.destinationPeriod = period_;
   reader_.timeZoneOffset = time_zone_offset_;
   return reader_;
}

-(NSString*)server
{
   return self.serverInfo.activeServer;
}

-(void)loader:( PFQuoteFileLoader* )loader_
didLoadQuotes:( NSArray* )quotes_
     needSave:( BOOL )need_save_
{
    if ( need_save_ )
    {
        [ self.delegate reader: self saveFileWithName: loader_.file.name data: loader_.file.data hash: loader_.file.signature ];
    }
    
    [ self.completedLoaders addObject: loader_ ];
    
    if ( [ self.completedLoaders count ] != [ self.loaders count ] )
        return;
    
    NSMutableArray* all_quotes_ = [ NSMutableArray array ];
    for ( PFQuoteFile* file_ in self.files )
    {
        [ all_quotes_ addObjectsFromArray: file_.quotes ];
    }

    NSArray* all_sorted_quotes_ = [all_quotes_ sortedArrayWithOptions: 0
                                                      usingComparator:
                                   ^(PFBaseQuote* v1, PFBaseQuote* v2)
                                   {
                                       long delta_time = [v1.date timeIntervalSinceDate: v2.date];

                                       if (delta_time == 0) return NSOrderedSame;
                                       return delta_time < 0 ? NSOrderedAscending : NSOrderedDescending;
                                   } ];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        PFQuotesConverter* quotes_converter_ = [ PFQuotesConverter new ];
        
        NSArray* quotes_array_ = [ quotes_converter_ arrayByConvertingQuotes: all_sorted_quotes_
                                                                    fromDate: self.fromDate
                                                                  fromPeriod: self.basePeriod
                                                                    toPeriod: self.destinationPeriod
                                                              timeZoneOffset: self.timeZoneOffset ];
        
        /*
         22.01.2014
         when we calculating bars for period in that moment client receiving new ticks,
         when calculated we merge last ticks with last existing one
         23.01 more than minute bar fix
         */
        if (self.lastBar)
        {
            BOOL  isMinuteperiod = IsMinutePeriod(self.destinationPeriod );
            PFBaseQuote * lastQuotes = self.lastBar;
            PFBaseQuote * existingLastQuoteWithPeriod = [quotes_array_ lastObject];
            BOOL haveToAddNewBar = YES;
            
            NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar] ;
            NSDateComponents *newBar = [gregorian components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:[existingLastQuoteWithPeriod date]];
            
            if(!(self.destinationPeriod == PFChartPeriodM1) && [newBar second]==0)
            {
                int mins = (int)(([newBar hour]*60) + [newBar minute]);
                mins %= self.destinationPeriod ;
                
                if(mins == 0 )
                    haveToAddNewBar = YES;
            }
            
            if(isMinuteperiod)
            {
                NSCalendar *gregorian1 = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar] ;
                NSDateComponents *lastOldBar = [gregorian1 components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:[lastQuotes date]];
                
                if(lastOldBar.minute == newBar.minute && haveToAddNewBar)
                {
                    haveToAddNewBar = YES;
                }
                //minute is not finished
                else if(haveToAddNewBar && self.destinationPeriod == PFChartPeriodM1)
                {
                    haveToAddNewBar = NO;
                }
            }
            else
            {
                if(self.destinationPeriod!=PFChartPeriodH1&&
                   self.destinationPeriod!=PFChartPeriodH4&&
                   self.destinationPeriod!=PFChartPeriodW1&&
                   self.destinationPeriod!=PFChartPeriodMN1)
                    haveToAddNewBar = NO;
            }
            
            if(!haveToAddNewBar && self.lastBar)
                quotes_array_= [ quotes_array_ arrayByAddingObject: self.lastBar ]  ;
            else
            {
                PFBaseQuote * lastQuotes = [self lastBar];
                PFBaseQuote * existingLastQuoteWithPeriod = [quotes_array_ lastObject];
                
                [[existingLastQuoteWithPeriod info] setClose:[[lastQuotes info]close]];
                
                [existingLastQuoteWithPeriod.info setVolume: existingLastQuoteWithPeriod.info.volume+ lastQuotes.info.volume];
                
                if((existingLastQuoteWithPeriod.info.low) > lastQuotes.info.low)
                    [existingLastQuoteWithPeriod.info setLow:lastQuotes.info.low];
                
                if((existingLastQuoteWithPeriod.info.high) < lastQuotes.info.high)
                    [existingLastQuoteWithPeriod.info setHigh:lastQuotes.info.high];
            }
        }

        [ self.delegate reader: self didLoadQuotes: quotes_array_ ];
    });
}

-(void)loader:( PFQuoteFileLoader* )loader_
didLoadQuotes:( NSArray* )quotes_
{
   [ self loader: loader_ didLoadQuotes: quotes_ needSave: YES ];
}

-(void)loader:( PFQuoteFileLoader* )loader_
didFailWithError:( NSError* )error_
{
   dispatch_async(dispatch_get_main_queue(), ^{
      [ self disconnectLoaders: self.loaders error: error_ ];
   });
}

@end
