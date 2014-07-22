#import "PFTextField.h"

#import "UIImage+Skin.h"
#import "UIColor+Skin.h"

@implementation PFTextField

-(void)prepareWithBackground:( UIImage* )image_
{
   self.backgroundColor = [ UIColor clearColor ];
   self.borderStyle = UITextBorderStyleNone;
   self.background = image_;
   self.font = [ UIFont boldSystemFontOfSize: 17.f ];
   self.textColor = [ UIColor colorWithWhite: 0.4f alpha: 1.f ];
   self.autocorrectionType = UITextAutocorrectionTypeNo;
   self.autocapitalizationType = UITextAutocapitalizationTypeNone;
   self.clearButtonMode = UITextFieldViewModeAlways;
}

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

-(CGRect)clearButtonRectForBounds:( CGRect )bounds_
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
