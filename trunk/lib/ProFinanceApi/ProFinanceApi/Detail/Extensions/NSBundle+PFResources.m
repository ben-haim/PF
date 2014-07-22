#import "NSBundle+PFResources.h"

NSString* PFLocalizedString( NSString* key_, NSString* comment_ )
{
   return [ NSBundle PFStringForKey: key_ value: nil ];
}

@implementation NSBundle (PFResources)

+(NSBundle*)PFResourcesBundle
{
   static NSString* const bundle_name_ = @"PFResources";

   NSBundle* bundle_ = [ NSBundle bundleWithPath: [ [ NSBundle mainBundle ] pathForResource: bundle_name_
                                                                                     ofType: @"bundle"  ] ];

   NSAssert1( bundle_
             , @"Can't find '%@' bundle inside Main Bundle. Check that it was added to 'Copy Bundle Resources' build phase."
             , bundle_name_ );
   
   return bundle_;
}

+(NSString*)PFStringForKey:( NSString* )key_ value:( NSString* )value_
{
   return [ [ self PFResourcesBundle ] localizedStringForKey: key_
                                                       value: value_
                                                       table: @"PFResources" ];
}


@end
