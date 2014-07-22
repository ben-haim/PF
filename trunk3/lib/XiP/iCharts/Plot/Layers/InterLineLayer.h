

#import <Foundation/Foundation.h>
#import "BaseBoxLayer.h"
@class LineLayer;

@interface InterLineLayer : BaseBoxLayer 
{
    NSString* srcField1;
    NSString* srcField2;
    uint linecolor;
    uint fillAlpha;
    uint color12;
    uint color21;
    uint linewidth;
    uint linedash;
    double clip_level;
    bool clipAbove;
    bool mustClip;
}
- (id)initWithDataStore:(BaseDataStore*)_DataStore 
            ParentChart:(XYChart*)_parentChart
              SrcField1:(NSString*)_srcField1
              SrcField2:(NSString*)_srcField2 
              LayerName:(NSString*)_layerName
              LineColor:(uint)_linecolor
                Color12:(uint)_color12
                Color21:(uint)_color21
              FillAlpha:(uint)_alpha
              LineWidth:(uint)line_width
               LineDash:(uint)line_dash; 

@property (nonatomic, retain) NSString* srcField1; 
@property (nonatomic, retain) NSString* srcField2;
@property (assign) uint fillAlpha;
@property (assign) uint color12;
@property (assign) uint color21;
@property (assign) uint linecolor;
@property (assign) uint linewidth;
@property (assign) uint linedash;

@property (assign) double clip_level;
@property (assign) bool clipAbove;
@property (assign) bool mustClip;
@end
