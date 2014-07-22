//
//  ToolbarButtonDraw.h
//  XiP
//
//  Created by Xogee MacBook on 09/06/2011.
//  Copyright 2011 Xogee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "../Plot/Utils.h"
#import "ToolbarDefines.h"
#import "ToolbarButtonSegment.h"

@class ToolbarButton;
@interface ToolbarButtonDraw : CALayer 
{
    ToolbarButton* btn;
}
-(id)initWithButton:(ToolbarButton*)_btn AndScale:(float)scale;
- (struct HitTestInfo)drawInternal:(CGContextRef)ctx orHitTest:(BOOL)isHittest forPoint:(CGPoint)where;
@property (assign) ToolbarButton* btn;
@end
