#import <UIKit/UIKit.h>

@protocol PFSegmentedControlDelegate;

@interface PFSegmentedControl : UIImageView

@property ( nonatomic, assign ) NSInteger selectedSegmentIndex;
@property ( nonatomic, assign, readonly ) NSUInteger numberOfSegments;
@property ( nonatomic, weak ) IBOutlet id< PFSegmentedControlDelegate > delegate;

@property ( nonatomic, strong ) UIFont* font;

-(id)initWithItems:( NSArray* )items_;
-(id)initWithButtons:( NSArray* )buttons_;

-(void)setItems:( NSArray* )items_;
-(void)setButtons:( NSArray* )buttons_;

@end

@protocol PFSegmentedControlDelegate <NSObject>

-(void)segmentedControl:( PFSegmentedControl* )segmented_control_
   didSelectItemAtIndex:( NSInteger )index_;

@end
