//
//  PFAccountSpeedometr.h
//  PFTrader
//
//  Created by Vit on 13.05.14.
//  Copyright (c) 2014 profinancesoft. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface PFAccountSpeedometr : UIView

-(void)redrawWithPositiveValue:(double) pos_
              andNegativeValue:(double) neg_;

+(UIColor *)gradientImageWithLabel:( UILabel* )label_
                          andColor:( UIColor* )color_;

@end
