

#import <Foundation/Foundation.h>
#import "BaseBoxLayer.h"


@interface LineLayer : BaseBoxLayer 
{
    uint subtype;
    uint linewidth;
    uint linedash;
}
@property (assign) uint subtype;
@property (assign) uint linewidth;
@property (assign) uint linedash;
@end
