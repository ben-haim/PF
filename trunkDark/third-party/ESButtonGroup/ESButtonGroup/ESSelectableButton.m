#import "ESSelectableButton.h"

#import "ESSelectableButtonDelegate.h"

@implementation ESSelectableButton

@synthesize userInfo;
@synthesize delegate;

-(void)selectButton
{
   self.highlighted = NO;
   if ( !self.selected )
   {
      self.selected = YES;
      [ self.delegate buttonDidChangeState: self ];
   }
}

-(void)onAction:( id )sender_
{
   if ( ![ self.delegate disableChangeStateForButton: self ] )
   {
      [ self selectButton ];
   }
}

-(void)onDownAction:( id )sender_
{
   self.highlighted = NO;
}

-(void)addActionHandle
{
   [ self addTarget: self
             action: @selector( onAction: )
   forControlEvents: UIControlEventTouchUpInside ];

    [ self addTarget: self
              action: @selector( onDownAction: )
    forControlEvents: UIControlEventTouchDown | UIControlEventTouchDragInside ];
}

-(void)awakeFromNib
{
   [ self addActionHandle ];
}

+(id)selectableButton
{
   ESSelectableButton* button_ = [ self buttonWithType: UIButtonTypeCustom ];

   [ button_ addActionHandle ];

   return button_;
}

@end
