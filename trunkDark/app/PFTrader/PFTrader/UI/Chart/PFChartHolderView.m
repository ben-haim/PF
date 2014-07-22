#import "PFChartHolderView.h"

#import "FinanceChart.h"

@interface PFChartHolderView ()

@property ( nonatomic, assign ) BOOL buttonsMode;

@end

@implementation PFChartHolderView

@synthesize portraiteHolderView;
@synthesize chartView;
@synthesize financeChart;

@synthesize buttonsMode;

//-(void)layoutSubviews
//{
//   if( self.buttonsMode )
//   {
//      self.buttonsMode = NO;
//      return;
//   }
//   
//   BOOL is_landscape_ = self.frame.size.width > self.frame.size.height;
//   UIView* holder_view_ = is_landscape_ ? self : self.portraiteHolderView;
//   
//   self.financeChart.showButtonsBlock = !is_landscape_ ? nil : ^()
//   {
//      self.buttonsMode = YES;
//      
//      UIView* buttons_view_ = [ self.portraiteHolderView.subviews containsObject: self.chartView ] ? self : self.portraiteHolderView;
//
//      self.chartView.frame = buttons_view_.bounds;
//      [ buttons_view_ addSubview: self.chartView ];
//      [ self.chartView layoutIfNeeded ];
//   };
//   
//   self.chartView.frame = holder_view_.bounds;
//   self.chartView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//   [ holder_view_ addSubview: self.chartView ];
//}

@end
