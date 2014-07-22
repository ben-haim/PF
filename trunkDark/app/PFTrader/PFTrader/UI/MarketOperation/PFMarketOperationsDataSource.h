#import <Foundation/Foundation.h>

@class PFTableViewController;

@protocol PFMarketOperationsDataSource < NSObject >

-(NSString*)title;
-(void)activateInController:( PFTableViewController* )controller_;
-(void)deactivate;
-(void)updateCategories;
-(void)updateCategoriesWithTitle:( NSString* )title_;

@end

@interface PFMarketOperationsDataSource : NSObject < PFMarketOperationsDataSource >

-(NSArray*)categoriesWithController:( PFTableViewController* )controller_;

@end

@interface PFActiveOperationsDataSource : PFMarketOperationsDataSource

@end

@interface PFFilledOperationsDataSource : PFMarketOperationsDataSource

@end

@interface PFAllOperationsDataSource : PFMarketOperationsDataSource

@end