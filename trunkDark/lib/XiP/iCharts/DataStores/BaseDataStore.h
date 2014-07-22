
#import <Foundation/Foundation.h>

@class ArrayMath;
@interface BaseDataStore : NSObject 
{
    NSMutableDictionary* dataSets;
    NSString* lastKey;    
}
-(void)SetVector:(ArrayMath*)v forKey:(NSString*)name;
-(ArrayMath*)GetVector:(NSString*)name;
-(uint)GetLength;
-(void)Clear;
@property (nonatomic, strong) NSMutableDictionary* dataSets;  
@property (nonatomic, strong) NSString* lastKey;  
@end
