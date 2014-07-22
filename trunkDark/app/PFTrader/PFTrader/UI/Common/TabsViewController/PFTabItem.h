//
//  PFTabItem.h
//  PFTrader
//
//  Created by Denis on 03.06.14.
//  Copyright (c) 2014 profinancesoft. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* const PFMenuItemBadgeValueDidChangeNotification;

typedef UIViewController* (^PFMenuItemControllerBuilder)();
typedef void (^PFMenuItemAction)();

@interface PFTabItem : NSObject

@property ( nonatomic, strong ) NSString* title;
@property ( nonatomic, strong ) UIImage* icon;
@property ( nonatomic, strong, readonly ) UIViewController* controller;
@property ( nonatomic, assign ) NSUInteger badgeValue;

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
