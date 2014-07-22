#import <Foundation/Foundation.h>

@class PFGridViewController;

@protocol PFMarketOperationsDataSource <NSObject>

-(NSString*)title;

-(void)selectElementAtIndex:( NSUInteger )index_;
-(void)showSummaryActions;

-(void)activateInController:( PFGridViewController* )controller_;
-(void)deactivate;

@end

@interface PFMarketOperationsDataSource : NSObject< PFMarketOperationsDataSource >

-(id)initWithColumns:( NSArray* )columns_;

@end

@interface PFActiveOperationsDataSource : PFMarketOperationsDataSource

@end

@interface PFFilledOperationsDataSource : PFMarketOperationsDataSource

@end

@interface PFAllOperationsDataSource : PFMarketOperationsDataSource

@end