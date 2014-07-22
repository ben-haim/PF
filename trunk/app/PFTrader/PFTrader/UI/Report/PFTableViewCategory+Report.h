#import "PFTableViewCategory.h"

@protocol PFMutableSearchCriteria;

@interface PFTableViewCategory (Report)

+(id)fromDateCategoryWithCriteria:( id< PFMutableSearchCriteria > )criteria_;
+(id)toDateCategoryWithCriteria:( id< PFMutableSearchCriteria > )criteria_;
+(id)tableTypeCategoryWithCriteria:( id< PFMutableSearchCriteria > )criteria_;

@end
