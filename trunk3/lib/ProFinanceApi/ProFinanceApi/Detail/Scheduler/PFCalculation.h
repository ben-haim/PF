#import <UIKit/UIKit.h>

typedef id (^PFCalculationBlock)();
typedef void (^PFCalculationDoneBlock)( id result_ );

@interface PFCalculation : NSObject

-(id)initWithBlock:( PFCalculationBlock )block_
         doneBlock:( PFCalculationDoneBlock )done_block_;

+(id)calculationWithBlock:( PFCalculationBlock )block_
                doneBlock:( PFCalculationDoneBlock )done_block_;

-(id)calculate;
-(void)done:( id )result_;

@end
