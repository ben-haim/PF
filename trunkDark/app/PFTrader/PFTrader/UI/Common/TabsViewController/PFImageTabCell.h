//
//  PFImageTabCell.h
//  PFTrader
//
//  Created by Denis on 03.06.14.
//  Copyright (c) 2014 profinancesoft. All rights reserved.
//

#import "PFTableViewCell.h"
#import "PFTabCell.h"

@interface PFImageTabCell : PFTableViewCell < PFTabCell >

@property ( nonatomic, weak ) IBOutlet UILabel* counterLabel;
@property ( nonatomic, weak ) IBOutlet UIImageView* imageView;
@property ( nonatomic, weak ) IBOutlet UILabel* titleLabel;
@property ( nonatomic, strong ) PFTabItem* tabItem;

@end
