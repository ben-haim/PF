#import "PFChatViewController.h"

#import "PFChatCell.h"

#import "PFTextView.h"
#import "PFLayoutManager.h"

#import "NSObject+KeyboardNotifications.h"
#import "UIColor+Skin.h"

#import "PFBrandingSettings.h"

#import <ProFinanceApi/ProFinanceApi.h>

#import <QuartzCore/QuartzCore.h>

@interface PFChatViewController () < PFSessionDelegate >

@end

@implementation PFChatViewController

@synthesize messageTextView;
@synthesize contentView;
@synthesize tableView;
@synthesize messagePanelView;
@synthesize sendButton;

-(void)dealloc
{
   self.tableView.delegate = nil;
   self.tableView.dataSource = nil;

   [ self unsubscribeKeyboardNotifications ];
   [ [ PFSession sharedSession ] removeDelegate: self ];
}

-(id)init
{
   self = [ super initWithNibName: NSStringFromClass( [ self class ] ) bundle: nil ];
   
   if ( self )
   {
      self.title = NSLocalizedString( @"CHAT", nil );
   }
   
   return self;
}

+(BOOL)isAvailable
{
   return [ PFBrandingSettings sharedBranding ].useChat && [ PFSession sharedSession ].allowsChat;
}

-(void)viewDidLoad
{
   [ super viewDidLoad ];

   [ self.sendButton setTitle: NSLocalizedString( @"SEND_BUTTON", nil ) forState: UIControlStateNormal ];
   
   [ [ PFSession sharedSession ] addDelegate: self ];
   self.messageTextView.bounces = NO;
   self.messagePanelView.backgroundColor = [ UIColor colorWithWhite: 0.6f alpha: 0.2f ];
   
   if ( [ PFLayoutManager currentLayoutManager ].shouldShrinkOnKeyboard )
   {
      [ self subscribeKeyboardNotifications ];
   }
}

-(void)viewWillAppear:( BOOL )animated_
{
   [ super viewWillAppear: animated_ ];
   
   if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
   {
      [ self setDarkNavigationBar ];
      self.view.backgroundColor = [ UIColor backgroundLightColor ];
   }
}

-(void)updateMessageFieldSize
{
   CGFloat min_height_ = 37.f;
   CGFloat max_height_ = 120.f;
   
   CGFloat current_height_ = self.messageTextView.bounds.size.height;
   CGFloat text_height_ = [ self.messageTextView.text length ] > 0
   ? self.messageTextView.contentSize.height
   : 0.f;

   CGFloat new_height_ = fmin( fmax( min_height_, text_height_ ), max_height_ );

   if ( current_height_ == new_height_ )
      return;
   
   CGRect table_rect_ = CGRectZero;
   CGRect panel_rect_ = CGRectZero;
   CGRectDivide( self.contentView.bounds
                , &panel_rect_
                , &table_rect_
                , self.messagePanelView.bounds.size.height + ( new_height_ - current_height_ )
                , CGRectMaxYEdge );
   
   self.tableView.frame = table_rect_;
   self.messagePanelView.frame = panel_rect_;
}

-(IBAction)sendAction:( id )sender_
{
   [ [ PFSession sharedSession ] sendChatMessageWithText: self.messageTextView.text ];
   self.messageTextView.text = nil;
   [ self updateMessageFieldSize ];
   [ self.messageTextView resignFirstResponder ];
}

-(void)session:( PFSession* )session_
didLoadChatMessage:( id< PFChatMessage > )message_
{
   NSIndexPath* reload_index_path_ = [ NSIndexPath indexPathForRow: [ self.messages indexOfObject: message_ ]
                                                         inSection: 0 ];

   NSArray* index_pathes_ = @[reload_index_path_];

   [ self.tableView insertRowsAtIndexPaths: index_pathes_
                          withRowAnimation: UITableViewRowAnimationLeft ];


   [ self.tableView scrollToRowAtIndexPath: reload_index_path_
                          atScrollPosition: UITableViewScrollPositionMiddle
                                  animated: YES ];
}

-(void)changeContentViewFrame:( CGRect )new_frame_
            animationDuration:( NSTimeInterval )duration_
{
   [ UIView beginAnimations: nil context: nil ];
   [ UIView setAnimationBeginsFromCurrentState: YES ];
   [ UIView setAnimationDuration: duration_ ];
   self.contentView.frame = new_frame_;
   [ UIView commitAnimations ];
}

-(void)willHideKeyboardWithDuration:( NSTimeInterval )duration_
{
   [ self changeContentViewFrame: self.view.bounds
               animationDuration: duration_ ];
}

-(void)willShowKeyboardWithHeight:( CGFloat )height_
                           inRect:( CGRect )rect_
                         duration:( NSTimeInterval )duration_
{
   CGRect content_rect_  = self.view.bounds;
   content_rect_.size.height -= height_ - ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 65.f : 0.f );

   [ self changeContentViewFrame: content_rect_
               animationDuration: duration_ ];
}

-(BOOL)textFieldShouldReturn:( UITextField* )text_field_
{
   [ text_field_ resignFirstResponder ];
   return YES;
}

-(NSArray*)messages
{
   return [ PFSession sharedSession ].chat.messages;
}

-(NSInteger)tableView:( UITableView* )table_view_ numberOfRowsInSection:( NSInteger )section_
{
   return [ self.messages count ];
}

-(UITableViewCell*)tableView:(UITableView *)table_view_
       cellForRowAtIndexPath:( NSIndexPath* )index_path_
{
   static NSString* cell_identifier_ = @"PFChatCell";

   PFChatCell* cell_ = (PFChatCell*)[ table_view_ dequeueReusableCellWithIdentifier: cell_identifier_ ];

   if ( !cell_ )
   {
      cell_ = [ PFChatCell cell ];
   }

   cell_.message = (self.messages)[index_path_.row];

   return cell_;
}

-(CGFloat)tableView:( UITableView* )table_view_ heightForRowAtIndexPath:(NSIndexPath *)index_path_
{
   return [ PFChatCell cellHeightForMessage: (self.messages)[index_path_.row]
                                   forWidth: table_view_.bounds.size.width ];
}

#pragma mark UITextViewDelegate

-(void)textViewDidChange:( UITextView* )text_view_
{
   [ self updateMessageFieldSize ];
}

@end
