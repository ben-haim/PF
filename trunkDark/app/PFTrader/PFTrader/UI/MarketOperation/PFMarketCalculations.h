//
//  PFTableViewMarketOperationsItemCell.h
//  PFTrader
//
//  Created by Vit on 30.04.14.
//  Copyright (c) 2014 profinancesoft. All rights reserved.
//
#import "PFTableViewItemCell.h"

@protocol PFMarketOperation;
@protocol PFTrade;
@protocol PFOrder;

@interface PFMarketCalculations : NSObject

+(NSString*)getSideWithMarketOperation:( id< PFMarketOperation > )operation_;
+(NSString*)getBoughtWithOrder:( id< PFOrder > )order_;
+(NSString*)getSoldWithOrder:( id< PFOrder > )order_;
+(NSString*)getBoughtWithTrade:( id< PFTrade > )trade_;
+(NSString*)getSoldWithTrade:( id< PFTrade > )trade_;

@end
