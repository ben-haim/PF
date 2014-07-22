//
//  TAOrderLevel.h
//  XiP
//
//  Created by Xogee MacBook on 25/07/2011.
//  Copyright 2011 Xogee. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TAOrderLevel : NSObject 
{
    uint order_no;
    uint cmd;
    double price;
    BOOL isOrder;
}
@property (assign) uint order_no;
@property (assign) uint cmd;
@property (assign) double price;
@property (assign) BOOL isOrder;
@end
