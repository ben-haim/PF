#import <Foundation/Foundation.h>

extern NSString* PFLocalizedString( NSString* key_, NSString* comment_ );

@interface NSBundle (PFResources)

+(NSBundle*)PFResourcesBundle;

+(NSString*)PFStringForKey:( NSString* )key_ value:( NSString* )value_;

@end
