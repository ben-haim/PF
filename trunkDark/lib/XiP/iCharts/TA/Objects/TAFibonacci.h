//
//  TAFibonacci.h
//  XiP
//
//  Created by Xogee MacBook on 04/07/2011.
//  Copyright 2011 Xogee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TAObject.h"

@interface TAFibonacci : TAObject 
{
    
}
-(id)initWithParentChart:(XYChart*)_parentChart 
                   AndX1:(int)x1_index 
                   AndX2:(int)x2_index 
                   AndY1:(double)y1  
                   AndY2:(double)y2  
                AndColor:(uint)_color
            AndLineWidth:(uint)_linewidth 
             AndLineDash:(uint)_linedash;
-(CGPoint)getP1;
-(CGPoint)getP2;

@end
