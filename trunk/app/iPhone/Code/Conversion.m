
#import "Conversion.h"
 

@implementation Conversion

@synthesize Pair, Divide, Constant, ReversePrevious;

-(id) init
{
	self = [super init];
	Pair = nil;
	Divide = NO;
	Constant = NO;
	ReversePrevious = NO;
	return self;

}
-(BOOL) IsEmpty
{
	return Pair==nil;
}
- (void)dealloc 
{
	if(Pair!=nil)
		[Pair release];
	Pair = nil;
	[super dealloc];
}

-(NSString*)ProfitCurrency
{
	NSCharacterSet *charactersToRemove = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
	NSString *replacement = [Pair stringByTrimmingCharactersInSet:charactersToRemove];
	
	//NSLog(@"PAIR: %@", Pair);
	if (Divide)
	{
		if ([replacement length] > 2)
			return [replacement substringToIndex:3];
	}
	else 
	{
		NSRange range;
		range.location = 3;
		range.length = 3;
		
		if ([replacement length] > 5)
		{
			//NSLog(@"profit currency: %@", [Pair substringWithRange:range]);
			return [replacement substringWithRange:range];
		}
	}
	return @"";
}

@end
