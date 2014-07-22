//
//  PFWatchlistInstrumentEditorViewController.h
//  PFTrader
//
//  Created by Denis on 29.06.14.
//  Copyright (c) 2014 profinancesoft. All rights reserved.
//

#import "PFTabsViewController.h"

@protocol PFWatchlist;

@interface PFWatchlistInstrumentEditorViewController : PFTabsViewController

-(id)initWithWatchlist:( id< PFWatchlist > )watchlist_;

@end
