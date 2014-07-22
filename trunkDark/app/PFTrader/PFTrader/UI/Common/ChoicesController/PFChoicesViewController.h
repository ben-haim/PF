//
//  PFChoicesViewController.h
//  PFTrader
//
//  Created by Denis on 18.06.14.
//  Copyright (c) 2014 profinancesoft. All rights reserved.
//

#import "PFViewController.h"

@class PFSegmentedControl;

@interface PFChoicesViewControllerSource : NSObject

@property ( nonatomic, strong, readonly ) NSString* title;
@property ( nonatomic, strong, readonly ) UIViewController* controller;

+(id)sourceWithTitle:( NSString* )title_
          controller:( UIViewController* )controller_;

@end

@interface PFChoicesViewController : PFViewController

@property ( nonatomic, weak ) IBOutlet UIImageView* choicesImageView;
@property ( nonatomic, weak ) IBOutlet PFSegmentedControl* choicesControl;
@property ( nonatomic, weak ) IBOutlet UIView* contentView;

+(id)choicesControllerWithSources:( NSArray* )sources_
                            title:( NSString* )title_;

-(void)setChoicesImageViewHidden:( BOOL )hidden_;

@end
