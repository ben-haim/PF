

#import <Foundation/Foundation.h>


@interface Conversion : NSObject 
{
	NSString *Pair;
	BOOL Divide;
	BOOL Constant;
	BOOL ReversePrevious;
}
-(BOOL) IsEmpty;
@property( nonatomic, retain) NSString *Pair;
@property( assign) BOOL Divide;
@property( assign) BOOL Constant;
@property( assign) BOOL ReversePrevious;

-(NSString*)ProfitCurrency;

@end
