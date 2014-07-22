#import "PFActionSheetButton.h"

#import "UIImage+Skin.h"
#import "UIColor+Skin.h"

#import <JFFMessageBox/JFFMessageBox.h>

@interface PFActionSheetButton ()

@property ( nonatomic, strong ) UIButton* button;

@end

@implementation PFActionSheetButton

@synthesize presenterView;
@synthesize image = _image;
@synthesize title = _title;
@synthesize prompt;
@synthesize button;
@synthesize choices;
@synthesize currentChoice = _currentChoice;
@synthesize toStringBlock;
@synthesize toImageBlock;

-(void)setImage:( UIImage* )image_
{
   [ self.button setImage: image_ forState: UIControlStateNormal ];
   _image = image_;
}

-(void)setTitle:( NSString* )title_
{
   [ self.button setTitle: title_ forState: UIControlStateNormal ];
   _title = title_;
}

-(NSString*)actionTitleForChoice:( id )choice_
{
   if ( self.toStringBlock )
      return self.toStringBlock( choice_ );
   
   return [ choice_ description ];
}

-(NSString*)buttonTitleForChoice:( id )choice_
{
   if ( self.title )
      return self.title;

   if ( self.image )
      return nil;

   return [ self actionTitleForChoice: choice_ ];
}

-(UIImage*)buttonImageForChoice:( id )choice_
{
   if ( self.image )
      return self.image;
   
   if ( self.toImageBlock )
      return self.toImageBlock( choice_ );
   
   return nil;
}

-(void)choice
{
   NSMutableArray* choice_buttons_ = [ NSMutableArray arrayWithCapacity: [ self.choices count ] ];

   for ( id choice_ in self.choices )
   {
      [ choice_buttons_ addObject: [ JFFAlertButton alertButton: [ self actionTitleForChoice: choice_ ]
                                                         action: ^( JFFActionSheet* sender_ )
                                    {
                                       self.currentChoice = choice_;
                                    } ] ];
   }

   JFFActionSheet* action_sheet_ = [ JFFActionSheet actionSheetWithTitle: self.prompt
                                                       cancelButtonTitle: NSLocalizedString( @"CANCEL", nil )
                                                  destructiveButtonTitle: nil
                                                       otherButtonsArray: choice_buttons_ ];

   action_sheet_.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
   [ action_sheet_ showInView: self.presenterView ];
}

-(void)awakeFromNib
{
   self.button = [ UIButton buttonWithType: UIButtonTypeCustom ];
   [ self.button setBackgroundImage: [ UIImage textFieldBackground ] forState: UIControlStateNormal ];
   [ self.button setBackgroundImage: [ UIImage textFieldBackground ] forState: UIControlStateHighlighted ];
   [ self.button setTitleColor: [ UIColor mainTextColor ] forState: UIControlStateNormal ];
   [ self.button setTitleColor: [ UIColor mainTextColor ] forState: UIControlStateHighlighted ];
   self.button.titleLabel.font = [ UIFont systemFontOfSize: 14.f ];
   self.button.frame = self.bounds;
   self.button.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
   self.button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;

   [ self addSubview: self.button ];

   [ self.button addTarget: self
                    action: @selector( choice )
          forControlEvents: UIControlEventTouchUpInside ];
}

-(void)setCurrentChoice:( id )choice_
{
   if ( ![ choice_ isEqual: _currentChoice ] )
   {
      UIImage* image_ = [ self buttonImageForChoice: choice_ ];
      if ( image_ )
      {
         [ self.button setImage: image_ forState: UIControlStateNormal ];
      }
      else
      {
         [ self.button setTitle: [ self buttonTitleForChoice: choice_ ] forState: UIControlStateNormal ];
      }

      _currentChoice = choice_;
      [ self sendActionsForControlEvents: UIControlEventValueChanged ];
   }

   [ self sendActionsForControlEvents: UIControlEventEditingDidEnd ];
}

@end
