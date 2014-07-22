#import "JFFAlertButton.h"

@implementation JFFAlertButton

@synthesize title;
@synthesize action;

-(id)initButton:( NSString* )title_ action:( JFFAlertBlock )action_
{
   self = [ super init ];

   if ( self )
   {
      self.title = title_;
      self.action = action_;
   }

   return self;
}

+(id)alertButton:( NSString* )title_ action:( JFFAlertBlock )action_
{
   return [ [ self alloc ] initButton: title_ action: action_ ];
}

-(NSString*)description
{
   return self.title;
}

@end
