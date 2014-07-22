#import <UIKit/UIKit.h>

@protocol PFGridFooterViewDelegate;

@interface PFGridFooterView : UIView

@property ( nonatomic, assign ) NSUInteger currentPage;
@property ( nonatomic, assign ) NSUInteger numberOfPages;

@property ( nonatomic, assign ) CGFloat fixedWidth;
@property ( nonatomic, strong ) NSString* summaryTitle;

@property ( nonatomic, assign ) id< PFGridFooterViewDelegate > delegate;

@property ( nonatomic, strong, readonly ) UILabel* firstTitleLabel;
@property ( nonatomic, strong, readonly ) UILabel* firstValueLabel;
@property ( nonatomic, strong, readonly ) UILabel* secondTitleLabel;
@property ( nonatomic, strong, readonly ) UILabel* secondValueLabel;
@property ( nonatomic, strong, readonly ) UILabel* thirdTitleLabel;
@property ( nonatomic, strong, readonly ) UILabel* thirdValueLabel;

-(void)setSummaryButtonHidden:( BOOL )hidden_;
-(void)setPageControlHidden:( BOOL )hidden_;

@end

@protocol PFGridFooterViewDelegate< NSObject >

-(void)footterView:( PFGridFooterView* )footer_view_
     didSelectPage:( NSUInteger )page_;

-(void)didTapSummaryInFootterView:( PFGridFooterView* )footer_view_;

@end
