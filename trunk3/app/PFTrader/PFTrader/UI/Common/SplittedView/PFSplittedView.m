#import "PFSplittedView.h"

#import "UIImage+PFSplittedView.h"

#import "PFSettings.h"

static CGFloat PFSplitterViewHeight = 34.f;

@interface PFSplittedView ()

@property ( nonatomic, strong ) UIView* topPlaceholderView;
@property ( nonatomic, strong ) UIView* bottomPlaceholderView;

@property ( nonatomic, strong ) UIView* splitterView;

@end

@implementation PFSplittedView

@synthesize topPlaceholderView;
@synthesize bottomPlaceholderView;

@synthesize topView = _topView;
@synthesize bottomView = _bottomView;

@synthesize splitterView = _splitterView;

@synthesize topPart = _topPart;

@synthesize state = _state;

-(void)splitterMove:( UIPanGestureRecognizer* )gesture_
{
   CGFloat top_panel_height_ = [ gesture_ locationInView: self ].y;
   CGFloat content_height_ = ( CGRectGetMaxY( self.bounds ) - PFSplitterViewHeight );

   self.topPart = top_panel_height_ / content_height_;
}

-(UIView*)splitterView
{
   if ( !_splitterView )
   {
      _splitterView = [ UIView new ];
      _splitterView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin
      | UIViewAutoresizingFlexibleBottomMargin
      | UIViewAutoresizingFlexibleWidth;

      UIImageView* background_ = [ [ UIImageView alloc ] initWithImage: [ UIImage splitterBackground ] ];
      background_.frame = _splitterView.bounds;
      background_.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
      [ _splitterView addSubview: background_ ];

      UIImageView* icon_ = [ [ UIImageView alloc ] initWithImage: [ UIImage splitterImage ] ];
      icon_.frame = _splitterView.bounds;
      icon_.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
      icon_.contentMode = UIViewContentModeCenter;
      [ _splitterView addSubview: icon_ ];
   }

   return _splitterView;
}

-(id)initWithFrame:( CGRect )frame_
{
   self = [ super initWithFrame: frame_ ];
   if ( self )
   {
      UIPanGestureRecognizer* splitter_gesture_ = [ [ UIPanGestureRecognizer alloc] initWithTarget: self
                                                                                            action: @selector( splitterMove: )];

      [ self.splitterView addGestureRecognizer: splitter_gesture_ ];

      self.topPlaceholderView = [ UIView new ];
      self.topPlaceholderView.backgroundColor = [ UIColor clearColor ];
      self.topPlaceholderView.autoresizingMask = UIViewAutoresizingFlexibleHeight
      | UIViewAutoresizingFlexibleBottomMargin
      | UIViewAutoresizingFlexibleWidth;

      self.bottomPlaceholderView = [ UIView new ];
      self.bottomPlaceholderView.backgroundColor = [ UIColor clearColor ];
      self.bottomPlaceholderView.autoresizingMask = UIViewAutoresizingFlexibleHeight
      | UIViewAutoresizingFlexibleTopMargin
      | UIViewAutoresizingFlexibleWidth;

      [ self addSubview: self.splitterView ];
      [ self addSubview: self.bottomPlaceholderView ];
      [ self addSubview: self.topPlaceholderView ];

      self.topPart = [ PFSettings sharedSettings ].splitterTopPart;
      self.state = [ PFSettings sharedSettings ].splitterState;
   }
   return self;
}

-(CGFloat)contentHeightWithBounds:( CGRect )bounds_
{
   return fmax( CGRectGetMaxY( bounds_ ) - PFSplitterViewHeight, 0.f );
}

-(CGFloat)topHeightWithBounds:( CGRect )bounds_
{
   if ( self.state == PFSplittedViewStateTopFullscreen )
      return CGRectGetMaxY( bounds_ );

   return self.topPart * [ self contentHeightWithBounds: bounds_ ];
}

-(CGFloat)bottomHeightWithBounds:( CGRect )bounds_
{
   if ( self.state == PFSplittedViewStateBottomFullscreen )
      return CGRectGetMaxY( bounds_ );

   return ( 1.f - self.topPart ) * [ self contentHeightWithBounds: bounds_ ];
}

-(void)updateLayoutWithBounds:( CGRect )bounds_
{
   if ( self.state == PFSplittedViewStateTopFullscreen )
   {
      [ self bringSubviewToFront: self.topPlaceholderView ];
      self.splitterView.alpha = 0.f;
      self.bottomPlaceholderView.alpha = 0.f;
      self.topPlaceholderView.alpha = 1.f;
      self.topPlaceholderView.frame = bounds_;
   }
   else if ( self.state == PFSplittedViewStateBottomFullscreen )
   {
      [ self bringSubviewToFront: self.bottomPlaceholderView ];
      self.splitterView.alpha = 0.f;
      self.topPlaceholderView.alpha = 0.f;
      self.bottomPlaceholderView.alpha = 1.f;
      self.bottomPlaceholderView.frame = bounds_;
   }
   else
   {
      self.splitterView.alpha = 1.f;
      self.topPlaceholderView.alpha = 1.f;
      self.bottomPlaceholderView.alpha = 1.f;

      CGFloat top_panel_height_ = [ self topHeightWithBounds: bounds_ ];
      CGFloat bottom_panel_height_ = [ self bottomHeightWithBounds: bounds_ ];

      self.splitterView.frame = CGRectMake( 0.f, top_panel_height_, bounds_.size.width, PFSplitterViewHeight );

      self.topPlaceholderView.frame = CGRectMake( 0.f, 0.f, bounds_.size.width, top_panel_height_ );

      self.bottomPlaceholderView.frame = CGRectMake( 0.f, PFSplitterViewHeight + top_panel_height_, bounds_.size.width, bottom_panel_height_ );
   }
}

-(void)updateLayout
{
   [ self updateLayoutWithBounds: self.bounds ];
}

-(void)setTopPart:( CGFloat )top_part_
{
   static CGFloat min_part_ = 0.25f;

   if ( top_part_ < min_part_ || ( 1.f - top_part_ ) < min_part_ )
      return;

   _topPart = top_part_;
   
   [ PFSettings sharedSettings ].splitterTopPart = _topPart;
   [ [ PFSettings sharedSettings ] save ];

   [ self updateLayout ];
}

-(void)setFrame:( CGRect )rect_
layoutImmediately:( BOOL )layout_
{
   self.frame = rect_;
   [ self updateLayoutWithBounds: CGRectMake( 0.f, 0.f, rect_.size.width, rect_.size.height ) ];
}

-(void)setTopView:( UIView* )view_
{
   [ _topView removeFromSuperview ];
   view_.frame = self.topPlaceholderView.bounds;
   view_.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
   _topView = view_;
   [ self.topPlaceholderView addSubview: _topView ];
}

-(void)setBottomView:( UIView* )view_
{
   [ _bottomView removeFromSuperview ];
   view_.frame = self.bottomPlaceholderView.bounds;
   view_.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
   _bottomView = view_;
   [ self.bottomPlaceholderView addSubview: _bottomView ];
}

-(void)setState:( PFSplittedViewState )state_
{
   _state = state_;
   [ PFSettings sharedSettings ].splitterState = _state;
   [ [ PFSettings sharedSettings ] save ];
   [ self updateLayout ];
}

-(void)setState:( PFSplittedViewState )state_ animated:( BOOL )animated_
{
   if ( state_ == _state )
      return;

   BOOL animation_enabled_ = [ UIView areAnimationsEnabled ];
   if ( !animated_ )
   {
      [ UIView setAnimationsEnabled: NO ];
   }

   [ UIView animateWithDuration: 0.3
                     animations: ^{ self.state = state_; } ];

   if ( !animated_ )
   {
      [ UIView setAnimationsEnabled: animation_enabled_ ];
   }
}

-(void)layoutSubviews
{
   [ self updateLayout ];
}

@end
