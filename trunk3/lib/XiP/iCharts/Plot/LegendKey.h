

#import <Foundation/Foundation.h>


@interface LegendKey : NSObject 
{
    NSString *key;
    NSString *text;
    uint color1;
    uint color2;    
}
- (id)initWithKey:(NSString*)_legendKeyString color1:(uint)_legendColor color2:(uint)_legendColor2;
@property (nonatomic, retain) NSString *key;
@property (nonatomic, retain) NSString *text;
@property (assign) uint color1;
@property (assign) uint color2;

@end
