#import "PFGridFooterView.h"

#import "UIImage+PFGridView.h"
#import "UIColor+Skin.h"

@interface PFGridFooterView ()

@property ( nonatomic, strong, readonly ) UIView* fixedView;
@property ( nonatomic, strong, readonly ) UIButton* summaryButton;
@property ( nonatomic, strong, readonly ) UIPageControl* pageControl;

@end

@implementation PFGridFooterView

@synthesize summaryButton = _summaryButton;
@synthesize fixedView = _fixedView;
@synthesize pageControl = _pageControl;
@synthesize fixedWidth = _fixedWidth;
@synthesize summaryTitle = _summaryTitle;

@synthesize firstTitleLabel = _firstTitleLabel;
@synthesize firstValueLabel = _firstValueLabel;
@synthesize secondTitleLabel = _secondTitleLabel;
@synthesize secondValueLabel = _secondValueLabel;
@synthesize thirdTitleLabel = _thirdTitleLabel;
@synthesize thirdValueLabel = _thirdValueLabel;

@synthesize delegate;

@dynamic currentPage;
@dynamic numberOfPages;

-(UILabel*)createLabelWithIndex: (int)index_
{
   UILabel* label_ = [ UILabel new ];
   
   label_.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
   label_.frame = CGRectMake(self.fixedView.bounds.size.width + 5.0 + 100.0 * index_, 5.0, 95.0, 20.0);
   label_.font = [ UIFont systemFontOfSize: 12.0 ];
   label_.backgroundColor = [ UIColor clearColor ];
   label_.textColor = [ UIColor lightGrayColor ];
   
   [ self addSubview: label_ ];
   
   return label_;
}

-(UILabel*)firstTitleLabel
{
   if ( ! _firstTitleLabel )
   {
      _firstTitleLabel = [ self createLabelWithIndex: 0 ];
   }
   return _firstTitleLabel;
}

-(UILabel*)firstValueLabel
{
   if ( ! _firstValueLabel )
   {
      _firstValueLabel = [ self createLabelWithIndex: 1 ];
   }
   return _firstValueLabel;
}

-(UILabel*)secondTitleLabel
{
   if ( ! _secondTitleLabel )
   {
      _secondTitleLabel = [ self createLabelWithIndex: 2 ];
   }
   return _secondTitleLabel;
}

-(UILabel*)secondValueLabel
{
   if ( ! _secondValueLabel )
   {
      _secondValueLabel = [ self createLabelWithIndex: 3 ];
   }
   return _secondValueLabel;
}

-(UILabel*)thirdTitleLabel
{
   if ( ! _thirdTitleLabel )
   {
      _thirdTitleLabel = [ self createLabelWithIndex: 4 ];
   }
   return _thirdTitleLabel;
}

-(UILabel*)thirdValueLabel
{
   if ( ! _thirdValueLabel )
   {
      _thirdValueLabel = [ self createLabelWithIndex: 5 ];
   }
   return _thirdValueLabel;
}

-(UIView*)fixedView
{
   if ( !_fixedView )
   {
      _fixedView = [ UIView new ];
      _fixedView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
      _fixedView.backgroundColor = [ UIColor clearColor ];
      [ self addSubview: _fixedView ];
   }
   return _fixedView;
}

-(void)summaryAction:( id )sender_
{
   [ self.delegate didTapSummaryInFootterView: self ];
}

-(void)setSummaryButtonHidden:( BOOL )hidden_
{
   self.summaryButton.hidden = hidden_;
}

-(void)setPageControlHidden:( BOOL )hidden_
{
   self.pageControl.hidden = hidden_;
}

-(UIButton*)summaryButton
{
   if ( !_summaryButton )
   {
      _summaryButton = [ UIButton buttonWithType: UIButtonTypeCustom ];
      _summaryButton.frame = CGRectMake( 0.f, 0.0f, 24.f, 24.f );
      _summaryButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
      _summaryButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;

      [ _summaryButton setBackgroundImage: [ UIImage summaryButtonBackground ] forState: UIControlStateNormal ];

      [ _summaryButton setBackgroundImage: [ UIImage highlightedSummaryButtonBackground ] forState: UIControlStateHighlighted ];

      [ _summaryButton setTitleColor: [ UIColor mainTextColor ] forState: UIControlStateNormal ];

      _summaryButton.titleLabel.font = [ UIFont systemFontOfSize: 12.f ];

      [ _summaryButton addTarget: self
                          action: @selector( summaryAction: )
                forControlEvents: UIControlEventTouchUpInside ];

      [ self.fixedView addSubview: _summaryButton ];
   }
   return _summaryButton;
}

-(UIPageControl*)pageControl
{
   if ( !_pageControl )
   {
      _pageControl = [ [ UIPageControl alloc ] initWithFrame: self.bounds ];
      _pageControl.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

      [ _pageControl addTarget: self
                        action: @selector( didChangePage: )
              forControlEvents: UIControlEventValueChanged ];

      [ self addSubview: _pageControl ];
   }
   return _pageControl;
}

-(NSUInteger)currentPage
{
   return self.pageControl.currentPage;
}

-(void)setCurrentPage:( NSUInteger )current_page_
{
   self.pageControl.currentPage = current_page_;
}

-(NSUInteger)numberOfPages
{
   return self.pageControl.numberOfPages;
}

-(void)setNumberOfPages:( NSUInteger )number_of_pages_
{
   self.pageControl.numberOfPages = number_of_pages_;
}

-(void)setFixedWidth:( CGFloat )fixed_width_
{
   CGRect fixed_rect_ = CGRectZero;
   CGRect page_control_rect_ = CGRectZero;

   CGRectDivide( self.bounds
                , &fixed_rect_
                , &page_control_rect_
                , fixed_width_
                , CGRectMinXEdge );

   self.fixedView.frame = fixed_rect_;
   self.pageControl.frame = page_control_rect_;
   self.summaryButton.center = CGPointMake( CGRectGetMidX( fixed_rect_ ), CGRectGetMidY( fixed_rect_ ) );

   _fixedWidth = fixed_width_;
}

-(void)setSummaryTitle:( NSString* )summary_title_
{
   [ self.summaryButton setTitle: summary_title_ forState: UIControlStateNormal ];
   _summaryTitle = summary_title_;
}

-(void)didChangePage:( UIPageControl* )page_control_
{
   [ self.delegate footterView: self
                 didSelectPage: self.currentPage ];
}

@end
