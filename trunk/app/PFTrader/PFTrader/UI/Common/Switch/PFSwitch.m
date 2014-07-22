#import "PFSwitch.h"

#import "UIImage+PFSwitch.h"
#import "PFSystemHelper.h"

@interface PFSwitchSlider : UISlider

@property ( nonatomic, assign ) BOOL on;
@property ( nonatomic, strong, readonly ) UIView* clippingView;
@property ( nonatomic, strong, readonly ) UILabel* offLabel;
@property ( nonatomic, strong, readonly ) UILabel* onLabel;

@end

static CGFloat PFSwitchMarginX = 4.f;
static CGFloat PFSwitchMarginY = 2.f;

@implementation PFSwitchSlider

@synthesize on = _on;
@synthesize clippingView = _clippingView;
@synthesize onLabel = _onLabel;
@synthesize offLabel = _offLabel;

-(UIView*)clippingView
{
   if ( !_clippingView )
   {
      _clippingView = [ [ UIView alloc ] initWithFrame: CGRectMake( PFSwitchMarginX
                                                                   , PFSwitchMarginY
                                                                   , self.frame.size.width - 2*PFSwitchMarginX
                                                                   , self.frame.size.height - 2*PFSwitchMarginY ) ];
      
      _clippingView.clipsToBounds = YES;
      _clippingView.userInteractionEnabled = NO;
      _clippingView.backgroundColor = [ UIColor clearColor ];
   }
   return _clippingView;
}

-(UILabel*)switchLabel
{
   UILabel* label_ = [ UILabel new ];
   label_.textAlignment = NSTextAlignmentCenter;
   label_.font = [ UIFont boldSystemFontOfSize: 12.f ];
   label_.backgroundColor = [ UIColor clearColor ];
   label_.shadowColor = [ UIColor colorWithWhite: 0.4f alpha: 1.f ];
   label_.shadowOffset = CGSizeMake( 0.f, -1.f );
   return label_;
}

-(UILabel*)onLabel
{
   if ( !_onLabel )
   {
      _onLabel = [ self switchLabel ];
      _onLabel.text = NSLocalizedString( @"ON", nil );
      _onLabel.textColor = [ UIColor whiteColor ];
   }
   return _onLabel;
}

-(UILabel*)offLabel
{
   if ( !_offLabel )
   {
      _offLabel = [ self switchLabel ];
      _offLabel.text = NSLocalizedString( @"OFF", nil );
      _offLabel.textColor = [ UIColor colorWithWhite: 0.7f alpha: 1.f ];
   }
   return _offLabel;
}

-(void)touchEnd
{
   BOOL on_ = self.value > 0.5f;

   [ self setOn: on_ animated: YES ];
   [ self sendActionsForControlEvents: UIControlEventApplicationReserved ];
}

-(void)tap
{
   [ self setOn: !self.on animated: YES ];
   [ self sendActionsForControlEvents: UIControlEventApplicationReserved ];
}

-(void)applySkinning
{
   self.backgroundColor = [ UIColor clearColor ];

   [ self setThumbImage: [ UIImage switchThumbImage ] forState: UIControlStateNormal ];
   [ self setThumbImage: [ UIImage switchThumbImage ] forState: UIControlStateHighlighted ];

   [ self setMinimumTrackImage: [ UIImage switchOnBackground ] forState: UIControlStateNormal ];
   [ self setMaximumTrackImage: [ UIImage switchOffBackground ] forState: UIControlStateNormal ];

   self.minimumValue = 0.f;
   self.maximumValue = 1.f;
   self.continuous = NO;
   
   self.on = NO;

   [ self addSubview: self.clippingView ];
   [ self.clippingView addSubview: self.onLabel ];
   [ self.clippingView addSubview: self.offLabel ];
   [ self updateLabelPositions ];
   
   [ self addTarget: self
             action: @selector( touchEnd )
   forControlEvents: UIControlEventTouchUpInside | UIControlEventTouchUpOutside ];

   UITapGestureRecognizer* tap_recognizer_ = [ [ UITapGestureRecognizer alloc ] initWithTarget: self
                                                                                      action: @selector( tap ) ];

   [ self addGestureRecognizer: tap_recognizer_ ];
}

-(void)updateLabelPositions
{
   CGFloat thumb_width_ = self.currentThumbImage.size.width;
   CGFloat switch_width_ = self.bounds.size.width;
   CGFloat label_width_ = switch_width_ - thumb_width_;
   CGFloat inset_ = self.clippingView.frame.origin.x;

   CGFloat on_x_ = self.value * label_width_ - label_width_;// - inset_;
   self.onLabel.frame = CGRectMake(on_x_, 0.f, label_width_, self.frame.size.height - 2*PFSwitchMarginY );

   CGFloat off_x_ = switch_width_ + ( self.value * label_width_ - label_width_ ) - inset_ * 2;
   self.offLabel.frame = CGRectMake( off_x_, 0, label_width_, self.frame.size.height - 2*PFSwitchMarginY );
}

-(id)initWithFrame:( CGRect )frame_
{
   self = [ super initWithFrame: frame_ ];

   if ( self )
   {
      [ self applySkinning ];
   }

   return self;
}

-(void)awakeFromNib
{
   [ super awakeFromNib ];
   [ self applySkinning ];
}

-(void)layoutSubviews
{
   [ super layoutSubviews ];

   [ self bringSubviewToFront: self.clippingView ];
   [ self updateLabelPositions ];
}

-(void)setOn:( BOOL )on_ animated:( BOOL )animated_
{
   if ( animated_ )
   {
      [ UIView beginAnimations: nil context: nil ];
      [ UIView setAnimationDuration: 0.2 ];
   }
   
   _on = on_;
   self.value = _on ? 1.0 : 0.0;
   
   if ( animated_ )
   {
      [ UIView	commitAnimations ];
   }
}

-(void)setOn:( BOOL )on_
{
   [ self setOn: on_ animated: NO ];
}

@end

@interface PFSwitch ()

@property ( nonatomic, strong, readonly ) PFSwitchSlider* slider;

@end


@implementation PFSwitch

@synthesize slider = _slider;

-(PFSwitchSlider*)slider
{
   if ( !_slider )
   {
      CGRect bounds_ = self.bounds;
      
      if ( useFlatUI() )
      {
         bounds_.origin.x -= 4;
         bounds_.origin.y -= 4;
         bounds_.size.width += 4;
         bounds_.size.height += 4;
      }

      _slider = [ [ PFSwitchSlider alloc ] initWithFrame: bounds_ ];
      _slider.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
   }
   return _slider;
}

-(NSString*)offText
{
   return self.slider.offLabel.text;
}

-(void)setOffText:( NSString* )off_text_
{
   self.slider.offLabel.text = off_text_;
}

-(NSString*)onText
{
   return self.slider.onLabel.text;
}

-(void)setOnText:( NSString* )on_text_
{
   self.slider.onLabel.text = on_text_;
}

-(BOOL)isOn
{
   return self.slider.on;
}

-(void)setOn:( BOOL )on_
{
   self.slider.on = on_;
}

-(void)setOn:( BOOL )on_ animated:( BOOL )animated_
{
   [ self.slider setOn: on_ animated: animated_ ];
}

-(void)valueChanged
{
   [ self sendActionsForControlEvents: UIControlEventValueChanged ];
}

-(void)awakeFromNib
{
   self.backgroundColor = [ UIColor clearColor ];
   [ self addSubview: self.slider ];

   [ self.slider addTarget: self
                    action: @selector( valueChanged )
          forControlEvents: UIControlEventApplicationReserved ];
}

#pragma mark UIResponder

-(BOOL)canBecomeFirstResponder
{
   return [ self.slider canBecomeFirstResponder ];
}

-(BOOL)becomeFirstResponder
{
   return [ self.slider becomeFirstResponder ];
}

-(BOOL)isFirstResponder
{
   return [ self.slider isFirstResponder ];
}

-(BOOL)resignFirstResponder
{
   return [ self.slider resignFirstResponder ];
}

@end
