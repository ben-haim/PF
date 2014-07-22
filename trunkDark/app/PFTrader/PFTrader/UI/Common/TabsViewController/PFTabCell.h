//
//  PFTabCell.h
//  PFTrader
//
//  Created by Denis on 03.06.14.
//  Copyright (c) 2014 profinancesoft. All rights reserved.
//

#import "PFTabItem.h"

@protocol PFTabCell < NSObject >

-(PFTabItem*)tabItem;
-(void)setTabItem:( PFTabItem* )tab_item_;

@end
