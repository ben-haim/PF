//
//  TAChannel.h
//  XiP
//
//  Created by Xogee MacBook on 07/07/2011.
//  Copyright 2011 Xogee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TAObject.h"
#import "TAAnchor.h"


@interface TAChannel : TAObject 
{

}
-(id)initWithParentChart:(XYChart*)_parentChart 
                   AndX1:(int)x1_index 
                   AndX2:(int)x2_index 
                   AndX3:(int)x3_index 
                   AndY1:(double)y1  
                   AndY2:(double)y2  
                   AndY3:(double)y3  
                AndColor:(uint)_color
            AndLineWidth:(uint)_linewidth 
             AndLineDash:(uint)_linedash;
-(TAAnchor*)get_a4;
@end
