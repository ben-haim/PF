//
//  PFTableViewCategory+AccountCards.h
//  PFTrader
//
//  Created by Denis on 19.06.14.
//  Copyright (c) 2014 profinancesoft. All rights reserved.
//

#import "PFTableViewCategory.h"

@interface PFTableViewCategory (AccountCards)

+(NSArray*)accountCardsCategoriesWithAccounts:( NSArray* )accounts_
                                   controller:( UIViewController* )controller_;

@end
