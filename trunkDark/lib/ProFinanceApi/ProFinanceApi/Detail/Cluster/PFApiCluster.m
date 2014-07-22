#import "PFApiCluster.h"

#import "PFApi.h"
#import "PFServerInfo.h"

@interface PFApiCluster ()

@property ( nonatomic, strong ) NSMutableArray* mutableApis;
@property ( nonatomic, assign ) NSUInteger transferFinishedCount;

@end

@implementation PFApiCluster

@synthesize mutableApis = _mutableApis;
@synthesize transferFinishedCount;

-(NSMutableArray*)mutableApis
{
   if ( !_mutableApis )
   {
      _mutableApis = [ NSMutableArray new ];
   }
   return _mutableApis;
}

-(BOOL)transferFinished
{
   return self.transferFinishedCount == [ self.mutableApis count ];
}

-(NSArray*)apis
{
   return self.mutableApis;
}

+(id)clusterWithApis:( NSArray* )apis_
{
   PFApiCluster* cluster_ = [ self new ];
   cluster_.mutableApis = [ apis_ mutableCopy ];
   return cluster_;
}

-(void)addApi:( PFApi* )api_
{
   [ self.mutableApis addObject: api_ ];
}

-(void)removeApi:( PFApi* )api_
{
   [ self.mutableApis removeObject: api_ ];
}

-(PFApi*)apiWithServer:( NSString* )server_
{
   for ( PFApi* api_ in self.mutableApis )
   {
      if ( [ api_.serverInfo.activeServer isEqualToString: server_ ] )
      {
         return api_;
      }
   }

   return nil;
}

-(void)transferFinishedApi:( PFApi* )api_
{
   self.transferFinishedCount += 1;
}

-(NSString*)description
{
   return [ NSString stringWithFormat: @"count: %lu, transferFinishedCount:%lud, transferFinished: %d"
           , (unsigned long)[ self.mutableApis count ]
           , (unsigned long)self.transferFinishedCount
           , self.transferFinished ];
}

@end
