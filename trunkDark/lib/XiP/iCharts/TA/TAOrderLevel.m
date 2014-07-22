//
//  TAOrderLevel.m
//  XiP
//
//  Created by Xogee MacBook on 25/07/2011.
//  Copyright 2011 Xogee. All rights reserved.
//

#import "TAOrderLevel.h"


@implementation TAOrderLevel
@synthesize order_no, cmd, price, isOrder;

- (id)init
{
    self = [super init];
    if (self) 
    {
       self.isOrder = YES;
    }
    
    return self;
}


@end
