#import "PFChartViewController_iPad.h"
#import "PFSplitViewController.h"
#import "PFChoicesViewController.h"
#import "PFActionSheetButton.h"
#import "PFLoadingView.h"
#import "UIImage+PFTableView.h"

#import "PFChartPeriodTypeConversion.h"

@interface PFChartViewController_iPad ()

@property ( nonatomic, strong ) UIView< PFChartInfoView >* customInfoView;
@property ( nonatomic, assign ) BOOL fullScreenMode;

@end

@implementation PFChartViewController_iPad

@synthesize chartAreaView;
@synthesize infoImageView;
@synthesize chartImageView;
@synthesize rangeButtons;
@synthesize chartOnTop;
@synthesize ownedController;
@synthesize customInfoView;
@synthesize fullScreenMode = _fullScreenMode;

-(id)initWithSybol:( id< PFSymbol > )symbol_
       andInfoView:( UIView< PFChartInfoView >* )info_view_
{
   self = [ super initWithSymbol: symbol_ ];
   
   if ( self )
   {
      self.title = [ symbol_.name stringByAppendingFormat: @" %@", symbol_.overview ];
      self.customInfoView = info_view_;
   }
   
   return self;
}

-(void)viewDidLoad
{
   [ super viewDidLoad ];
   
   self.infoImageView.image = [ UIImage singleGroupedCellBackgroundImage ];
   self.chartImageView.image = [ UIImage singleGroupedCellBackgroundImage ];
   
   self.rangeButton.hidden = YES;
   NSArray* choises_ = @[ @(PFChartPeriodM1)
                          , @(PFChartPeriodM5)
                          , @(PFChartPeriodM15)
                          , @(PFChartPeriodM30)
                          , @(PFChartPeriodH1)
                          , @(PFChartPeriodH4)
                          , @(PFChartPeriodD1)
                          , @(PFChartPeriodW1)
                          , @(PFChartPeriodMN1)
                          ];
   int index_ = 0;
   for ( UIButton* range_button_ in self.rangeButtons )
   {
      range_button_.tag = [ choises_[index_++] integerValue ];
      
      [ range_button_ setTitle: NSStringFromPFChartPeriodType( (PFChartPeriodType)range_button_.tag )
                      forState: UIControlStateNormal ];
      
      if ( [ self.rangeButton.currentChoice integerValue ] == range_button_.tag )
      {
         range_button_.selected = YES;
      }
   }
   
   if ( self.chartOnTop )
   {
      CGRect chart_area_view_frame_ = self.chartAreaView.frame;
      chart_area_view_frame_.origin.y = 0.f;
      self.chartAreaView.frame = chart_area_view_frame_;
      self.chartAreaView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
      
      CGRect info_image_view_frame_ = self.infoImageView.frame;
      info_image_view_frame_.origin.y = chart_area_view_frame_.size.height;
      self.infoImageView.frame = info_image_view_frame_;
   }
   
   if ( self.customInfoView )
   {
      self.customInfoView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
      [ self.infoImageView addSubview: self.customInfoView ];
   }
}

-(void)setFullScreenMode:( BOOL )full_screen_mode_
{
   UIViewController* current_controller_ = self.ownedController ? self.ownedController : self;
   
   if ( [ current_controller_ isKindOfClass: [ PFChoicesViewController class ] ] && full_screen_mode_ )
   {
      [ (PFChoicesViewController*)current_controller_ setChoicesImageViewHidden: full_screen_mode_ ];
   }
   
   if ( [ current_controller_.splitViewController isKindOfClass: [ PFSplitViewController class ] ] )
   {
      _fullScreenMode = full_screen_mode_;
      [ self setIfoViewHidden: _fullScreenMode ];

      PFSplitViewController* split_controller_ = (PFSplitViewController*)current_controller_.splitViewController;
      split_controller_.masterControllerWidth = _fullScreenMode ? 0.f : 320.f;
      [ split_controller_.view setNeedsLayout ];
   }
   
   if ( [ current_controller_ isKindOfClass: [ PFChoicesViewController class ] ] && !full_screen_mode_ )
   {
      [ (PFChoicesViewController*)current_controller_ setChoicesImageViewHidden: full_screen_mode_ ];
   }
}

-(void)setIfoViewHidden:( BOOL )is_hidden_
{
   self.infoImageView.hidden = is_hidden_;
   CGRect chart_area_view_frame_ = self.chartAreaView.frame;
   chart_area_view_frame_.size.height += ( 10.f + self.infoImageView.frame.size.height ) * ( is_hidden_ ? 1 : -1 );
   
   if ( !self.chartOnTop )
   {
      chart_area_view_frame_.origin.y = is_hidden_ ? self.infoImageView.frame.origin.y - 10.f : self.infoImageView.frame.origin.y + self.infoImageView.frame.size.height;
   }
   
   self.chartAreaView.frame = chart_area_view_frame_;
}

-(void)timerUpdate
{
   [ super timerUpdate ];
   
   if ( !self.infoImageView.hidden  )
   {
      [ self.customInfoView updateDataByTimer ];
   }
}

-(void)showLoadingView
{
   [ self.loadingIndicator showInView: self.chartAreaView ];
}

-(BOOL)shouldHideNavigationBarForOrientation:( UIInterfaceOrientation )interface_orientation_
{
   return NO;
}

-(IBAction)fullScreenAction:( id )sender_
{
   self.fullScreenMode = !self.fullScreenMode;
   [ sender_ setSelected: self.fullScreenMode ];
}

-(IBAction)iPadRangeChangeAction:( id )sender_
{
   for ( UIButton* range_button_ in self.rangeButtons )
   {
      range_button_.selected = NO;
   }
   
   [ sender_ setSelected: YES ];
   self.rangeButton.currentChoice = @( [ sender_ tag ] );
}

@end
