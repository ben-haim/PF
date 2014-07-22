#import <Foundation/Foundation.h>

@interface ServerInfo : NSObject 

@property ( nonatomic, retain, readonly ) NSString *alias;
@property ( nonatomic, retain, readonly ) NSString *base_url;
@property ( nonatomic, retain, readonly ) NSString *backup_url;
@property ( nonatomic, assign, readonly ) BOOL demo;

+(id)infoWithAlias:( NSString* )alias_
           baseURL:( NSString* )base_url_
         backupURL:( NSString* )backup_url_
            isDemo:( BOOL )demo_;

@end
