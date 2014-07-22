//
//  PFInfoTableViewController.m
//  PFTrader
//
//  Created by Denis on 25.06.14.
//  Copyright (c) 2014 profinancesoft. All rights reserved.
//

#import "PFInfoTableViewController.h"
#import "PFSymbolInfoCell.h"
#import "PFSymbolInfoCell_iPad.h"
#import "PFSymbolInfoRow.h"
#import "UIColor+Skin.h"

@interface PFInfoTableViewController ()

@property ( nonatomic, strong ) NSArray* items;

@end

@implementation PFInfoTableViewController

@synthesize items;

+(id)controllerWithItems:( NSArray* )items_
{
   PFInfoTableViewController* controller_ = [ [ PFInfoTableViewController alloc ] initWithStyle: UITableViewStylePlain ];
   controller_.items = items_;
   
   return controller_;
}

-(void)viewDidLoad
{
   [ super viewDidLoad ];
   
   self.view.backgroundColor = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? [ UIColor backgroundDarkColor ] : [ UIColor backgroundLightColor ];
   self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(void)updateTable
{
   [ self.tableView reloadData ];
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:( UITableView*)table_view_ numberOfRowsInSection:( NSInteger )section_
{
   return self.items.count;
}


-(UITableViewCell*)tableView:( UITableView*)table_view_ cellForRowAtIndexPath:( NSIndexPath* )index_path_
{
   PFSymbolInfoCell* symbol_info_cell_ = [ table_view_ dequeueReusableCellWithIdentifier: @"PFSymbolInfoCell" ];
   
   if ( !symbol_info_cell_ )
   {
      symbol_info_cell_ = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? [ PFSymbolInfoCell_iPad cell ] : [ PFSymbolInfoCell cell ];
   }
   
   id< PFSymbolInfoRow > info_row_ = [ self.items objectAtIndex: index_path_.row ];
   [ symbol_info_cell_ setName: info_row_.name
                      andValue: info_row_.value ];
   
   return symbol_info_cell_;
}

@end
