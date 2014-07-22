#import "PFChartViewController.h"

@protocol PFChartInfoView;
@protocol PFSymbol;

@interface PFChartViewController_iPad : PFChartViewController

@property ( nonatomic, weak ) IBOutlet UIView* chartAreaView;
@property ( nonatomic, weak ) IBOutlet UIImageView* infoImageView;
@property ( nonatomic, weak ) IBOutlet UIImageView* chartImageView;
@property ( nonatomic, strong ) IBOutletCollection( UIButton ) NSArray* rangeButtons;

@property ( nonatomic, assign ) BOOL chartOnTop;
@property ( nonatomic, weak ) UIViewController* ownedController;

-(id)initWithSybol:( id< PFSymbol > )symbol_
       andInfoView:( UIView< PFChartInfoView >* )info_view_;

-(IBAction)fullScreenAction:( id )sender_;
-(IBAction)iPadRangeChangeAction:( id )sender_;

@end

@protocol PFChartInfoView < NSObject >

-(void)updateDataByTimer;

@end
