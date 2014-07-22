//
//  PFEditorInfoViewController.m
//  PFTrader
//
//  Created by Denis on 29.06.14.
//  Copyright (c) 2014 profinancesoft. All rights reserved.
//

#import "PFEditorInfoViewController.h"
#import "PFWatchlistEditorSymbolCell.h"
#import "UIColor+Skin.h"

#import <ProFinanceApi/ProFinanceApi.h>

@interface PFEditorInfoViewController ()

@property ( nonatomic, strong ) id< PFInstrumentGroup > grop;
@property ( nonatomic, strong ) id< PFWatchlist > watchlist;
@property ( nonatomic, strong ) NSArray* sortedSymbols;

@end

@implementation PFEditorInfoViewController

@synthesize grop;
@synthesize watchlist;
@synthesize sortedSymbols;

-(id)initWithInstrumentGroup:( id< PFInstrumentGroup > )group_
                   watchlist:( id< PFWatchlist > )watchlist_
{
   self = [ super initWithStyle: UITableViewStylePlain ];
   
   if ( self )
   {
      self.grop = group_;
      self.watchlist = watchlist_;
      [ self updateSymbolsOrder ];
   }
   
   return self;
}

-(void)viewDidLoad
{
   [ super viewDidLoad ];
   
   self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
   self.view.backgroundColor = [ UIColor backgroundLightColor ];
}

-(void)updateSymbolsOrder
{
   self.sortedSymbols = [ self.grop.symbols sortedArrayUsingComparator:^NSComparisonResult( id first_symbol_, id second_symbol_ )
                         {
                            if ( [ self.watchlist containsSymbol: first_symbol_ ] && [ self.watchlist containsSymbol: second_symbol_ ] )
                            {
                               return [ [ first_symbol_ name ] compare: [ second_symbol_ name ] ];
                            }
                            else if ( ![ self.watchlist containsSymbol: first_symbol_ ] && ![ self.watchlist containsSymbol: second_symbol_ ] )
                            {
                               return [ [ first_symbol_ name ] compare: [ second_symbol_ name ] ];
                            }
                            else if ( [ self.watchlist containsSymbol: first_symbol_ ] && ![ self.watchlist containsSymbol: second_symbol_ ] )
                            {
                               return NSOrderedAscending;
                            }
                            else
                            {
                               return NSOrderedDescending;
                            }
                         } ];
}

-(void)updateTable
{
   [ self updateSymbolsOrder ];
   [ self.tableView reloadData ];
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:( UITableView* )table_view_ numberOfRowsInSection:( NSInteger )section_
{
   return self.sortedSymbols.count;
}

-(UITableViewCell*)tableView:( UITableView* )table_view_ cellForRowAtIndexPath:( NSIndexPath* )index_path_
{
   PFWatchlistEditorSymbolCell* symbol_cell_ = [ table_view_ dequeueReusableCellWithIdentifier: @"PFWatchlistEditorSymbolCell" ];
   
   if ( !symbol_cell_ )
   {
      symbol_cell_ = [ PFWatchlistEditorSymbolCell cell ];
   }
   
   id< PFSymbol > symbol_ = [ self.sortedSymbols objectAtIndex: index_path_.row ];
   [ symbol_cell_ setSymbol: symbol_
                  watchlist: self.watchlist ];
   
   return symbol_cell_;
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:( UITableView* )table_view_ heightForRowAtIndexPath:( NSIndexPath* )index_path_
{
   return 60.f;
}

@end
