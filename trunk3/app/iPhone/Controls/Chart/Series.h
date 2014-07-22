
#import <Foundation/Foundation.h>


@interface Series : NSObject 
{

}
-(void)SetData:(NSString*)data;
-(int)GetCount;
-(void)Draw:(CGContextRef)context OnRect:(CGRect)rect DrawGrid:(BOOL)drawGrid AndOffset:(double)deltaX AndCount:(double)items;

@end
