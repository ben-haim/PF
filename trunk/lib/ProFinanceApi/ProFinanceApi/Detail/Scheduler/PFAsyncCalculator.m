#import "PFAsyncCalculator.h"

#import "PFCalculation.h"

#import <AsyncDispatcher/ADBlockWrappers.h>

@interface PFAsyncCalculator ()

@property ( nonatomic, assign ) NSTimeInterval duration;
@property ( nonatomic, strong ) NSMutableArray* calculations;
@property ( nonatomic, assign ) BOOL running;

@end

@implementation PFAsyncCalculator

@synthesize duration;
@synthesize calculations = _calculations;
@synthesize running;

@synthesize delegate;

-(id)initWithDuration:( NSTimeInterval )duration_
{
   self = [ super init ];
   if ( self )
   {
      self.duration = duration_;
   }
   return self;
}

-(id)init
{
   NSTimeInterval default_duration_ = 2.0;
   return [ self initWithDuration: default_duration_ ];
}

-(NSMutableArray*)calculations
{
   if ( !_calculations )
   {
      _calculations = [ NSMutableArray new ];
   }
   return _calculations;
}

-(void)addCalculation:( PFCalculation* )calculation_
{
   [ self.calculations addObject: calculation_ ];
}

-(void)removeAllCalculations
{
   self.calculations = nil;
}

-(void)perfromCalculations:( NSArray* )calculations_
{
   NSAssert( ![ NSThread isMainThread ], @"must be not main thread" );

   if ( self.running )
   {
      for ( PFCalculation* calculation_ in calculations_ )
      {
         id result_ = [ calculation_ calculate ];

         ADAsyncOnMainThread( ^(){ if ( self.running ) [ calculation_ done: result_ ]; } );
      }

      ADAsyncOnMainThread( ^()
      {
         if ( self.running )
         {
            [ self.delegate asyncCalculator: self didPerformCalculations: calculations_ ];
            [ self scheduleCalculations ];
         }
      } );
   }
}

-(void)scheduleCalculations
{
   NSAssert( [ NSThread isMainThread ], @"must be main thread" );
   NSArray* calculations_ = self.calculations;
   ADDelayAsyncOnBackgroundThread( ^(){ [ self perfromCalculations: calculations_ ]; }, self.duration );
}

-(void)start
{
   if ( !self.running )
   {
      [ self scheduleCalculations ];
      self.running = YES;
   }
}

-(void)stop
{
   if ( self.running )
   {
      self.running = NO;
   }
}

@end
