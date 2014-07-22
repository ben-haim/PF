#import "PFSegmentedLayout.h"

@implementation PFSegmentedLayout

@synthesize segmentsCount;

-(void)addSubview:( UIView* )subview_
{
   CGFloat segment_width_ = self.bounds.size.width / self.segmentsCount;

   NSUInteger segment_index_ = [ self.subviews count ];

   subview_.frame = CGRectMake( segment_width_ * segment_index_, 0.f, segment_width_, self.bounds.size.height );
   subview_.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;

   [ super addSubview: subview_ ];
}

@end
