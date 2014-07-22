#import "PFChat.h"

@interface PFChat ()

@property ( nonatomic, strong ) NSMutableArray* mutableMessages;

@end

@implementation PFChat

@synthesize mutableMessages = _mutableMessages;

-(NSMutableArray*)mutableMessages
{
   if ( !_mutableMessages )
   {
      _mutableMessages = [ NSMutableArray new ];
   }
   return _mutableMessages;
}

-(NSArray*)messages
{
   return self.mutableMessages;
}

-(void)addMessage:( PFChatMessage* )message_
{
   [ self.mutableMessages addObject: message_ ];
}

@end
