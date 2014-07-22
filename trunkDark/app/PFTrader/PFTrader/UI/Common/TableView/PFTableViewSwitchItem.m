#import "PFTableViewSwitchItem.h"

#import "PFTableViewSwitchItemCell.h"

#import "PFSwitch.h"

@interface PFTableViewSwitchItem ()

@property ( nonatomic, assign ) BOOL on;
@property ( nonatomic, copy ) PFTableViewSwitchItemAction switchAction;

@end

@implementation PFTableViewSwitchItem

@synthesize on;
@synthesize onText;
@synthesize offText;

@synthesize switchAction;

+(id)switchItemWithTitle:( NSString* )title_
                    isOn:( BOOL )is_on_
            switchAction:( PFTableViewSwitchItemAction )action_
{
   //NSAssert( action_, @"switchAction should be initialized" );
   PFTableViewSwitchItem* switch_item_ = [ self itemWithAction: nil title: title_ ];
   switch_item_.on = is_on_;
   switch_item_.switchAction = action_;
   switch_item_.onText = NSLocalizedString( @"ON", nil );
   switch_item_.offText = NSLocalizedString( @"OFF", nil );
   return switch_item_;
}

-(Class)cellClass
{
   return [ PFTableViewSwitchItemCell class ];
}

-(void)switchToOn:( BOOL )on_
{
   if ( on_ == self.on )
      return;

   self.on = on_;

   if ( self.switchAction )
      self.switchAction( self );
}

@end
