#import "PFMenuItem.h"
#import "UIImage+Icons.h"

@interface PFMenuItem ()

@property ( nonatomic, assign ) PFMenuItemType type;

@end

@implementation PFMenuItem

@synthesize type;
@synthesize visibilityPredicate;

-(BOOL)isVisible
{
   if ( !self.visibilityPredicate )
      return YES;

   return self.visibilityPredicate( self );
}

@end

@implementation PFMenuItem (Constructors)

+(id)itemWithPositionsControllerClass:( Class )controller_class_
{
   PFMenuItem* item_ = [ self itemWithControllerClass: controller_class_
                                                title: NSLocalizedString( @"POSITIONS", nil )
                                                 icon: [ UIImage positionIcon ] ];
   item_.type = PFMenuItemTypePositions;
   return item_;
}

+(id)itemWithOrdersControllerClass:( Class )controller_class_
{
   PFMenuItem* item_ = [ self itemWithControllerClass: controller_class_
                                                title: NSLocalizedString( @"ORDERS", nil )
                                                 icon: [ UIImage orderIcon ] ];
   item_.type = PFMenuItemTypeOrders;
   return item_;
}

+(id)itemWithNewsControllerClass:( Class )controller_class_
{
   PFMenuItem* item_ = [ self itemWithControllerClass: controller_class_
                                                title: NSLocalizedString( @"NEWS", nil )
                                                 icon: [ UIImage newsIcon ] ];
   item_.type = PFMenuItemTypeNews;
   return item_;
}

+(id)itemWithChatControllerClass:( Class )controller_class_
{
   PFMenuItem* item_ = [ self itemWithControllerClass: controller_class_
                                                title: NSLocalizedString( @"CHAT", nil )
                                                 icon: [ UIImage chatIcon ] ];
   item_.type = PFMenuItemTypeChat;
   return item_;
}

+(id)itemWithEventsControllerClass:( Class )controller_class_
{
   PFMenuItem* item_ = [ self itemWithControllerClass: controller_class_
                                                title: NSLocalizedString( @"EVENT_LOG", nil )
                                                 icon: [ UIImage eventLogIcon ] ];
   item_.type = PFMenuItemTypeEventLog;
   return item_;
}

+(id)itemWithSecureLogsControllerClass:( Class )controller_class_
{
   PFMenuItem* item_ = [ self itemWithControllerClass: controller_class_
                                                title: NSLocalizedString( @"SECURE_LOG", nil )
                                                 icon: [ UIImage secureLogIcon ] ];
   item_.type = PFMenuItemTypeSecureLog;
   return item_;
}

@end
