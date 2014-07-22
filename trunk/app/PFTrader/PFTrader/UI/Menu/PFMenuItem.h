#import <UIKit/UIKit.h>

typedef UIViewController* (^PFMenuItemControllerBuilder)();
typedef void (^PFMenuItemAction)();

@class PFMenuItem;
typedef BOOL (^PFMenuItemVisibilityPredicate)( PFMenuItem* menu_item_ );

typedef enum
{
   PFMenuItemTypeUndefined
   , PFMenuItemTypePositions
   , PFMenuItemTypeNews
   , PFMenuItemTypeChat
   , PFMenuItemTypeEventLog
   , PFMenuItemTypeSecureLog
} PFMenuItemType;

extern NSString* const PFMenuItemBadgeValueDidChangeNotification;

@interface PFMenuItem : NSObject

@property ( nonatomic, assign, readonly ) PFMenuItemType type;
@property ( nonatomic, strong ) NSString* title;
@property ( nonatomic, strong ) UIImage* icon;
@property ( nonatomic, assign ) NSUInteger badgeValue;
@property ( nonatomic, strong, readonly ) UIViewController* controller;
@property ( nonatomic, copy ) PFMenuItemVisibilityPredicate visibilityPredicate;

@property ( nonatomic, assign, readonly ) BOOL isVisible;

+(id)itemWithControllerClass:( Class )controller_class_
                       title:( NSString* )title_
                        icon:( UIImage* )icon_;

+(id)itemWithController:( UIViewController* )controller_
                   icon:( UIImage* )icon_;

+(id)itemWithControllerBuilder:( PFMenuItemControllerBuilder )builder_
                         title:( NSString* )title_
                          icon:( UIImage* )icon_;

+(id)itemWithAction:( PFMenuItemAction )action_
              title:( NSString* )title_
               icon:( UIImage* )icon_;

-(void)performAction;

@end

@interface PFMenuItem (Constructors)

+(id)itemWithPositionsControllerClass:( Class )controller_class_;
+(id)itemWithNewsControllerClass:( Class )controller_class_;
+(id)itemWithChatControllerClass:( Class )controller_class_;
+(id)itemWithEventsControllerClass:( Class )controller_class_;
+(id)itemWithSecureLogsControllerClass:( Class )controller_class_;

@end
