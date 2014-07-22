#import <UIKit/UIKit.h>

@interface PFComponentDivider : NSObject

@property ( nonatomic, strong, readonly ) NSString* stringValue;
@property ( nonatomic, assign, readonly ) double doubleValue;
@property ( nonatomic, assign, readonly ) NSUInteger componentsCount;

+(id)dividerWithDouble:( double )double_
             precision:( NSUInteger )precision_;

-(NSUInteger)maximumValueForComponentWithIndex:( NSUInteger )index_;

-(NSUInteger)currentRowForComponentWithIndex:( NSUInteger )index_;

-(void)setCurrentRow:( NSUInteger )current_row_
forComponentWithIndex:( NSUInteger )index_;

-(NSString*)valueForRow:( NSUInteger )row_
  forComponentWithIndex:( NSUInteger )index_;

@end
