//
//  PFTabItem.m
//  PFTrader
//
//  Created by Denis on 03.06.14.
//  Copyright (c) 2014 profinancesoft. All rights reserved.
//

#import "PFTabItem.h"

NSString* const PFMenuItemBadgeValueDidChangeNotification = @"PFMenuItemBadgeValueDidChangeNotification";

@interface PFTabItem ()

@property ( nonatomic, strong ) Class controllerClass;
@property ( nonatomic, copy ) PFMenuItemControllerBuilder builder;
@property ( nonatomic, copy ) PFMenuItemAction action;
@property ( nonatomic, strong ) UIViewController* controller;

@end

@implementation PFTabItem

@synthesize title;
@synthesize icon;
@synthesize badgeValue = _badgeValue;
@synthesize controllerClass;
@synthesize builder;
@synthesize controller = _controller;
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
   PFTabItem* item_ = [ [ self alloc ] initWithTitle: title_
                                                icon: icon_ ];
   
   item_.controllerClass = controller_class_;
   
   return item_;
}

+(id)itemWithController:( UIViewController* )controller_
                   icon:( UIImage* )icon_
{
   PFTabItem* item_ = [ [ self alloc ] initWithTitle: controller_.title
                                                icon: icon_ ];
   
   item_.controller = controller_;
   
   return item_;
}

+(id)itemWithControllerBuilder:( PFMenuItemControllerBuilder )builder_
                         title:( NSString* )title_
                          icon:( UIImage* )icon_
{
   PFTabItem* item_ = [ [ self alloc ] initWithTitle: title_
                                                icon: icon_ ];
   
   item_.builder = builder_;
   
   return item_;
}

+(id)itemWithAction:( PFMenuItemAction )action_
              title:( NSString* )title_
               icon:( UIImage* )icon_
{
   PFTabItem* item_ = [ [ self alloc ] initWithTitle: title_
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

@end
