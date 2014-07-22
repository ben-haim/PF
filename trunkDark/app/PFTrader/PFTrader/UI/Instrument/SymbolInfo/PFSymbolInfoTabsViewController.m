//
//  PFSymbolInfoTabsViewController.m
//  PFTrader
//
//  Created by Denis on 25.06.14.
//  Copyright (c) 2014 profinancesoft. All rights reserved.
//

#import "PFSymbolInfoTabsViewController.h"
#import "PFTabItem.h"
#import "PFSymbolInfoGroup.h"
#import "PFInfoTableViewController.h"

#import <ProFinanceApi/ProFinanceApi.h>
#import <JFF/Utils/NSArray+BlocksAdditions.h>

static NSString* nameForSymbolInfoGroup( id< PFSymbolInfoGroup > group_ )
{
   switch ( group_.groupType )
   {
      case PFSymbolInfoGroupTypeTrading:
         return NSLocalizedString( @"SYMBOL_INFO_GROUP_TRADING", nil );
         
      case PFSymbolInfoGroupTypeMargin:
         return NSLocalizedString( @"SYMBOL_INFO_GROUP_MARGIN", nil );
         
      case PFSymbolInfoGroupTypeFees:
         return NSLocalizedString( @"SYMBOL_INFO_GROUP_FEES", nil );
         
      case PFSymbolInfoGroupTypeSession:
         return NSLocalizedString( @"SYMBOL_INFO_GROUP_SESSION", nil );
         
      default:
         return NSLocalizedString( @"SYMBOL_INFO_GROUP_GENERAL", nil );
   }
}

@interface PFSymbolInfoTabsViewController () < PFSessionDelegate >

@property ( nonatomic, strong ) id< PFSymbol > symbol;
@property ( nonatomic, strong ) UIViewController* contentController;

@end

@implementation PFSymbolInfoTabsViewController

@synthesize symbol;
@synthesize contentController = _contentController;

-(void)dealloc
{
   [ [ PFSession sharedSession ] removeDelegate: self ];
}

-(id)initWithSymbol:( id< PFSymbol > )symbol_
{
   NSArray* items_ = [ [ PFSymbolInfoGroup groupsForSymbol: symbol_ ] map: ^id( id object_ )
                      {
                         PFSymbolInfoGroup* group_ = (PFSymbolInfoGroup*)object_;
                         return [ PFTabItem itemWithControllerBuilder: ^UIViewController*() { return [ PFInfoTableViewController controllerWithItems:[ group_ infoRows ] ]; }
                                                                title: nameForSymbolInfoGroup( group_ )
                                                                 icon: nil ];
                      } ];
   
   self = [ super initWithTabItems: items_
                  selectedTabIndex: 0 ];
   
   if ( self )
   {
      self.symbol = symbol_;
      self.title = [ self.symbol.name stringByAppendingFormat: @" %@", NSLocalizedString( @"SYMBOL_INFO", nil ) ];
   }
   
   return self;
}

-(void)viewDidLoad
{
   [ super viewDidLoad ];
   [ [ PFSession sharedSession ] addDelegate: self ];
}

-(void)updateTable
{
   [ (PFInfoTableViewController*)self.contentController updateTable ];
}

-(void)setContentController:(UIViewController *)content_controller_
{
   [ _contentController.view removeFromSuperview ];
   _contentController = nil;
   
   if ( content_controller_ )
   {
      _contentController = content_controller_;
      
      _contentController.view.frame = self.contentView.bounds;
      _contentController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
      [ _contentController.view removeFromSuperview ];
      [ self.contentView addSubview: _contentController.view ];
      [ self updateTable ];
   }
}

-(void)performActionWithItem:( PFTabItem* )item_
{
   [ super performActionWithItem: item_ ];
   
   self.contentController = item_.controller;
}

#pragma mark - PFSessionDelegate

-(void)session:( PFSession* )session_
didReceiveTradingHaltForSymbol:( id< PFSymbol > )symbol_
{
   [ self updateTable ];
}

@end
