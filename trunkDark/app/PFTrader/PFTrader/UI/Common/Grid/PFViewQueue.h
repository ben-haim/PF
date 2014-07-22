#import <Foundation/Foundation.h>

@interface PFViewQueue : NSObject

-(void)enqueueView:( UIView* )view_
    withIdentifier:( NSString* )identifier_;

-(UIView*)dequeueViewWithIdentifier:( NSString* )identifier_;

@end
