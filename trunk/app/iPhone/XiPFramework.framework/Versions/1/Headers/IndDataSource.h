
#import <Foundation/Foundation.h>
#import "BaseDataStore.h"

@class PropertiesStore;
@interface IndDataSource : BaseDataStore 
{
    BaseDataStore* src;
}
- (id)initWithDataSource:(BaseDataStore*)baseData
           AndProperties:(PropertiesStore*)properties 
                 AndPath:(NSString*)path;
//called to do the first build based on the whole source vector
-(void)build;
//called from outside to inform the last basr value in the source DS has changed
-(void)SourceDataChanged;
@property (assign) BaseDataStore* src; 
@end
