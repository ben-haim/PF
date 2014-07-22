#import "PFTableViewCategory+SecureLog.h"

#import "PFTableViewDatePickerItem.h"
#import "PFSecureLogsController.h"


@implementation PFTableViewCategory ( SecureLog )

+(id)logDateCategoryWithController:( PFSecureLogsController* )controller_
{
   __unsafe_unretained PFSecureLogsController* unsafe_controller_ = controller_;
   
   PFTableViewDatePickerItem* date_item_ = [ PFTableViewDatePickerItem itemWithAction: nil
                                                                                title: NSLocalizedString( @"LOG_DATE", nil ) ];
   
   date_item_.date = [ NSDate date ];
   date_item_.dateMode = UIDatePickerModeDate;
   date_item_.pickerAction =  ^( PFTableViewBasePickerItem* picker_item_ )
   {
      PFTableViewDatePickerItem* item_ = ( PFTableViewDatePickerItem* )picker_item_;
      [ unsafe_controller_  showReportWithDate: item_.date ];
   };
   
   return [ self categoryWithTitle: nil items: @[date_item_] ];
}

@end
