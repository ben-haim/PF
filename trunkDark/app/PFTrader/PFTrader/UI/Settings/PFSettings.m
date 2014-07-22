#import "PFSettings.h"

static const double defaultChartCacheSize = 10.0;

@interface PFSettings ()


@end

@implementation PFSettings

@synthesize shouldConfirmPlaceOrder;
@synthesize shouldConfirmModifyOrder;
@synthesize shouldConfirmCancelOrder;
@synthesize shouldConfirmModifyPosition;
@synthesize shouldConfirmClosePosition;
@synthesize shouldConfirmExecuteAsMarket;
@synthesize lots;
@synthesize orderValidity;
@synthesize orderType;
@synthesize chartCacheMaxSize;
@synthesize defaultChartPeriod;
@synthesize useSLTPOffset;
@synthesize playSounds;
@synthesize showTradingHalt;
@synthesize showQuantityInLots;

+(NSString*)settingsPath
{
   NSString* document_directory_ = [ NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES ) lastObject ];
   return [ document_directory_ stringByAppendingPathComponent: @"PFSettingsInfo.plist" ];
}

-(id)init
{
   self = [ super init ];
   if ( self )
   {
      self.lots = 1.0;
      self.chartCacheMaxSize = defaultChartCacheSize;
      self.defaultChartPeriod = PFChartPeriodM1;
      self.orderValidity = PFOrderValidityDay;
      self.orderType = PFOrderMarket;
      self.shouldConfirmPlaceOrder = YES;
      self.shouldConfirmModifyOrder = YES;
      self. shouldConfirmCancelOrder = YES;
      self.shouldConfirmClosePosition = NO;
      self.shouldConfirmModifyPosition = NO;
      self.shouldConfirmExecuteAsMarket = NO;
      self.useSLTPOffset = NO;
      self.playSounds = YES;
      self.showTradingHalt = YES;
      self.showQuantityInLots = YES;
   }
   return self;
}

+(id)settings
{
   NSData* data_ = [ NSData dataWithContentsOfFile: [ self settingsPath ] ];
   if ( !data_ )
      return [ self new ];
   
   return [ NSKeyedUnarchiver unarchiveObjectWithData: data_ ];
}

+(PFSettings*)sharedSettings
{
   static PFSettings* settings_ = nil;
   
   if ( !settings_ )
   {
      settings_ = [ PFSettings settings ];
   }
   
   return settings_;
}

-(id)initWithCoder:( NSCoder* )coder_
{
   self = [ super init ];
   
   if ( self )
   {
      self.shouldConfirmPlaceOrder = [ coder_ decodeBoolForKey: @"shouldConfirmPlaceOrder" ];
      self.shouldConfirmClosePosition = [ coder_ decodeBoolForKey: @"shouldConfirmClosePosition" ];
      self.lots = [ coder_ decodeDoubleForKey: @"lots" ];
      self.orderValidity = [ coder_ decodeIntForKey: @"orderValidity" ];
      self.orderType = [ coder_ decodeIntForKey: @"orderType" ];
      
      double chart_max_size_ = [ coder_ decodeDoubleForKey: @"chartCasheMaxSize" ];
      self.chartCacheMaxSize = chart_max_size_ > 0 ? chart_max_size_ : defaultChartCacheSize;
      
      self.defaultChartPeriod = [ coder_ decodeIntForKey: @"defaultChartPeriod" ];
      self.useSLTPOffset = [ coder_ decodeBoolForKey: @"useSLTPOffset" ];
      
      self.shouldConfirmModifyOrder = [ coder_ decodeBoolForKey: @"shouldConfirmModifyOrder" ];;
      self. shouldConfirmCancelOrder = [ coder_ decodeBoolForKey: @"shouldConfirmCancelOrder" ];
      self.shouldConfirmModifyPosition = [ coder_ decodeBoolForKey: @"shouldConfirmModifyPosition" ];
      self.shouldConfirmExecuteAsMarket = [ coder_ decodeBoolForKey: @"shouldConfirmExecuteAsMarket" ];
      
      self.playSounds = [ coder_ decodeBoolForKey: @"playSounds" ];
      self.showTradingHalt = [ coder_ decodeBoolForKey: @"showTradingHalt" ];
      self.showQuantityInLots = [ coder_ decodeBoolForKey: @"showQuantityInLots" ];
   }
   
   return self;
}

-(void)encodeWithCoder:( NSCoder* )coder_
{
   [ coder_ encodeBool: self.shouldConfirmPlaceOrder forKey: @"shouldConfirmPlaceOrder" ];
   [ coder_ encodeBool: self.shouldConfirmClosePosition forKey: @"shouldConfirmClosePosition" ];
   [ coder_ encodeDouble: self.lots forKey: @"lots" ];
   [ coder_ encodeInt: self.orderValidity forKey: @"orderValidity" ];
   [ coder_ encodeInt: self.orderType forKey: @"orderType" ];
   [ coder_ encodeDouble: self.chartCacheMaxSize forKey: @"chartCasheMaxSize" ];
   [ coder_ encodeInt: self.defaultChartPeriod forKey: @"defaultChartPeriod" ];
   [ coder_ encodeBool: self.useSLTPOffset forKey: @"useSLTPOffset" ];
   [ coder_ encodeBool: self.shouldConfirmModifyOrder forKey: @"shouldConfirmModifyOrder" ];
   [ coder_ encodeBool: self.shouldConfirmCancelOrder forKey: @"shouldConfirmCancelOrder" ];
   [ coder_ encodeBool: self.shouldConfirmModifyPosition forKey: @"shouldConfirmModifyPosition" ];
   [ coder_ encodeBool: self.shouldConfirmExecuteAsMarket forKey: @"shouldConfirmExecuteAsMarket" ];
   [ coder_ encodeBool: self.playSounds forKey: @"playSounds" ];
   [ coder_ encodeBool: self.showTradingHalt forKey: @"showTradingHalt" ];
   [ coder_ encodeBool: self.showQuantityInLots forKey: @"showQuantityInLots" ];
}

-(void)save
{
   [ NSKeyedArchiver archiveRootObject: self toFile: [ [ self class ] settingsPath ] ];
}

@end
