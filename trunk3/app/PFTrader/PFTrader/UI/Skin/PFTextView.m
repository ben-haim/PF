#import "PFTextView.h"

#import "UIImage+Skin.h"
#import "UIColor+Skin.h"

@interface PFTextView ()< UITextViewDelegate >

@property ( nonatomic, strong, readonly ) UITextView* textView;
@property ( nonatomic, strong, readonly ) UILabel* placeholderLabel;
@property ( nonatomic, strong ) UIImageView* backgroundImageView;

@end

static CGFloat border_width_ = 2.f;

@implementation PFTextView

@synthesize textView = _textView;
@synthesize placeholderLabel = _placeholderLabel;
@synthesize delegate = _delegate;
@synthesize backgroundImageView = _backgroundImageView;

-(UITextView*)textView
{
   if ( !_textView )
   {
      CGRect text_view_rect_ = CGRectInset( self.bounds, 0.f, border_width_ );

      static CGFloat line_height_ = 17.f;
      CGFloat additional_space_ = 2 * line_height_;
      text_view_rect_.size.height += additional_space_;

      UITextView* text_view_ = [ [ UITextView alloc ] initWithFrame: text_view_rect_ ];
      text_view_.font = [ UIFont systemFontOfSize: line_height_ ];
      text_view_.textColor = [ UIColor mainTextColor ];
      text_view_.autocorrectionType = UITextAutocorrectionTypeNo;
      text_view_.autocapitalizationType = UITextAutocapitalizationTypeNone;
      text_view_.backgroundColor = [ UIColor clearColor ];
      text_view_.delegate = self;
      text_view_.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

      //Hide last empty line
      UIEdgeInsets content_inset_ = UIEdgeInsetsZero;
      content_inset_.bottom = additional_space_;
      text_view_.contentInset = content_inset_;
      text_view_.scrollIndicatorInsets = content_inset_;

      _textView = text_view_;
   }

   return _textView;
}

-(CGSize)contentSize
{
   CGSize text_view_size_ = self.textView.contentSize;
   text_view_size_.height = text_view_size_.height;
   return text_view_size_;
}

-(UILabel*)placeholderLabel
{
   if ( !_placeholderLabel )
   {
      CGFloat offset_ = 10.f;
      CGFloat height_ = 20.f;
      CGRect placeholder_rect_ = CGRectInset( self.bounds, offset_, offset_ + border_width_ );
      placeholder_rect_.size.height = height_;

      UILabel* placeholder_label_ = [ [ UILabel alloc ] initWithFrame: placeholder_rect_ ];
      placeholder_label_.textColor = [ UIColor colorWithWhite: 0.7f alpha: 1.f ];
      placeholder_label_.backgroundColor = [ UIColor clearColor ];
      placeholder_label_.autoresizingMask = UIViewAutoresizingFlexibleWidth;

      _placeholderLabel = placeholder_label_;
   }

   return _placeholderLabel;
}

-(void)awakeFromNib
{
   self.backgroundColor = [ UIColor clearColor ];

   self.backgroundImageView = [ [ UIImageView alloc ] initWithImage: [ UIImage textFieldBackground ] ];
   self.backgroundImageView.frame = self.bounds;
   self.backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
   [ self addSubview: self.backgroundImageView ];

   [ self addSubview: self.placeholderLabel ];
   [ self addSubview: self.textView ];

   self.clipsToBounds = YES;
}

-(UIImage*)background
{
   return self.backgroundImageView.image;
}

-(void)setBackground:( UIImage* )image_
{
   self.backgroundImageView.image = image_;
}

-(NSString*)text
{
   return self.textView.text;
}

-(void)setText:( NSString* )text_
{
   self.placeholderLabel.hidden = ( [ text_ length ] > 0 );
   self.textView.text = text_;
}

-(NSString*)placeholder
{
   return self.placeholderLabel.text;
}

-(void)setPlaceholder:( NSString* )placeholder_
{
   self.placeholderLabel.text = placeholder_;
}

-(void)textViewDidChange:( UITextView* )text_view_
{
   self.placeholderLabel.hidden = ( [ text_view_.text length ] > 0 );
   
   [ self.delegate textViewDidChange: text_view_ ];
}

-(void)forwardInvocation:( NSInvocation* )invocation_
{
   SEL selector_ = [ invocation_ selector ];
   
   if ( [ self.delegate respondsToSelector: selector_ ] )
   {
      [ invocation_ invokeWithTarget: self.delegate ];
   }
   else
   {
      [ self doesNotRecognizeSelector: selector_ ];
   }
}
      
-(BOOL)resignFirstResponder
{
   [ super resignFirstResponder ];
   return [ self.textView resignFirstResponder ];
}

-(UIEdgeInsets)contentInset
{
   return self.textView.contentInset;
}

-(void)setContentInset:( UIEdgeInsets )content_inset_
{
   self.textView.contentInset = content_inset_;
}

-(UIEdgeInsets)scrollIndicatorInsets
{
   return self.scrollIndicatorInsets;
}

-(void)setScrollIndicatorInsets:( UIEdgeInsets )scroll_indicator_insets_
{
   self.textView.scrollIndicatorInsets = scroll_indicator_insets_;
}

-(BOOL)bounces
{
   return self.textView.bounces;
}

-(void)setBounces:( BOOL )bounces_
{
   self.textView.bounces = bounces_;
}

@end
