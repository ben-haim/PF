//
//  PFSymbolInfoTabsViewController.h
//  PFTrader
//
//  Created by Denis on 25.06.14.
//  Copyright (c) 2014 profinancesoft. All rights reserved.
//

#import "PFTabsViewController.h"

@protocol PFSymbol;

@interface PFSymbolInfoTabsViewController : PFTabsViewController

-(id)initWithSymbol:( id< PFSymbol > )symbol_;

@end
