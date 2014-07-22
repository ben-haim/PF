
#import <Foundation/Foundation.h>
#import "BaseBoxLayer.h"

@interface HLOCLayer : BaseBoxLayer 
{
    uint bar_color;
    uint bar_line_width;
    uint bar_color_up;
    uint bar_color_down;
}
- (id)initWithDataStore:(BaseDataStore*)_DataStore ParentChart:(XYChart*)_parentChart;

@property (assign) uint bar_color;
@property (assign) uint bar_line_width;
@property (assign) uint bar_color_up;
@property (assign) uint bar_color_down;

@end
