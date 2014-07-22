
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HLOCLayer.h"

@interface CandleStickLayer : HLOCLayer 
{
    UIColor* color_up;
    UIColor* color_down;
    UIColor* color_up_border;
    UIColor* color_down_border;
}
- (id)initWithDataStore:(BaseDataStore*)_DataStore ParentChart:(XYChart*)_parentChart;
@property (nonatomic, retain) UIColor* color_up;
@property (nonatomic, retain) UIColor* color_down;
@property (nonatomic, retain) UIColor* color_up_border;
@property (nonatomic, retain) UIColor* color_down_border;
@property (nonatomic, retain) UIColor* color_null_border;
@end
