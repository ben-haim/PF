//
//  InterLineOverlappingColorLayer.h
//  XiP
//
//  Created by Alexandros Ioannou on 3/23/12.
//  Copyright (c) 2012 Xogee. All rights reserved.
//

#import "BaseBoxLayer.h"
@class LineLayer;
@interface InterLineOverlappingColorLayer : BaseBoxLayer
{
    NSString* mSpanAData;
    NSString* mSpanBData;
    uint fillAlpha;
    uint mSpanAColor;
    uint mSpanBColor;
    uint linewidth;
    uint linedash;
}
- (id)initWithDataStore:(BaseDataStore*)_DataStore 
            ParentChart:(XYChart*)_parentChart
              SpanAData:(NSString*)spanAData
              SpanBData:(NSString*)spanBData 
              LayerName:(NSString*)_layerName
                SpanAColor:(uint)spanAColor
                SpanBColor:(uint)spanBColor
              FillAlpha:(uint)_alpha
              LineWidth:(uint)line_width
               LineDash:(uint)line_dash; 

-(void)setSpanAColor:(uint)spanAColor AndSpanBColor:(uint)spanBColor AndFillColor:(uint)_fillAlpha;

@property (nonatomic, retain) NSString* mSpanAData; 
@property (nonatomic, retain) NSString* mSpanBData;
@property (assign) uint fillAlpha;
@property (assign) uint mSpanAColor;
@property (assign) uint mSpanBColor;
@property (assign) uint linewidth;
@property (assign) uint linedash;

@end
