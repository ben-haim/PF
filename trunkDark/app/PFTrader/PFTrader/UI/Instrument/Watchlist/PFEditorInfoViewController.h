//
//  PFEditorInfoViewController.h
//  PFTrader
//
//  Created by Denis on 29.06.14.
//  Copyright (c) 2014 profinancesoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PFInstrumentGroup;
@protocol PFWatchlist;

@interface PFEditorInfoViewController : UITableViewController

-(id)initWithInstrumentGroup:( id< PFInstrumentGroup > )group_
                   watchlist:( id< PFWatchlist > )watchlist_;
-(void)updateTable;

@end
