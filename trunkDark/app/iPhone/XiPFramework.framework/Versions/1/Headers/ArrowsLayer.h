
#import "BaseBoxLayer.h"

@interface ArrowsLayer : BaseBoxLayer
{
    NSString* mUpData;
    NSString* mDownData;
    uint mUpArrowsColor;
    uint mDownArrowsColor;
}

@property (nonatomic, retain) NSString* mUpData; 
@property (nonatomic, retain) NSString* mDownData;
@property (assign) uint mUpArrowsColor;
@property (assign) uint mDownArrowsColor;

- (id)initWithDataStore:(BaseDataStore*)_DataStore 
            ParentChart:(XYChart*)_parentChart
              UpData:(NSString*)upData
              DownData:(NSString*)downData 
              LayerName:(NSString*)_layerName
                UpArrowsColor:(uint)upArrowsColor
                DownArrowsColor:(uint)downArrowsColor;

@end
