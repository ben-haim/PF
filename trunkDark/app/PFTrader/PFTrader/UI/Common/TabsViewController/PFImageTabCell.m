//
//  PFImageTabCell.m
//  PFTrader
//
//  Created by Denis on 03.06.14.
//  Copyright (c) 2014 profinancesoft. All rights reserved.
//

#import "PFImageTabCell.h"

@implementation PFImageTabCell

@synthesize counterLabel;
@synthesize imageView;
@synthesize titleLabel;
@synthesize tabItem = _tabItem;

+(id)cell
{
   PFImageTabCell* cell_ = [ super cell ];
   cell_.useEmptyOffset = YES;
   
   return cell_;
}

- (void)awakeFromNib
{
   [ super awakeFromNib ];
}

-(void)setTabItem:( PFTabItem* )tab_item_
{
   _tabItem = tab_item_;
   
   self.counterLabel.text = _tabItem.badgeValue == 0 ? @"" : [ NSString stringWithFormat: @"%d", _tabItem.badgeValue ];
   self.imageView.image = _tabItem.icon;
   self.titleLabel.text = _tabItem.title;
}

@end
