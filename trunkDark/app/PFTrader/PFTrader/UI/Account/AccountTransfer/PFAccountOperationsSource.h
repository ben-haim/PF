#import <Foundation/Foundation.h>

@class PFTableViewController;
@protocol PFAccount;

@protocol PFAccountOperationsSource < NSObject >

-(NSString*)title;
-(void)activateInController:( PFTableViewController* )controller_
                 andAccount:( id< PFAccount > )account_;
-(void)deactivate;
-(void)updateCategories;
-(void)updateTargetAccount;
-(void)submitAction;

@end

@interface PFAccountOperationsSource : NSObject < PFAccountOperationsSource >

-(NSArray*)categoriesWithController:( PFTableViewController* )controller_
                         andAccount:( id< PFAccount > )account_;

@end

@interface PFAccountTransferSource : PFAccountOperationsSource

@end

@interface PFAccountWithdrawalSource : PFAccountOperationsSource

@end
