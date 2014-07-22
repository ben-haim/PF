
#import <Foundation/Foundation.h>


@interface ArrayMath : NSObject 
{
    double* data;
    int length;
    int capacity;
}
-(id)initWithArray:(NSMutableArray*)src;
-(id)initWithLength:(uint)len;
-(uint)getLength;
-(double*)getData;
-(void)addElement:(double)elem;


-(ArrayMath*)add:(ArrayMath*)v;
-(ArrayMath*)sub:(ArrayMath*)v;
-(ArrayMath*)sub2:(double)a2;
-(ArrayMath*)mul:(ArrayMath*)v;
-(ArrayMath*)mul2:(double)a2;
-(ArrayMath*)div:(ArrayMath*)v;
-(ArrayMath*)safeDiv:(ArrayMath*)v AndStub:(double)stub;
-(ArrayMath*)acc;
-(double)min;
-(double)max;
-(double)min2:(uint)start AndLength:(uint)len;
-(double)max2:(uint)start AndLength:(uint)len;
-(ArrayMath*)trim:(uint)start AndLength:(uint)new_length;
-(ArrayMath*)abs;
-(ArrayMath*)delta:(int)shift;
-(ArrayMath*)shiftRight:(int)period;
-(ArrayMath*)selectGT:(ArrayMath*)v AndStub:(double)stub;
-(ArrayMath*)selectEQZ:(ArrayMath*)v AndStub:(double)stub;
-(ArrayMath*)selectLTZ:(double)stub;
-(ArrayMath*)selectGTZ:(double)stub;
-(ArrayMath*)movMin:(uint)period;
-(ArrayMath*)movMax:(uint)period;
-(ArrayMath*)movAvg:(uint)period;
-(ArrayMath*)movAvgRsi:(uint)period;
-(ArrayMath*)expAvg:(double)k;
-(ArrayMath*)movStdDev:(uint)period;
@end
