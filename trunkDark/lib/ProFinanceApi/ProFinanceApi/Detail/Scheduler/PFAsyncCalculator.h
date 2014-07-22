#import <Foundation/Foundation.h>

@class PFCalculation;

@protocol PFAsyncCalculatorDelegate;

@interface PFAsyncCalculator : NSObject

@property ( nonatomic, assign ) id< PFAsyncCalculatorDelegate > delegate;

-(id)initWithDuration:( NSTimeInterval )timer_interval_;

-(void)addCalculation:( PFCalculation* )calculation_;

-(void)removeAllCalculations;

-(void)start;
-(void)stop;

@end

@protocol PFAsyncCalculatorDelegate <NSObject>

-(void)asyncCalculator:( PFAsyncCalculator* )calculator_
didPerformCalculations:( NSArray* )calculations_;

@end
