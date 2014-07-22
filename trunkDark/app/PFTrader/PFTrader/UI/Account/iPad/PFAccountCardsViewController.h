//
//  PFAccountCardsViewController.h
//  PFTrader
//
//  Created by Denis on 19.06.14.
//  Copyright (c) 2014 profinancesoft. All rights reserved.
//

#import "PFTableViewControllerCard.h"

@protocol PFAccount;
@protocol PFAccountCardsViewControllerDelegate;

@interface PFAccountCardsViewController : PFTableViewControllerCard

@property ( nonatomic, strong ) id< PFAccount > selectedAccount;
@property ( nonatomic, weak ) id< PFAccountCardsViewControllerDelegate > delegate;

@end

@protocol PFAccount;

@protocol PFAccountCardsViewControllerDelegate < NSObject >

-(void)accountCardsViewController:( PFAccountCardsViewController* )controller_
                 didSelectAccount:( id< PFAccount > )account_;

@end

