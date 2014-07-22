#import "PFChartStyleType.h"
#import "PFChartColorSchemeType.h"

#import <UIKit/UIKit.h>

@class PropertiesStore;

@class PFIndicator;

@interface PFChartSettings : NSObject

@property ( nonatomic, strong, readonly ) NSArray* mainIndicators;
@property ( nonatomic, strong, readonly ) NSArray* additionalIndicators;
@property ( nonatomic, strong, readonly ) NSArray* defaultIndicators;
@property ( nonatomic, strong, readonly ) NSArray* defaultMainIndicators;
@property ( nonatomic, strong, readonly ) NSArray* defaultAdditionalIndicators;

@property ( nonatomic, strong, readonly ) PropertiesStore* properties;

@property ( nonatomic, assign, readonly ) NSUInteger userIndicatorsCount;

@property ( nonatomic, assign ) PFChartColorSchemeType schemeType;
@property ( nonatomic, assign ) PFChartStyleType styleType;

@property ( nonatomic, assign ) BOOL showLoupe;
@property ( nonatomic, assign ) BOOL showVolume;
@property ( nonatomic, assign ) BOOL showOrders;
@property ( nonatomic, assign ) BOOL showPositions;
@property ( nonatomic, assign ) BOOL tradeLevelsInZoom;

+(PFChartSettings*)sharedSettings;
+(PFChartSettings*)sharedDefaultSettings;

-(void)addIndicator:( PFIndicator* )indicator_;
-(void)removeIndicator:( PFIndicator* )indicator_;

-(void)save;

@end
