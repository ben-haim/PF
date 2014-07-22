#import "PFSwitch.h"

@interface PFSwitch ()

@property ( nonatomic, strong ) UIButton* switchButton;

@end

@implementation PFSwitch

@synthesize on = _on;
@synthesize switchButton;

-(void)awakeFromNib
{
   [ super awakeFromNib ];
   
   self.backgroundColor = [ UIColor clearColor ];
   self.switchButton = [ [ UIButton alloc ] initWithFrame: CGRectMake( 2.f, 2.f ,26.f ,26.f ) ];
   
   [ self.switchButton setBackgroundImage:[ UIImage imageNamed: @"PFSwitchOff" ] forState: UIControlStateNormal ];
   [ self.switchButton setBackgroundImage: [ UIImage imageNamed: @"PFSwitchOn" ] forState: UIControlStateSelected ];
   [ self.switchButton setBackgroundImage: [ UIImage imageNamed: @"PFSwitchOn" ] forState: UIControlStateHighlighted ];
   self.switchButton.adjustsImageWhenHighlighted = YES;
   [ self.switchButton addTarget: self
                          action: @selector( switchAction )
                forControlEvents: UIControlEventTouchDown ];
   [ self addSubview: self.switchButton ];
}

-(BOOL)isOn
{
   return self.on;
}

-(void)setOn:( BOOL )on_
{
   if ( _on != on_ )
   {
      _on = on_;
      self.switchButton.selected = _on;
      [ self sendActionsForControlEvents: UIControlEventValueChanged ];
   }
}

-(void)switchAction
{
   self.on = !self.on;
}

@end
