#import "ServerInfo.h"

@interface ServerInfo ()

@property ( nonatomic, retain ) NSString *alias;
@property ( nonatomic, retain ) NSString *base_url;
@property ( nonatomic, retain ) NSString *backup_url;
@property ( nonatomic, assign ) BOOL demo;

@end

@implementation ServerInfo

@synthesize alias = _alias;
@synthesize base_url = _base_url;
@synthesize backup_url = _backup_url;
@synthesize demo;

+(id)infoWithAlias:( NSString* )alias_
           baseURL:( NSString* )base_url_
         backupURL:( NSString* )backup_url_
            isDemo:( BOOL )demo_
{
   ServerInfo* info_ = [ ServerInfo new ];
   info_.alias = alias_;
   info_.base_url = base_url_;
   info_.backup_url = backup_url_;
   info_.demo = demo_;
   return [ info_ autorelease ];
}

-(void)dealloc
{
   [ _alias release ];
   [ _base_url release ];
   [ _backup_url release ];

   [ super dealloc ];
}

-(NSString* )description
{
	return self.alias;
}

@end
