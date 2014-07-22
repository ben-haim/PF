
#import "XSoundPlayer.h"
#import "SoundEngine.h"


@implementation XSoundPlayer
static UInt32 TockSoundID = 0;
static bool isPlaying = false;


+ (void)Init 
{        
    NSString *pathe=[[NSBundle mainBundle] pathForResource:@"Tock" ofType:@"wav"];
    CFURLRef url =(CFURLRef)[NSURL fileURLWithPath:pathe];
    AudioServicesCreateSystemSoundID(url,&TockSoundID);
    
    AudioServicesAddSystemSoundCompletion (TockSoundID,
                                           NULL,
                                           NULL,
                                           MyAudioServicesSystemSoundCompletionProc,
                                           NULL
                                           );
    
    //Load sounds
    //Setup sound engine. Run  it at 44Khz to match the sound files
    
   /* const char* fileName = [[[NSBundle mainBundle] pathForResource:@"Tock" 
                                                            ofType:@"wav"] UTF8String];
    SoundEngine_LoadEffect(fileName, &TockSoundID);*/
}

+ (void)Deinit
{
    //SoundEngine_UnloadEffect(TockSoundID);
    AudioServicesRemoveSystemSoundCompletion (TockSoundID);
    AudioServicesDisposeSystemSoundID(TockSoundID);
}


+ (void)PlayTock
{
    //SoundEngine_StartEffect( TockSoundID);   
    //if(isPlaying)
    //    return;
    isPlaying = true;
    AudioServicesPlaySystemSound(TockSoundID);
}
void MyAudioServicesSystemSoundCompletionProc (
                                               SystemSoundID  ssID,
                                               void           *clientData
                                               )
{
    isPlaying = false;
}
/*+ (UInt32)SoundID
{
    return SoundID;
}
+ (void)setSoundID:(UInt32)val
{
    SoundID = val;
}*/
@end
