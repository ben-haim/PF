#import "PFGridActionView.h"

#import "PFGridCellButton.h"

#import "UIImage+PFGridView.h"

@interface PFGridAction ()

@property ( nonatomic, copy ) PFGridActionBlock action;

-(UIButton*)button;

@end

@interface PFGridImageAction : PFGridAction

@property ( nonatomic, strong ) UIImage* image;
@property ( nonatomic, strong ) UIImage* highlightedImage;

-(id)initWithImage:( UIImage* )image_
  highlightedImage:( UIImage* )highlighted_image_
            action:( PFGridActionBlock )action_;

@end

@interface PFGridTextAction : PFGridAction

@property ( nonatomic, strong ) NSString* title;

-(id)initWithTitle:( NSString* )title_
            action:( PFGridActionBlock )action_;

@end

/////////////////////////////////////////////////////////////////

@implementation PFGridAction

@synthesize action;
@synthesize visibility;

-(id)initWithAction:( PFGridActionBlock )action_
{
   self = [ super init ];
   if ( self )
   {
      self.action = action_;
   }
   return self;
}

+(id)actionWithTitle:( NSString* )title_
              action:( PFGridActionBlock )action_
{
   return [ [ PFGridTextAction alloc ] initWithTitle: title_
                                              action: action_ ];
}

+(id)actionWithImage:( UIImage* )image_
    highlightedImage:( UIImage* )highlighted_image_
              action:( PFGridActionBlock )action_
{
   return [ [ PFGridImageAction alloc ] initWithImage: image_
                                     highlightedImage: highlighted_image_
                                               action: action_ ];
}

+(id)actionWithImage:( UIImage* )image_
    highlightedImage:( UIImage* )highlighted_image_
              action:( PFGridActionBlock )action_
     visibilityBlock:( PFGridActionVisibilityBlock )visibility_
{
   PFGridImageAction* image_action_ = [ [ PFGridImageAction alloc ] initWithImage: image_
                                                                 highlightedImage: highlighted_image_
                                                                           action: action_ ];
   
   image_action_.visibility = visibility_;
   
   return image_action_;
}

-(void)performActionWithRow:( NSUInteger )row_
{
   if ( self.action )
   {
      self.action( row_ );
   }
}

-(UIButton*)button
{
   UIButton* button_ = [ PFGridCellButton gridButton ];
   return button_;
}

@end

/////////////////////////////////////////////////////////////////

@implementation PFGridImageAction

@synthesize image;
@synthesize highlightedImage;

-(id)initWithImage:( UIImage* )image_
  highlightedImage:( UIImage* )highlighted_image_
            action:( PFGridActionBlock )action_
{
   self = [ super initWithAction: action_ ];
   if ( self )
   {
      self.image = image_;
      self.highlightedImage = highlighted_image_;
   }
   return self;
}

-(UIButton*)button
{
   UIButton* button_ = [ super button ];
   [ button_ setImage: self.image forState: UIControlStateNormal ];
   [ button_ setImage: self.image forState: UIControlStateHighlighted ];
   return button_;
}

@end


/////////////////////////////////////////////////////////////////

@implementation PFGridTextAction

@synthesize title;

-(id)initWithTitle:( NSString* )title_
            action:( PFGridActionBlock )action_
{
   self = [ super initWithAction: action_ ];
   if ( self )
   {
      self.title = title_;
   }
   return self;
}

-(UIButton*)button
{
   UIButton* button_ = [ super button ];
   button_.titleLabel.textColor = [ UIColor whiteColor ];
   button_.titleLabel.lineBreakMode = NSLineBreakByClipping;
   [ button_ setTitle: self.title forState: UIControlStateNormal ];
   return button_;
}

@end

/////////////////////////////////////////////////////////////////

@interface PFGridActionHandler : NSObject

@property ( nonatomic, strong ) PFGridAction* action;
@property ( nonatomic, assign ) NSUInteger row;

+(id)handlerWithAction:( PFGridAction* )action_
                   row:( NSUInteger )row_;

@end

@implementation PFGridActionHandler

@synthesize action;
@synthesize row;

+(id)handlerWithAction:( PFGridAction* )action_
                   row:( NSUInteger )row_
{
   PFGridActionHandler* handler_ = [ self new ];
   handler_.action = action_;
   handler_.row = row_;
   return handler_;
}

-(void)touchAction
{
   [ self.action performActionWithRow: self.row ];
}

-(UIButton*)button
{
   UIButton* button_ = [ self.action button ];

   [ button_ addTarget: self
                action: @selector( touchAction )
      forControlEvents:  UIControlEventTouchUpInside ];

   return button_;
}

@end

/////////////////////////////////////////////////////////////////

@interface PFGridActionView ()

@property ( nonatomic, strong ) NSArray* handlers;

@end

@implementation PFGridActionView

@synthesize handlers;

-(id)initWithActions:( NSArray* )actions_
                 row:( NSUInteger )row_
           fixedWith:( CGFloat )fixed_width_
{
   static CGFloat default_height_ = 40.f;

   self = [ super initWithFrame: CGRectMake( 0.f, 0.f, 320.f, default_height_ ) ];
   if ( self )
   {
      CGRect fixed_rect_ = CGRectZero;
      CGRect actions_rect_ = CGRectZero;

      CGRectDivide( self.bounds
                   , &fixed_rect_
                   , &actions_rect_
                   , fixed_width_
                   , CGRectMinXEdge );

      UIScrollView* actions_scroll_view_ = [ [ UIScrollView alloc ] initWithFrame: actions_rect_ ];
      actions_scroll_view_.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
      actions_scroll_view_.showsHorizontalScrollIndicator = NO;

      CGFloat action_size_ = 30.f;
      CGFloat horyzontal_margin_ = 18.f;
      CGRect action_rect_ = CGRectMake( horyzontal_margin_ / 2.f
                                       , (default_height_ - action_size_) / 2.f
                                       , action_size_
                                       , action_size_ );

      NSMutableArray* handlers_ = [ NSMutableArray arrayWithCapacity: [ actions_ count ] ];

      for ( PFGridAction* action_ in actions_ )
      {
         if ( !action_.visibility || action_.visibility(row_) )
         {
            PFGridActionHandler* handler_ = [ PFGridActionHandler handlerWithAction: action_ row: row_ ];
            [ handlers_ addObject: handler_ ];
            
            UIButton* action_button_  = [ handler_ button ];
            action_button_.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
            action_button_.frame = action_rect_;
            [ actions_scroll_view_ addSubview: action_button_ ];
            action_rect_.origin.x = CGRectGetMaxX( action_rect_ ) + horyzontal_margin_;
         }
      }

      self.handlers = handlers_;

      actions_scroll_view_.contentSize = CGSizeMake( action_rect_.origin.x, default_height_ );
      [ self addSubview: actions_scroll_view_ ];

      static CGFloat arrow_shadow_size_ = 5.f;
      UIImageView* image_view_ = [ [ UIImageView alloc ] initWithImage: [ UIImage selectedCellFixedBackgroundImage ] ];
      fixed_rect_.size.width += arrow_shadow_size_;
      image_view_.frame = fixed_rect_;
      image_view_.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin;
      [ self addSubview: image_view_ ];
   
      UIImageView* overlay_image_view_ = [ [ UIImageView alloc ] initWithImage: [ UIImage selectedCellOverlayImage ] ];
      overlay_image_view_.frame = self.bounds;
      overlay_image_view_.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
      [ self addSubview: overlay_image_view_ ];

      UIImage* shadow_image_ = [ UIImage selectedCellShadowImage ];
      UIImageView* shadow_view_ = [ [ UIImageView alloc ] initWithImage: shadow_image_ ];
      shadow_view_.frame = CGRectMake( fixed_width_
                                      , self.bounds.size.height
                                      , self.bounds.size.width - fixed_width_
                                      , shadow_image_.size.height );
   
      shadow_view_.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
      [ self addSubview: shadow_view_ ];
   }

   return self;
}

@end
