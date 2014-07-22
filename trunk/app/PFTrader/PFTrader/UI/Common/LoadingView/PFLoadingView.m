#import "PFLoadingView.h"

@interface PFLoadingView ()

@property ( nonatomic, strong, readonly ) UIActivityIndicatorView* activityView;

@end

@implementation PFLoadingView

@synthesize indicatorStyle;
@synthesize activityView = _activityView;

-(id)initWithFrame:(CGRect)frame
{
   self = [super initWithFrame:frame];
   if (self)
   {
      self.indicatorStyle = UIActivityIndicatorViewStyleWhite;
      self.backgroundColor = [ UIColor colorWithWhite: 0.f alpha: 0.7f ];
   }
   return self;
}

-(UIActivityIndicatorView*)activityView
{
   if ( !_activityView )
   {
      _activityView = [ [ UIActivityIndicatorView alloc ] initWithActivityIndicatorStyle: self.indicatorStyle ];
      
      _activityView.hidesWhenStopped = YES;
      
      _activityView.center = self.center;
      
      _activityView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin
      | UIViewAutoresizingFlexibleRightMargin
      | UIViewAutoresizingFlexibleTopMargin
      | UIViewAutoresizingFlexibleBottomMargin;
      
      [ self addSubview: _activityView ];
   }
   
   return _activityView;
}

-(void)showInView:( UIView* )view_
{
   self.frame = view_.bounds;
   self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
   [ self.activityView startAnimating ];
   [ view_ addSubview: self ];
}

-(void)hide
{
   [ self removeFromSuperview ];
   [ self.activityView stopAnimating ];
}

@end
