//
//  PFTableViewCard.m
//  PFTrader
//
//  Created by Vit on 28.04.14.
//  Copyright (c) 2014 profinancesoft. All rights reserved.
//
#import "PFTableViewCard.h"
#import "PFTableViewItem.h"

@interface PFTableViewCard ()

@property (nonatomic, assign) Class oldItemClass;

@end

@implementation PFTableViewCard

@synthesize oldItemClass;

@synthesize isAlignment;
@synthesize scrollAlignmentPosition;
@synthesize tableView = _tableView;

-(void)tableView:( UITableView* )table_view_
didSelectRowAtIndexPath:( NSIndexPath* )index_path_
{
   [ table_view_ deselectRowAtIndexPath: index_path_ animated: NO ];

   PFTableViewItem* item_ = [ self itemAtIndexPath: index_path_ ];

   if (oldItemClass != [ (id)item_.cell class ] )
   {
      [ table_view_ reloadSections: [ NSIndexSet indexSetWithIndex: index_path_.section ] withRowAnimation: UITableViewRowAnimationFade ];
      [ item_ performAction ];
      [ table_view_ reloadSections: [ NSIndexSet indexSetWithIndex: index_path_.section ] withRowAnimation: UITableViewRowAnimationFade ];
   }
   else
   {
      [ item_ performAction ];
   }

   if (self.isAlignment)
      [ table_view_ scrollToRowAtIndexPath: index_path_ atScrollPosition: self.scrollAlignmentPosition animated: YES ];

   self.oldItemClass = [(id)[ self itemAtIndexPath: index_path_ ].cell class];
}

-(UITableView *)tableView
{
   if ( !_tableView )
   {
      self.isAlignment = YES;
      self.scrollAlignmentPosition = UITableViewScrollPositionMiddle;
   }
   return _tableView = [super tableView];
}

@end
