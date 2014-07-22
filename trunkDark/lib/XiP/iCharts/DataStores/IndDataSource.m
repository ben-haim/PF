
#import "IndDataSource.h"
#import "PropertiesStore.h"

@implementation IndDataSource
@synthesize src;

- (id)initWithDataSource:(BaseDataStore*)baseData
           AndProperties:(PropertiesStore*)properties 
                 AndPath:(NSString*)path
{    
    self = [super init];
    if(self == nil)
        return self;
    [self setSrc:baseData];
    return self;
}


//called to do the first build based on the whole source vector
-(void)build
{
    
}

//called from outside to inform the last basr value in the source DS has changed
-(void)SourceDataChanged
{
    
}

@end
