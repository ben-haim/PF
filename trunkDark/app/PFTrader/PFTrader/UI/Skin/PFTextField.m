#import "PFTextField.h"
#import "UIImage+Skin.h"
#import "UIColor+Skin.h"

@implementation PFTextField

@synthesize backgroundMode = _backgroundMode;

-(id)initWithFrame:( CGRect )frame_
        background:( UIImage* )background_
{
   self = [ super initWithFrame: frame_ ];
   if ( self )
   {
      [ self prepareWithBackground: background_ ];
   }
   return self;
}

-(id)initWithFrame:( CGRect )frame_
{
   return [ self initWithFrame: frame_
                    background: [ UIImage textFieldBackground ] ];
}

-(void)awakeFromNib
{
   [ self prepareWithBackground: [ UIImage textFieldBackground ] ];
   [ super awakeFromNib ];
}

-(void)prepareWithBackground:( UIImage* )image_
{
   self.backgroundColor = [ UIColor clearColor ];
   self.borderStyle = UITextBorderStyleNone;
   self.background = image_;
   self.font = [ UIFont systemFontOfSize: 17.f ];
   self.textColor = [ UIColor mainTextColor ];
   self.autocorrectionType = UITextAutocorrectionTypeNo;
   self.autocapitalizationType = UITextAutocapitalizationTypeNone;
   self.clearButtonMode = UITextFieldViewModeNever;
   
   UIButton* clear_button_ = [ [ UIButton alloc ] initWithFrame: CGRectMake( 0.f, 0.f, 20.f, 20.f ) ];
   [ clear_button_ setImage: [ UIImage imageNamed: @"PFCloseButtonModal" ] forState: UIControlStateNormal ];
   [ clear_button_ addTarget: self
                      action: @selector( doClear )
            forControlEvents: UIControlEventTouchUpInside ];
   
   self.rightView = clear_button_;
   self.rightViewMode = UITextFieldViewModeAlways;
   
   if ( self.placeholder )
   {
      self.attributedPlaceholder = [ [ NSAttributedString alloc ] initWithString: self.placeholder
                                                                      attributes: @{ NSForegroundColorAttributeName: [ UIColor grayTextColor ] } ];
   }
}

-(void)doClear
{
   self.text = @"";
   [ self sendActionsForControlEvents: UIControlEventEditingChanged ];
}

-(void)setBackgroundMode:( PFTextFieldBackgroundMode )background_mode_
{
   _backgroundMode = background_mode_;
   
   self.background = background_mode_ == PFTextFieldBackgroundModeSingle ?
   [ UIImage textFieldBackground ] :
   ( background_mode_ == PFTextFieldBackgroundModeTop ? [ UIImage textFieldTopBackground ] : [ UIImage textFieldBottomBackground ] );
   
}

-(CGFloat)textFieldLeftOffset
{
   return 10.f;
}

-(CGFloat)textFieldRightOffset
{
   return 10.f;
}

-(CGFloat)clearButtonWidth
{
   return 20.f;
}

-(CGFloat)textFieldTopOffset
{
   return 0.f;
}

-(CGRect)textRectForBounds:( CGRect )bounds_
{
   CGRect text_rect_ = bounds_;
   text_rect_.origin.y += [ self textFieldTopOffset ];
   text_rect_.origin.x += [ self textFieldLeftOffset ];
   
   text_rect_.size.width -= ( [ self clearButtonWidth ]
                             + [ self textFieldLeftOffset ]
                             + [ self textFieldRightOffset ] );
   
   return text_rect_;
}

-(CGRect)editingRectForBounds:( CGRect )bounds_
{
   return [ self textRectForBounds: bounds_ ];
}

-(CGRect)rightViewRectForBounds:( CGRect )bounds_
{
   CGRect button_rect_ = bounds_;
   button_rect_.size.width = [ self clearButtonWidth ];
   button_rect_.origin.x = bounds_.size.width
   - [ self clearButtonWidth ]
   - [ self textFieldRightOffset ];
   
   return button_rect_;
}

@end

@implementation PFSearchField

-(CGFloat)textFieldLeftOffset
{
   return self.leftView.frame.size.width;
}

-(CGRect)leftViewRectForBounds:( CGRect )bounds_
{
   return CGRectMake( 0.f, 0.f, bounds_.size.height, bounds_.size.height );
}

-(void)prepareWithBackground:( UIImage* )image_
{
   UIImageView* search_icon_ = [ [ UIImageView alloc ] initWithImage: [ UIImage searchFieldIcon ] ];
   search_icon_.contentMode = UIViewContentModeCenter;
   self.leftView = search_icon_;
   self.leftViewMode = UITextFieldViewModeAlways;
   [ super prepareWithBackground: image_ ];
}

@end
