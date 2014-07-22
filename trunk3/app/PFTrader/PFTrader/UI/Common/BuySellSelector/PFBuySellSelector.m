#import "PFBuySellSelector.h"

#import "PFSegmentedControl.h"

#import "UIImage+PFBuySellSelector.h"

#import <ESButtonGroup/ESButtonGroup.h>

@interface ESSelectableButton (PFBuySellSelector)

+(id)sellButton;
+(id)buyButton;

@end

@implementation ESSelectableButton (PFBuySellSelector)

+(id)marketButtonWithTitle:( NSString* )title_
                background:( UIImage* )image_
        selectedBackground:( UIImage* )selected_image_
{
   ESSelectableButton* selectable_button_ = [ ESSelectableButton selectableButton ];
   
   [ selectable_button_ setTitleColor: [ UIColor whiteColor ] forState: UIControlStateSelected ];
   [ selectable_button_ setTitleColor: [ UIColor colorWithWhite: 0.65f alpha: 1.f ] forState: UIControlStateNormal ];
   
   [ selectable_button_ setTitle: title_ forState: UIControlStateNormal ];
   [ selectable_button_ setBackgroundImage: image_ forState: UIControlStateNormal ];
   [ selectable_button_ setBackgroundImage: selected_image_ forState: UIControlStateSelected ];

   selectable_button_.titleLabel.shadowColor = [ UIColor clearColor ];
   selectable_button_.titleLabel.shadowOffset = CGSizeMake( 0.f, 0.f );

   return selectable_button_;
}

+(id)sellButton
{
   return [ self marketButtonWithTitle: NSLocalizedString( @"SELL", nil )
                            background: [ UIImage sellButtonBackground ]
                    selectedBackground: [ UIImage selectedSellButtonBackground ] ];
}

+(id)buyButton
{
   return [ self marketButtonWithTitle: NSLocalizedString( @"BUY", nil )
                            background: [ UIImage buyButtonBackground ]
                    selectedBackground: [ UIImage selectedBuyButtonBackground ] ];
}

@end

enum
{
   PFSellButtonIndex
   , PFBuyButtonIndex
};

@interface PFBuySellSelector ()< PFSegmentedControlDelegate >

@property ( nonatomic, strong, readonly ) PFSegmentedControl* segmentedControl;

@end

@implementation PFBuySellSelector

@synthesize segmentedControl = _segmentedControl;
@synthesize delegate;

-(PFSegmentedControl*)segmentedControl
{
   if ( !_segmentedControl )
   {
      _segmentedControl = [ [ PFSegmentedControl alloc ] init ];
      
      _segmentedControl.font = [ UIFont boldSystemFontOfSize: 17.f ];
      _segmentedControl.buttons = [ NSArray arrayWithObjects: [ ESSelectableButton sellButton ]
                                   , [ ESSelectableButton buyButton ]
                                   , nil ];

      _segmentedControl.selectedSegmentIndex = PFSellButtonIndex;
      _segmentedControl.frame = self.bounds;
      _segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
      _segmentedControl.delegate = self;
   }
   return _segmentedControl;
}

-(void)awakeFromNib
{
   self.backgroundColor = [ UIColor clearColor ];
   [ self addSubview: self.segmentedControl ];
}

-(void)setBuy:( BOOL )buy_
{
   self.segmentedControl.selectedSegmentIndex = buy_ ? PFBuyButtonIndex : PFSellButtonIndex;
}

-(BOOL)buy
{
   return self.segmentedControl.selectedSegmentIndex == PFBuyButtonIndex;
}

#pragma mark PFSegmentedControlDelegate

-(void)segmentedControl:( PFSegmentedControl* )segmented_control_
   didSelectItemAtIndex:( NSInteger )index_
{
   [ self.delegate buySellSelector: self didSelectBuy: self.buy ];
}

@end
