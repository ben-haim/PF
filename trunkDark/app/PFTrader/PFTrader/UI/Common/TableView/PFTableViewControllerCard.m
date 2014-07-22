//
//  PFTableViewControllerCard.m
//  PFTrader
//
//  Created by Vit on 28.04.14.
//  Copyright (c) 2014 profinancesoft. All rights reserved.
//
#import "PFTableViewControllerCard.h"
#import "PFTableViewCard.h"

@implementation PFTableViewControllerCard

-(NSString*)nibName
{
   NSString* real_nib_name_ = [ super nibName ];

   return ![real_nib_name_ isEqual: @"PFTableViewController"] && real_nib_name_ ? real_nib_name_ : @"PFTableViewControllerCard";
}

-(BOOL)isAlignment
{
   return ((PFTableViewCard*)self.tableView).isAlignment;
}

-(UITableViewScrollPosition)scrollAlignmentPosition
{
   return ((PFTableViewCard*)self.tableView).scrollAlignmentPosition;
}

-(void)setIsAlignment:( BOOL )is_alignment_
{
   ((PFTableViewCard*)self.tableView).isAlignment = is_alignment_;
}

-(void)setScrollAlignmentPosition:( UITableViewScrollPosition )pos_
{
   ((PFTableViewCard*)self.tableView).scrollAlignmentPosition = pos_;
}

@end
