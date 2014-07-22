#import "PFMenuItem.h"

#import "UIImage+Icons.h"

NSString* const PFMenuItemBadgeValueDidChangeNotification = @"PFMenuItemBadgeValueDidChangeNotification";

@interface PFMenuItem ()

@property ( nonatomic, assign ) PFMenuItemType type;
@property ( nonatomic, strong ) Class controllerClass;
@property ( nonatomic, copy ) PFMenuItemControllerBuilder builder;
@property ( nonatomic, copy ) PFMenuItemAction action;
@property ( nonatomic, strong ) UIViewController* controller;

@end

@implementation PFMenuItem

@synthesize type;
@synthesize title;
@synthesize icon;
@synthesize badgeValue = _badgeValue;
@synthesize controllerClass;
@synthesize builder;
@synthesize controller = _controller;
@synthesize visibilityPredicate;
@synthesize action;

-(id)initWithTitle:( NSString* )title_
              icon:( UIImage* )icon_
{
   self = [ super init ];
   if ( self )
   {
      self.title = title_;
      self.icon = icon_;
   }
   return self;
}

+(id)itemWithControllerClass:( Class )controller_class_
                       title:( NSString* )title_
                        icon:( UIImage* )icon_
{
   PFMenuItem* item_ = [ [ self alloc ] initWithTitle: title_
                                                 icon: icon_ ];

   item_.controllerClass = controller_class_;

   return item_;
}

+(id)itemWithController:( UIViewController* )controller_
                   icon:( UIImage* )icon_
{
   PFMenuItem* item_ = [ [ self alloc ] initWithTitle: controller_.title
                                                 icon: icon_ ];

   item_.controller = controller_;

   return item_;
}

+(id)itemWithControllerBuilder:( PFMenuItemControllerBuilder )builder_
                         title:( NSString* )title_
                          icon:( UIImage* )icon_
{
   PFMenuItem* item_ = [ [ self alloc ] initWithTitle: title_
                                                 icon: icon_ ];
   
   item_.builder = builder_;
   
   return item_;
}

+(id)itemWithAction:( PFMenuItemAction )action_
              title:( NSString* )title_
               icon:( UIImage* )icon_
{
   PFMenuItem* item_ = [ [ self alloc ] initWithTitle: title_
                                                 icon: icon_ ];
   
   item_.action = action_;
   
   return item_;
}

-(void)performAction
{
   if ( self.action )
   {
      self.action();
   }
}

-(UIViewController*)controller
{
   if ( _controller )
      return _controller;

   if ( self.builder )
      return self.builder();

   return [ self.controllerClass new ];
}

-(void)setBadgeValue:( NSUInteger )badge_value_
{
   if ( _badgeValue != badge_value_ )
   {
      _badgeValue = badge_value_;
      [ [ NSNotificationCenter defaultCenter ] postNotificationName: PFMenuItemBadgeValueDidChangeNotification
                                                             object: self ];
   }
}

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
