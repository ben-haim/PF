

#import <Foundation/Foundation.h>


@interface LegendKey : NSObject 
{
    NSString *key;
    NSString *text;
    uint color1;
    uint color2;    
}
- (id)initWithKey:(NSString*)_legendKeyString color1:(uint)_legendColor color2:(uint)_legendColor2;
@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *text;
@property (assign) uint color1;
@property (assign) uint color2;

@end
