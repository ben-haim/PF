//
//  PFTabsViewController.h
//  PFTrader
//
//  Created by Denis on 03.06.14.
//  Copyright (c) 2014 profinancesoft. All rights reserved.
//

#import "PFViewController.h"

@class PFTabItem;

@interface PFTabsViewController : PFViewController

@property ( nonatomic, weak ) IBOutlet UITableView* tabsTableView;
@property ( nonatomic, weak ) IBOutlet UIView* contentView;
@property ( nonatomic, weak ) IBOutlet UIView* separatorView;
@property ( nonatomic, weak ) IBOutlet UIView* bottomTabsView;
@property ( nonatomic, weak ) IBOutlet UIImageView* headerView;

@property ( nonatomic, strong, readonly ) NSArray* tabItems;

-(id)initWithTabItems:( NSArray* )tab_items_
     selectedTabIndex:( NSUInteger )selected_tab_index_;

-(void)updateWithTabItems:( NSArray* )tab_items_;
-(void)performActionWithItem:( PFTabItem* )item_;
-(void)useRemoveAllButton:( BOOL )use_;
-(void)useHeaderView:( BOOL )use_;

-(IBAction)removeAllAction:( id )sender_;

@end
