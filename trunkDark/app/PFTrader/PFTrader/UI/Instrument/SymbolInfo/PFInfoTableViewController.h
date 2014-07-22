//
//  PFInfoTableViewController.h
//  PFTrader
//
//  Created by Denis on 25.06.14.
//  Copyright (c) 2014 profinancesoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PFInfoTableViewController : UITableViewController

+(id)controllerWithItems:( NSArray* )items_;
-(void)updateTable;

@end
