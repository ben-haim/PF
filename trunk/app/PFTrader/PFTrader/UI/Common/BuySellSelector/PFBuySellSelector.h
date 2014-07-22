#import <UIKit/UIKit.h>

@protocol PFBuySellSelectorDelegate;

@interface PFBuySellSelector : UIView

@property ( nonatomic, assign ) BOOL buy;

@property ( nonatomic, weak ) IBOutlet id< PFBuySellSelectorDelegate > delegate;

@end

@protocol PFBuySellSelectorDelegate <NSObject>

-(void)buySellSelector:( PFBuySellSelector* )selector_
          didSelectBuy:( BOOL )buy_;

@end
