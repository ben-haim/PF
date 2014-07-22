

#import <Foundation/Foundation.h>
#import "ParamsStorage.h"


@interface SelectAccount : UITableViewController
{
	ParamsStorage *storage;
	NSMutableArray *accountData;
}

-(void)SetAccounts:(ParamsStorage*)_storage;
- (IBAction) back:(id)sender;
-(IBAction) editStarted:(id)sender;
-(IBAction) editEnded:(id)sender;

@end
