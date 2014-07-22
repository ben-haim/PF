//
//  TAVLine.h
//  XiP
//
//  Created by Xogee MacBook on 08/07/2011.
//  Copyright 2011 Xogee. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TAObject.h"



@interface TAVLine : TAObject 
{
    NSDateFormatter* dateformatter;  
}
-(id)initWithParentChart:(XYChart*)_parentChart 
                   AndX1:(int)x1_index 
                   AndY1:(double)y1  
                AndColor:(uint)_color
            AndLineWidth:(uint)_linewidth 
             AndLineDash:(uint)_linedash;
-(TAAnchor*)get_a2;
@property (nonatomic, strong) NSDateFormatter* dateformatter;
@end

