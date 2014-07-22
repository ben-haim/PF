#import "PFSoundManager.h"

#import "PFSettings.h"

#import <AudioToolbox/AudioServices.h>

typedef enum
{
   PFSoundTypeWelcome
   , PFSoundTypeOrderCreated
   , PFSoundTypeOrderFilled
   , PFSoundTypeOrderCancelled
   , PFSoundTypeOrderReplaced
   , PFSoundTypeOrderRejected
   , PFSoundTypePositionClosed
   , PFSoundTypeChatIn
   , PFSoundTypeChatOut
   , PFSoundTypeConfirmationPopup
   , PFSoundTypeNegativePopup
   , PFSoundTypeNews
   , PFSoundTypeMarginWarning
   , PFSoundTypeMainPeriod
} PFSoundType;

static UInt32 PFSoundTypeWelcomeID = 0;
static UInt32 PFSoundTypeOrderCreatedID = 0;
static UInt32 PFSoundTypeOrderFilledID = 0;
static UInt32 PFSoundTypeOrderCancelledID = 0;
static UInt32 PFSoundTypeOrderReplacedID = 0;
static UInt32 PFSoundTypeOrderRejectedID = 0;
static UInt32 PFSoundTypePositionClosedID = 0;
static UInt32 PFSoundTypeChatInID = 0;
static UInt32 PFSoundTypeChatOutID = 0;
static UInt32 PFSoundTypeConfirmationPopupID = 0;
static UInt32 PFSoundTypeNegativePopupID = 0;
static UInt32 PFSoundTypeNewsID = 0;
static UInt32 PFSoundTypeMarginWarningID = 0;
static UInt32 PFSoundTypeMainPeriodID = 0;

static BOOL isPlaying = NO;

static void MyAudioServicesSystemSoundCompletionProc( SystemSoundID  ssID, void *clientData )
{
   isPlaying = NO;
}

static void createSystemSounds()
{
   AudioServicesCreateSystemSoundID( ( __bridge CFURLRef )[ NSURL fileURLWithPath: [ [ NSBundle mainBundle ] pathForResource: @"PFWelcome" ofType: @"wav" ] ]
                                    , &PFSoundTypeWelcomeID );
   AudioServicesAddSystemSoundCompletion( PFSoundTypeWelcomeID, NULL, NULL, MyAudioServicesSystemSoundCompletionProc, NULL );
   
   AudioServicesCreateSystemSoundID( ( __bridge CFURLRef )[ NSURL fileURLWithPath: [ [ NSBundle mainBundle ] pathForResource: @"PFOrderCreated" ofType: @"wav" ] ]
                                    , &PFSoundTypeOrderCreatedID );
   AudioServicesAddSystemSoundCompletion( PFSoundTypeOrderCreatedID, NULL, NULL, MyAudioServicesSystemSoundCompletionProc, NULL );
   
   AudioServicesCreateSystemSoundID( ( __bridge CFURLRef )[ NSURL fileURLWithPath: [ [ NSBundle mainBundle ] pathForResource: @"PFOrderFilled" ofType: @"wav" ] ]
                                    , &PFSoundTypeOrderFilledID );
   AudioServicesAddSystemSoundCompletion(PFSoundTypeOrderFilledID, NULL, NULL, MyAudioServicesSystemSoundCompletionProc, NULL );
   
   AudioServicesCreateSystemSoundID( ( __bridge CFURLRef )[ NSURL fileURLWithPath: [ [ NSBundle mainBundle ] pathForResource: @"PFOrderCancelled" ofType: @"wav" ] ]
                                    , &PFSoundTypeOrderCancelledID );
   AudioServicesAddSystemSoundCompletion( PFSoundTypeOrderCancelledID, NULL, NULL, MyAudioServicesSystemSoundCompletionProc, NULL );
   
   AudioServicesCreateSystemSoundID( ( __bridge CFURLRef )[ NSURL fileURLWithPath: [ [ NSBundle mainBundle ] pathForResource: @"PFOrderReplaced" ofType: @"wav" ] ]
                                    , &PFSoundTypeOrderReplacedID );
   AudioServicesAddSystemSoundCompletion( PFSoundTypeOrderReplacedID, NULL, NULL, MyAudioServicesSystemSoundCompletionProc, NULL );
   
   AudioServicesCreateSystemSoundID( ( __bridge CFURLRef )[ NSURL fileURLWithPath: [ [ NSBundle mainBundle ] pathForResource: @"PFOrderRejected" ofType: @"wav" ] ]
                                    , &PFSoundTypeOrderRejectedID );
   AudioServicesAddSystemSoundCompletion( PFSoundTypeOrderRejectedID, NULL, NULL, MyAudioServicesSystemSoundCompletionProc, NULL );
   
   AudioServicesCreateSystemSoundID( ( __bridge CFURLRef )[ NSURL fileURLWithPath: [ [ NSBundle mainBundle ] pathForResource: @"PFPositionClosed" ofType: @"wav" ] ]
                                    , &PFSoundTypePositionClosedID );
   AudioServicesAddSystemSoundCompletion( PFSoundTypePositionClosedID, NULL, NULL, MyAudioServicesSystemSoundCompletionProc, NULL );
   
   AudioServicesCreateSystemSoundID( ( __bridge CFURLRef )[ NSURL fileURLWithPath: [ [ NSBundle mainBundle ] pathForResource: @"PFChatIn" ofType: @"wav" ] ]
                                    , &PFSoundTypeChatInID );
   AudioServicesAddSystemSoundCompletion( PFSoundTypeChatInID, NULL, NULL, MyAudioServicesSystemSoundCompletionProc, NULL );
   
   AudioServicesCreateSystemSoundID( ( __bridge CFURLRef )[ NSURL fileURLWithPath: [ [ NSBundle mainBundle ] pathForResource: @"PFChatOut" ofType: @"wav" ] ]
                                    , &PFSoundTypeChatOutID );
   AudioServicesAddSystemSoundCompletion( PFSoundTypeChatOutID, NULL, NULL, MyAudioServicesSystemSoundCompletionProc, NULL );
   
   AudioServicesCreateSystemSoundID( ( __bridge CFURLRef )[ NSURL fileURLWithPath: [ [ NSBundle mainBundle ] pathForResource: @"PFConfirmationPopup" ofType: @"wav" ] ]
                                    , &PFSoundTypeConfirmationPopupID );
   AudioServicesAddSystemSoundCompletion( PFSoundTypeConfirmationPopupID, NULL, NULL, MyAudioServicesSystemSoundCompletionProc, NULL );
   
   AudioServicesCreateSystemSoundID( ( __bridge CFURLRef )[ NSURL fileURLWithPath: [ [ NSBundle mainBundle ] pathForResource: @"PFNegativePopup" ofType: @"wav" ] ]
                                    , &PFSoundTypeNegativePopupID );
   AudioServicesAddSystemSoundCompletion( PFSoundTypeNegativePopupID, NULL, NULL, MyAudioServicesSystemSoundCompletionProc, NULL );
   
   AudioServicesCreateSystemSoundID( ( __bridge CFURLRef )[ NSURL fileURLWithPath: [ [ NSBundle mainBundle ] pathForResource: @"PFNews" ofType: @"wav" ] ]
                                    , &PFSoundTypeNewsID );
   AudioServicesAddSystemSoundCompletion( PFSoundTypeNewsID, NULL, NULL, MyAudioServicesSystemSoundCompletionProc, NULL );
   
   AudioServicesCreateSystemSoundID( ( __bridge CFURLRef )[ NSURL fileURLWithPath: [ [ NSBundle mainBundle ] pathForResource: @"PFMarginWarning" ofType: @"wav" ] ]
                                    , &PFSoundTypeMarginWarningID );
   AudioServicesAddSystemSoundCompletion( PFSoundTypeMarginWarningID, NULL, NULL, MyAudioServicesSystemSoundCompletionProc, NULL );
   
   AudioServicesCreateSystemSoundID( ( __bridge CFURLRef )[ NSURL fileURLWithPath: [ [ NSBundle mainBundle ] pathForResource: @"PFMainSessionStart" ofType: @"wav" ] ]
                                    , &PFSoundTypeMainPeriodID );
   AudioServicesAddSystemSoundCompletion( PFSoundTypeMainPeriodID, NULL, NULL, MyAudioServicesSystemSoundCompletionProc, NULL );
}

static void destroySystemSounds()
{
   AudioServicesRemoveSystemSoundCompletion( PFSoundTypeWelcomeID );
   AudioServicesDisposeSystemSoundID( PFSoundTypeWelcomeID );
   
   AudioServicesRemoveSystemSoundCompletion( PFSoundTypeOrderCreatedID );
   AudioServicesDisposeSystemSoundID( PFSoundTypeOrderCreatedID );
   
   AudioServicesRemoveSystemSoundCompletion( PFSoundTypeOrderFilledID );
   AudioServicesDisposeSystemSoundID( PFSoundTypeOrderFilledID );
   
   AudioServicesRemoveSystemSoundCompletion( PFSoundTypeOrderCancelledID );
   AudioServicesDisposeSystemSoundID( PFSoundTypeOrderCancelledID );
   
   AudioServicesRemoveSystemSoundCompletion( PFSoundTypeOrderReplacedID );
   AudioServicesDisposeSystemSoundID( PFSoundTypeOrderReplacedID );
   
   AudioServicesRemoveSystemSoundCompletion( PFSoundTypeOrderRejectedID );
   AudioServicesDisposeSystemSoundID( PFSoundTypeOrderRejectedID );
   
   AudioServicesRemoveSystemSoundCompletion( PFSoundTypePositionClosedID );
   AudioServicesDisposeSystemSoundID( PFSoundTypePositionClosedID );
   
   AudioServicesRemoveSystemSoundCompletion( PFSoundTypeChatInID );
   AudioServicesDisposeSystemSoundID( PFSoundTypeChatInID );
   
   AudioServicesRemoveSystemSoundCompletion( PFSoundTypeChatOutID );
   AudioServicesDisposeSystemSoundID( PFSoundTypeChatOutID );
   
   AudioServicesRemoveSystemSoundCompletion( PFSoundTypeConfirmationPopupID );
   AudioServicesDisposeSystemSoundID( PFSoundTypeConfirmationPopupID );
   
   AudioServicesRemoveSystemSoundCompletion( PFSoundTypeNegativePopupID );
   AudioServicesDisposeSystemSoundID( PFSoundTypeNegativePopupID );
   
   AudioServicesRemoveSystemSoundCompletion( PFSoundTypeNewsID );
   AudioServicesDisposeSystemSoundID( PFSoundTypeNewsID );
   
   AudioServicesRemoveSystemSoundCompletion( PFSoundTypeMarginWarningID );
   AudioServicesDisposeSystemSoundID( PFSoundTypeMarginWarningID );
   
   AudioServicesRemoveSystemSoundCompletion( PFSoundTypeMainPeriodID );
   AudioServicesDisposeSystemSoundID( PFSoundTypeMainPeriodID );
}

static void playSoundWithType( PFSoundType sound_type_ )
{
   if( !isPlaying )
   {
      isPlaying = YES;
      UInt32 current_sound_id_ = 0;
      
      switch ( sound_type_ )
      {
         case PFSoundTypeWelcome:
            current_sound_id_ = PFSoundTypeWelcomeID;
            break;
            
         case PFSoundTypeOrderCreated:
            current_sound_id_ = PFSoundTypeOrderCreatedID;
            break;
            
         case PFSoundTypeOrderFilled:
            current_sound_id_ = PFSoundTypeOrderFilledID;
            break;
            
         case PFSoundTypeOrderCancelled:
            current_sound_id_ = PFSoundTypeOrderCancelledID;
            break;
            
         case PFSoundTypeOrderReplaced:
            current_sound_id_ = PFSoundTypeOrderReplacedID;
            break;
            
         case PFSoundTypeOrderRejected:
            current_sound_id_ = PFSoundTypeOrderRejectedID;
            break;
            
         case PFSoundTypePositionClosed:
            current_sound_id_ = PFSoundTypePositionClosedID;
            break;
            
         case PFSoundTypeChatIn:
            current_sound_id_ = PFSoundTypeChatInID;
            break;
            
         case PFSoundTypeChatOut:
            current_sound_id_ = PFSoundTypeChatOutID;
            break;
            
         case PFSoundTypeConfirmationPopup:
            current_sound_id_ = PFSoundTypeConfirmationPopupID;
            break;
            
         case PFSoundTypeNegativePopup:
            current_sound_id_ = PFSoundTypeNegativePopupID;
            break;
            
         case PFSoundTypeNews:
            current_sound_id_ = PFSoundTypeNewsID;
            break;
            
         case PFSoundTypeMarginWarning:
            current_sound_id_ = PFSoundTypeMarginWarningID;
            break;
            
         case PFSoundTypeMainPeriod:
            current_sound_id_ = PFSoundTypeMainPeriodID;
            break;
      }
      
      AudioServicesPlaySystemSound( current_sound_id_ );
   }
}

@interface PFSoundManager ()

-(void)playSoundWithType:( PFSoundType )sound_type_;

@end

@implementation PFSoundManager

+(PFSoundManager*)sharedManager
{
   static PFSoundManager* manager_ = nil;
   if ( !manager_ )
   {
      manager_ = [ [ PFSoundManager alloc ] init ];
      createSystemSounds();
   }
   return manager_;
}

+(void)destroySharedManager
{
   destroySystemSounds();
}

-(void)playSoundWithType:( PFSoundType )sound_type_
{
   if ( [ PFSettings sharedSettings ].playSounds )
   {
      playSoundWithType( sound_type_ );
   }
}

-(void)playConfirmationSound
{
   [ self playSoundWithType: PFSoundTypeConfirmationPopup ];
}

-(void)playNegativeSound
{
   [ self playSoundWithType: PFSoundTypeNegativePopup ];
}

#pragma mark - PFSessionDelegate

-(void)didClientLaunchedSession:( PFSession* )session_
{
   [ [ PFSoundManager sharedManager ] playSoundWithType: PFSoundTypeWelcome ];
}

-(void)session:( PFSession* )session_
didRemovePosition:( id< PFPosition > )position_
{
   [ [ PFSoundManager sharedManager ] playSoundWithType: PFSoundTypePositionClosed ];
}

-(void)session:( PFSession* )session_
   didAddOrder:( id< PFOrder > )order_
{
   [ [ PFSoundManager sharedManager ] playSoundWithType: PFSoundTypeOrderCreated ];
}

-(void)session:( PFSession* )session_
didRemoveOrder:( id< PFOrder > )order_
{
   [ [ PFSoundManager sharedManager ] playSoundWithType: PFSoundTypeOrderCancelled ];
}

-(void)session:( PFSession* )session_
didLoadStories:( NSArray* )stories_
{
   [ [ PFSoundManager sharedManager ] playSoundWithType: PFSoundTypeNews ];
}

-(void)session:( PFSession* )session_
didLoadChatMessage:( id< PFChatMessage > )message_
{
   [ [ PFSoundManager sharedManager ] playSoundWithType: message_.senderId != session_.user.userId ? PFSoundTypeChatIn : PFSoundTypeChatOut ];
}

-(void)session:( PFSession* )session_
didReceiveErrorMessage:( NSString* )message_
{
   [ [ PFSoundManager sharedManager ] playSoundWithType: PFSoundTypeOrderRejected ];
}

-(void)session:( PFSession* )session_
 didLoadReport:( id< PFReportTable > )report_
{
   if ( [ report_.name rangeOfString: @"margin" options: NSCaseInsensitiveSearch ].location != NSNotFound )
   {
      [ [ PFSoundManager sharedManager ] playSoundWithType: PFSoundTypeMarginWarning ];
   }
}

-(void)didStartMainPeriodInTradeSessionContainer:( id< PFTradeSessionContainer > )trade_session_container_
{
   [ [ PFSoundManager sharedManager ] playSoundWithType: PFSoundTypeMainPeriod ];
}

@end
