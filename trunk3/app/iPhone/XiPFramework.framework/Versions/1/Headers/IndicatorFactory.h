
#import <Foundation/Foundation.h>


@class FinanceChart;
@class XYChart;
@class BaseBoxLayer;
@class LineLayer;
@class DOTLayer;
@class InterLineLayer;
@class BarsLayer;

@protocol IndicatorFactoryDelegate
@required
- (BaseBoxLayer*)addMainIndicator:(NSString*)code WithProperties:(NSString*)path ForChart:(FinanceChart*)chart;
- (void)addAuxIndicator:(NSString*)code WithProperties:(NSString*)path ToChart:(XYChart*) indChart;
@end

@interface IndicatorFactory : NSObject <IndicatorFactoryDelegate>
{
    NSNumberFormatter *numberFormatter;
}
//<IndicatorFactoryDelegate> methods
- (BaseBoxLayer*)addMainIndicator:(NSString*)code WithProperties:(NSString*)path ForChart:(FinanceChart*)chart;
- (void)addAuxIndicator:(NSString*)code WithProperties:(NSString*)path ToChart:(XYChart*) indChart;

//own methods

//main window indicators
-(LineLayer*)addSimpleMovingAvg:(NSString*)path ForChart:(FinanceChart*)chart;
-(LineLayer*)addExpMovingAvg:(NSString*)path ForChart:(FinanceChart*)chart;
-(DOTLayer*)addPSAR:(NSString*)path ForChart:(FinanceChart*)chart;
-(InterLineLayer*)addBB:(NSString*)path ForChart:(FinanceChart*)chart;
-(void)addENV:(NSString*)path ForChart:(FinanceChart*)chart;


//additional window indicators
- (void)addMTM:(NSString*)path ToChart:(XYChart*)indChart;
- (void)addVOL:(NSString*)path ToChart:(XYChart*)indChart;
- (void)addMACD:(NSString*)path ToChart:(XYChart*)indChart;
- (void)addRSI:(NSString*)path ToChart:(XYChart*)indChart;
- (void)addWILL:(NSString*)path ToChart:(XYChart*)indChart;
- (void)addSTO:(NSString*)path ToChart:(XYChart*)indChart;
- (void)addDMI:(NSString*)path ToChart:(XYChart*)indChart;
@end
