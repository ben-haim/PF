#import "JFFAlertView.h"

#import "JFFBaseAlertView.h"

#import "JFFAlertButton.h"
#import "NSObject+JFFAlertButton.h"

#import "JFFAlertViewQueue.h"

@interface JFFAlertView () < UIAlertViewDelegate, JFFBaseAlertView >

@property ( nonatomic, strong ) UIAlertView* alertView;
@property ( nonatomic, strong ) NSMutableArray* alertButtons;

-(void)forceShow;

@end

@implementation JFFAlertView

@synthesize alertView;
@synthesize alertButtons;
@synthesize didPresentHandler;

+(JFFAlertViewQueue*)sharedQueue
{
   static JFFAlertViewQueue* queue_ = nil;
   if ( !queue_ )
   {
      queue_ = [ JFFAlertViewQueue new ];
   }
   return queue_;
}

-(void)dealloc
{
   self.alertView.delegate = nil;
}

-(void)handleButtonWithIndex:( NSInteger )button_index_
{
   JFFAlertButton* alert_button_ = (self.alertButtons)[button_index_];
   if ( alert_button_ )
      alert_button_.action( self );
}

-(void)dismissWithClickedButtonIndex:( NSInteger )button_index_ animated:( BOOL )animated_
{
   BOOL is_visible_ = self.alertView.isVisible;
   [ self.alertView dismissWithClickedButtonIndex: button_index_ animated: NO ];
   if ( !is_visible_ )
   {
      [ self alertView: self.alertView didDismissWithButtonIndex: button_index_ ];
   }
   [ self handleButtonWithIndex: button_index_ ];
}

-(void)forceDismiss
{
   [ self dismissWithClickedButtonIndex: self.alertView.cancelButtonIndex animated: NO ];
}

+(void)showAlertWithTitle:( NSString* )title_
              description:( NSString* )description_
{
   JFFAlertView* alert_ = [ JFFAlertView alertWithTitle: title_
                                                message: description_
                                      cancelButtonTitle: NSLocalizedString( @"OK", nil )
                                      otherButtonTitles: nil ];

   [ alert_ show ];
}

-(id)initWithTitle:( NSString* )title_
           message:( NSString* )message_
 cancelButtonTitle:( NSString* )cancel_button_title_
otherButtonTitlesArray:( NSArray* )other_button_titles_
{
   self = [ super init ];
   if ( !self )
      return nil;

   self.alertView = [ [ UIAlertView alloc ] initWithTitle: title_
                                                  message: message_ 
                                                 delegate: self
                                        cancelButtonTitle: cancel_button_title_
                                        otherButtonTitles: nil, nil ];

   for ( NSString* button_title_ in other_button_titles_ )
   {
      [ self.alertView addButtonWithTitle: button_title_ ];
   }

   return self;
}

-(NSInteger)addAlertButtonWithIndex:( id )button_
{
   JFFAlertButton* alert_button_ = [ button_ toAlertButton ];
   NSInteger index_ = [ self.alertView addButtonWithTitle: alert_button_.title ];
   [ self.alertButtons insertObject: alert_button_ atIndex: index_ ];
   return index_;
}

-(void)addAlertButton:( id )button_
{
   [ self addAlertButtonWithIndex: button_ ];
}

-(void)addAlertButtonWithTitle:( NSString* )title_ action:( JFFAlertBlock )action_
{
   [ self addAlertButton: [ JFFAlertButton alertButton: title_ action: action_ ] ];
}

-(NSInteger)addButtonWithTitle:( NSString* )title_
{
   return [ self addAlertButtonWithIndex: title_ ];
}

+(id)alertWithTitle:( NSString* )title_
            message:( NSString* )message_
  cancelButtonTitle:( id )cancel_button_title_
  otherButtonTitles:( id )other_button_titles_, ...
{
   NSMutableArray* other_alert_buttons_ = [ NSMutableArray array ];
   NSMutableArray* other_alert_string_titles_ = [ NSMutableArray array ];

   va_list args;
   va_start( args, other_button_titles_ );
   for ( NSString* button_title_ = other_button_titles_; button_title_ != nil; button_title_ = va_arg( args, NSString* ) )
   {
      JFFAlertButton* alert_button_ = [ button_title_ toAlertButton ];
      [ other_alert_buttons_ addObject: alert_button_ ];
      [ other_alert_string_titles_ addObject: alert_button_.title ];
   }
   va_end( args );

   JFFAlertButton* cancel_button_ = [ cancel_button_title_ toAlertButton ];
   if ( cancel_button_ )
   {
      [ other_alert_buttons_ insertObject: cancel_button_ atIndex: 0 ];
   }

   JFFAlertView* alert_view_ = [ [ self alloc ] initWithTitle: title_
                                                       message: message_
                                             cancelButtonTitle: cancel_button_.title
                                        otherButtonTitlesArray: other_alert_string_titles_ ];

   alert_view_.alertButtons = other_alert_buttons_;

   return alert_view_;
}

-(void)show
{
   [ [ [ self class ] sharedQueue ] showOrAddAlert: self
                                      showCallback:
    ^( id< JFFBaseAlertView > alert_view_ )
    {
       [ ( JFFAlertView* )alert_view_ forceShow ];
    } ];
}

-(void)forceShow
{
   [ self.alertView show ];
}

#pragma mark UIAlertViewDelegate

-(void)alertView:( UIAlertView* )alert_view_ clickedButtonAtIndex:( NSInteger )button_index_
{
   [ self handleButtonWithIndex: button_index_ ];
}

-(void)didPresentAlertView:( UIAlertView* )alertView_
{
   if ( self.didPresentHandler )
      self.didPresentHandler( self );
}

-(void)alertView:( UIAlertView* )alert_view_ didDismissWithButtonIndex:( NSInteger )buttonIndex_
{
   JFFAlertViewQueue* queue_ = [ [ self class ] sharedQueue ];

   [ queue_ removeAlert: self ];
   [ queue_ showTopAlertView ];
}

#pragma mark UIAlertView forwards

-(UIAlertViewStyle)alertViewStyle
{
   return self.alertView.alertViewStyle;
}

-(void)setAlertViewStyle:( UIAlertViewStyle )style_
{
   self.alertView.alertViewStyle = style_;
}

-(UITextField*)textFieldAtIndex:( NSInteger )index_
{
   return [ self.alertView textFieldAtIndex: index_ ];
}
@end
