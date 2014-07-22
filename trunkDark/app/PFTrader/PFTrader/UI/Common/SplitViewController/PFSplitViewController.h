//
//  PFSplitViewController.h
//  PFTrader
//
//  Created by Denis on 08.06.14.
//  Copyright (c) 2014 profinancesoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PFSplitViewController : UISplitViewController

@property ( nonatomic, assign ) CGFloat masterControllerWidth;

-(id)initWithMasterController:( UIViewController* )master_controller_;
-(void)showDetailController:( UIViewController* )detail_controller_;

@end
