#import "PFCalculation.h"

@interface PFCalculation ()

@property ( nonatomic, copy ) PFCalculationBlock block;
@property ( nonatomic, copy ) PFCalculationDoneBlock doneBlock;

@end

@implementation PFCalculation

@synthesize block;
@synthesize doneBlock;

-(id)initWithBlock:( PFCalculationBlock )block_
         doneBlock:( PFCalculationDoneBlock )done_block_
{
   self = [ super init ];
   if ( self )
   {
      self.block = block_;
      self.doneBlock = done_block_;
   }
   return self;
}

+(id)calculationWithBlock:( PFCalculationBlock )block_
                doneBlock:( PFCalculationDoneBlock )done_block_
{
   return [ [ self alloc ] initWithBlock: block_ doneBlock: done_block_ ];
}

-(id)calculate
{
   NSAssert( self.block, @"unitialized block" );
   return self.block();
}

-(void)done:(id)result_
{
   NSAssert( [ NSThread isMainThread ], @"must be only from main thread" );
   if ( self.doneBlock )
   {
      self.doneBlock(result_);
   }
}

@end
