#import "PFTabItem.h"

@class PFMenuItem;

typedef BOOL (^PFMenuItemVisibilityPredicate)( PFMenuItem* menu_item_ );

typedef enum
{
   PFMenuItemTypeUndefined
   , PFMenuItemTypePositions
   , PFMenuItemTypeOrders
   , PFMenuItemTypeNews
   , PFMenuItemTypeChat
   , PFMenuItemTypeEventLog
   , PFMenuItemTypeSecureLog
} PFMenuItemType;

@interface PFMenuItem : PFTabItem

@property ( nonatomic, copy ) PFMenuItemVisibilityPredicate visibilityPredicate;
@property ( nonatomic, assign, readonly ) PFMenuItemType type;
@property ( nonatomic, assign, readonly ) BOOL isVisible;

@end

@interface PFMenuItem (Constructors)

+(id)itemWithPositionsControllerClass:( Class )controller_class_;
+(id)itemWithOrdersControllerClass:( Class )controller_class_;
+(id)itemWithNewsControllerClass:( Class )controller_class_;
+(id)itemWithChatControllerClass:( Class )controller_class_;
+(id)itemWithEventsControllerClass:( Class )controller_class_;
+(id)itemWithSecureLogsControllerClass:( Class )controller_class_;

@end
