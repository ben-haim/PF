#import <Foundation/Foundation.h>

@protocol PFAccount;

@interface PFAccountDetailDataSource : NSObject

@property ( nonatomic, assign, readonly ) NSUInteger numberOfRows;

+(id)todayDataSource;
+(id)activityDataSource;
+(id)generalDataSource;

-(UITableViewCell*)cellForAccount:( id< PFAccount > )account_
                        tableView:( UITableView* )table_view_
                              row:( NSUInteger )row_;

@end
