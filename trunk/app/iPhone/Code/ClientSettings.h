

#import <Foundation/Foundation.h>
#import "DemoRegistration.h"
#import "RegField.h"
#import "ListEntry.h"

@class ParamsStorage;

@interface ClientSettings : NSObject 
{
	DemoFlags demoRegistrationMode;
	const NSArray * regFields;
	NSString *demoUrl;
}

@property(readonly) DemoFlags demoRegistrationMode;
@property(readonly, retain) const NSArray * regFields;
@property(readonly) NSString *demoUrl;

//demo
- (NSArray *)groups;
- (NSArray *)leverage;
- (NSArray *)deposit;
- (NSArray *)countries;

@end
