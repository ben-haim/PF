
#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioServices.h>

@interface XSoundPlayer : NSObject 
{ 
}
+ (void)Init;
+ (void)Deinit;
+ (void)PlayTock;
//+ (UInt32)SoundID;
//+ (void)setSoundID:(UInt32)val;
void MyAudioServicesSystemSoundCompletionProc (
                                               SystemSoundID  ssID,
                                               void           *clientData
                                               );
@end
