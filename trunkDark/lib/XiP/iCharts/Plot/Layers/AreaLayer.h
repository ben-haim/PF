

#import <Foundation/Foundation.h>
#import "BaseBoxLayer.h"


@interface AreaLayer : BaseBoxLayer 
{
    uint fillcolor;
    uint linecolor;
    uint linewidth;
    uint linedash;
}
@property (assign) uint fillcolor;
@property (assign) uint linecolor;
@property (assign) uint linewidth;
@property (assign) uint linedash;
@end
