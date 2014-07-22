#import "PFTableViewCategory.h"

@protocol PFAccount;

@interface PFTableViewCategory (AccountDetail)

+(id)todayCategoryWithAccount:( id< PFAccount > )account_;
+(id)activityCategoryWithAccount:( id< PFAccount > )account_;
+(id)generalCategoryWithAccount:( id< PFAccount > )account_;
+(id)assetAccountCategoryWithAccount:( id< PFAccount > )account_;

@end
