#import "PFChartSettings.h"

#import "PFIndicator.h"
#import "PFChartColorScheme.h"

#import "PropertiesStore.h"

#import <JFF/Utils/NSArray+BlocksAdditions.h>

@interface PFChartSettings ()

@property ( nonatomic, strong ) PropertiesStore* properties;
@property ( nonatomic, strong, readonly ) NSMutableDictionary* indicatorsById;
@property ( nonatomic, strong, readonly ) NSMutableArray* mutableMainIndicators;
@property ( nonatomic, strong, readonly ) NSMutableArray* mutableAdditionalIndicators;
@property ( nonatomic, strong, readonly ) NSMutableArray* indicators;
@property ( nonatomic, strong ) NSArray* defaultIndicators;

@end

@implementation PFChartSettings

@synthesize properties;
@synthesize indicatorsById = _indicatorsById;
@synthesize mutableMainIndicators = _mutableMainIndicators;
@synthesize mutableAdditionalIndicators = _mutableAdditionalIndicators;
@synthesize indicators = _indicators;
@synthesize defaultIndicators = _defaultIndicators;

-(NSUInteger)userIndicatorsCount
{
   return [ self.mainIndicators count ] + [ self.additionalIndicators count ];
}

-(NSArray*)mainIndicators
{
   return self.mutableMainIndicators;
}

-(NSArray*)additionalIndicators
{
   return self.mutableAdditionalIndicators;
}

-(NSMutableArray*)indicators
{
   if ( !_indicators )
   {
      NSArray* ids_ = [ self.properties getArray: @"indicators.order" ];
      _indicators = [ [ ids_ map: ^id( id indicator_id_ )
                       {
                          NSDictionary* dictionary_ = [ self.properties getDict: [ @"indicators." stringByAppendingString: ( NSString* )indicator_id_ ] ];
                          
                          PFIndicator* indicator_ = [ [ PFIndicator alloc ] initWithDictionary: dictionary_ ];
                          indicator_.indicatorId = indicator_id_;
                          return indicator_;
                       }] mutableCopy ];
   }
   return _indicators;
}

-(NSArray*)indicatorsWithIds:( NSArray* )ids_
{
   return [ ids_ map: ^id( id id_ )
    {
       return [ self.indicatorsById objectForKey: id_ ];
    }];
}

-(NSMutableArray*)mutableMainIndicators
{
   if ( !_mutableMainIndicators )
   {
      NSArray* indicators_ = [ self indicatorsWithIds: [ self.properties getArray: @"indicators.user_main" ] ];
      _mutableMainIndicators = indicators_ ? [ indicators_ mutableCopy ] : [ NSMutableArray new ];
   }
   return _mutableMainIndicators;
}

-(NSMutableArray*)mutableAdditionalIndicators
{
   if ( !_mutableAdditionalIndicators )
   {
      NSArray* indicators_ = [ self indicatorsWithIds: [ self.properties getArray: @"indicators.user_add" ] ];
      _mutableAdditionalIndicators = indicators_ ? [ indicators_ mutableCopy ] : [ NSMutableArray new ];
   }
   return _mutableAdditionalIndicators;
}

-(NSMutableDictionary*)indicatorsById
{
   if ( !_indicatorsById )
   {
      NSMutableDictionary* by_id_ = [ NSMutableDictionary dictionaryWithCapacity: [ self.indicators count ] ];
      for ( PFIndicator* indicator_ in self.indicators )
      {
         [ by_id_ setObject: indicator_ forKey: indicator_.indicatorId ];
      }
      _indicatorsById = by_id_;
   }
   return _indicatorsById;
}

-(NSArray*)defaultIndicators
{
   if ( !_defaultIndicators )
   {
      PFChartSettings* default_settings_ = [ [ self class ] defaultSettings ];
      _defaultIndicators = default_settings_.indicators;
   }
   return _defaultIndicators;
}

-(id)initWithContentsOfFile:( NSString* )path_
{
   NSString* chart_settings_ = [ NSString stringWithContentsOfFile: path_
                                                          encoding: NSUTF8StringEncoding
                                                             error: nil ];

   if ( !chart_settings_ )
      return nil;

   self = [ super init ];
   if ( self )
   {
      self.properties = [ [ PropertiesStore alloc ] initWithString: chart_settings_ ];
   }

   return self;
}

-(id)init
{
   self =  [ self initWithContentsOfFile: [ [ NSBundle mainBundle ] pathForResource: @"PFChartSettings"
                                                                             ofType: @"json" ] ];

   if ( self )
   {
      self.defaultIndicators = [ self.indicators copy ];
   }

   return self;
}

+(id)defaultSettings
{
   return [ self new ];
}

+(id)settingsWithContentsOfFile:( NSString* )path_
{
   return [ [ self alloc ] initWithContentsOfFile: path_ ];
}

+(NSString*)path
{
   NSString* document_directory_ = [ NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES ) lastObject ];

   return [ document_directory_ stringByAppendingPathComponent: @"PFChartSettings.json" ];
}

+(PFChartSettings*)sharedSettings
{
   static PFChartSettings* settings_ = nil;
   if ( !settings_ )
   {
      PFChartSettings* document_settings_ = [ self settingsWithContentsOfFile: [ self path ] ];
      settings_ = document_settings_ ? document_settings_ : [ self defaultSettings ];
   }
   return settings_;
}

-(NSMutableArray*)mutableIndicatorsMain:( BOOL )main_
{
   return main_
      ? self.mutableMainIndicators
      : self.mutableAdditionalIndicators;
}

-(NSString*)freeIdForCode:( NSString* )code_
{
   for ( NSUInteger index_ = 0; ; ++index_ )
   {
      NSString* free_id_ = [ code_ stringByAppendingFormat: @"_%d", (int)index_ ];
      if ( [ self.indicatorsById objectForKey: free_id_ ] == nil )
      {
         return free_id_;
      }
   }
   return nil;
}

-(void)addIndicator:( PFIndicator* )default_indicator_
{
   PFIndicator* added_indicator_ = [ default_indicator_ copy ];
   added_indicator_.indicatorId = [ self freeIdForCode: default_indicator_.code ];

   [ [ self mutableIndicatorsMain: default_indicator_.main ] addObject: added_indicator_ ];
   [ self.indicators addObject: added_indicator_ ];
   [ self.indicatorsById setObject: added_indicator_ forKey: added_indicator_.indicatorId ];
}

-(void)removeIndicator:( PFIndicator* )indicator_
{
   [ [ self mutableIndicatorsMain: indicator_.main ] removeObject: indicator_ ];
   [ self.indicators removeObject: indicator_ ];
   [ self.indicatorsById removeObjectForKey: indicator_.indicatorId ];
}

-(BOOL)showOrders
{
   return [ [ self.properties getParam: @"view.showOrders" ] intValue ];
}

-(void)setShowOrders:( BOOL )show_orders_
{
   [ self.properties setParamValue: @"showOrders"
                            inPath: @"view"
                         WithValue: [ NSString stringWithFormat: @"%d", show_orders_ ] ];
}

-(BOOL)showPositions
{
   return [ [ self.properties getParam: @"view.showPositions" ] intValue ];
}

-(void)setShowPositions:( BOOL )show_positions_
{
   [ self.properties setParamValue: @"showPositions"
                            inPath: @"view"
                         WithValue: [ NSString stringWithFormat: @"%d", show_positions_ ] ];
}

-(BOOL)showVolume
{
   return [ [ self.properties getParam: @"view.chartVolumes" ] intValue ];
}

-(void)setShowVolume:( BOOL )show_volume_
{
   [ self.properties setParamValue: @"chartVolumes"
                            inPath: @"view"
                         WithValue: [ NSString stringWithFormat: @"%d", show_volume_ ] ];
}

-(BOOL)tradeLevelsInZoom
{
   return [ [ self.properties getParam: @"view.tradeLevelsInZoom" ] intValue ];
}

-(void)setTradeLevelsInZoom:( BOOL )trade_levels_in_zoom_
{
   [ self.properties setParamValue: @"tradeLevelsInZoom"
                            inPath: @"view"
                         WithValue: [ NSString stringWithFormat: @"%d", trade_levels_in_zoom_ ] ];
}


-(PFChartStyleType)styleType
{
   return [ [ self.properties getParam: @"view.chartType" ] intValue ];
}

-(void)setStyleType:( PFChartStyleType )syle_
{
   [ self.properties setParamValue: @"chartType"
                            inPath: @"view"
                         WithValue: [ NSString stringWithFormat: @"%d", syle_ ] ];
}

-(PFChartColorSchemeType)schemeType
{
   return [ [ self.properties getParam: @"view.chartColorSheme" ] intValue ];
}

-(void)setSchemeType:( PFChartColorSchemeType )sheme_
{
   [ self.properties setParamValue: @"chartColorSheme"
                            inPath: @"view"
                         WithValue: [ NSString stringWithFormat: @"%d", sheme_ ] ];

   PFChartColorScheme* scheme_ = [ PFChartColorScheme schemeWithType: sheme_ ];
   for ( NSString* path_ in scheme_.properties )
   {
      [ self.properties setParamValue: @"value"
                               inPath: path_
                            WithValue: [ scheme_.properties objectForKey: path_ ] ];
   }
}

-(void)save
{
   if ( _mutableMainIndicators )
   {
      [ self.properties setArray: @"user_main"
                          inPath: @"indicators"
                       WithArray: [ _mutableMainIndicators valueForKeyPath: @"@unionOfObjects.indicatorId" ] ];
   }

   if ( _mutableAdditionalIndicators )
   {
      [ self.properties setArray: @"user_add"
                          inPath: @"indicators"
                       WithArray: [ _mutableAdditionalIndicators valueForKeyPath: @"@unionOfObjects.indicatorId" ] ];
   }

   if ( _indicators )
   {
      [ self.properties setArray: @"order"
                          inPath: @"indicators"
                       WithArray: [ _indicators valueForKeyPath: @"@unionOfObjects.indicatorId" ] ];

      for ( PFIndicator* indicator_ in _indicators )
      {
         [ self.properties setDict: indicator_.indicatorId
                            inPath: @"indicators"
                          WithDict: [ indicator_ dictionary ] ];
      }
   }

   NSString* json_ = [ self.properties getJSONString ];
   [ json_ writeToFile: [ [ self class ] path ]
            atomically: YES
              encoding: NSUTF8StringEncoding
                 error: 0 ];
}

@end
