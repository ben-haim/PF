#import "PFTableViewCategory+Report.h"

#import "PFReportTableTypeItem.h"
#import "PFTableViewDatePickerItem.h"

#import <ProFinanceApi/ProFinanceApi.h>

@implementation PFTableViewCategory (Report)

+(id)fromDateCategoryWithCriteria:( id< PFMutableSearchCriteria > )criteria_
{
   PFTableViewDatePickerItem* from_item_ = [ PFTableViewDatePickerItem itemWithAction: nil
                                                                                title: NSLocalizedString( @"FROM", nil ) ];

   from_item_.date = criteria_.fromDateLocal;
   from_item_.pickerAction =  ^( PFTableViewBasePickerItem* picker_item_ )
   {
      PFTableViewDatePickerItem* date_item_ = ( PFTableViewDatePickerItem* )picker_item_;
      criteria_.fromDate = date_item_.date;
   };

   return [ self categoryWithTitle: nil items: [ NSArray arrayWithObject: from_item_ ] ];
}

+(id)toDateCategoryWithCriteria:( id< PFMutableSearchCriteria > )criteria_
{
   PFTableViewDatePickerItem* to_item_ = [ PFTableViewDatePickerItem itemWithAction: nil
                                                                              title: NSLocalizedString( @"TO", nil ) ];
   to_item_.date = criteria_.toDateLocal;
   to_item_.pickerAction =  ^( PFTableViewBasePickerItem* picker_item_ )
   {
      PFTableViewDatePickerItem* date_item_ = ( PFTableViewDatePickerItem* )picker_item_;
      criteria_.toDate = date_item_.date;
   };
   
   return [ self categoryWithTitle: nil items: [ NSArray arrayWithObject: to_item_ ] ];
}

+(id)tableTypeCategoryWithCriteria:( id< PFMutableSearchCriteria > )criteria_
{
   PFReportTableTypeItem* type_item_ = [ [ PFReportTableTypeItem alloc ] initWithTableType: criteria_.tableType ];
   type_item_.pickerAction =  ^( PFTableViewBasePickerItem* picker_item_ )
   {
      criteria_.tableType = [ (PFReportTableTypeItem*)picker_item_ tableType ];
   };

   return [ self categoryWithTitle: nil items: [ NSArray  arrayWithObject: type_item_ ] ];
}

@end
