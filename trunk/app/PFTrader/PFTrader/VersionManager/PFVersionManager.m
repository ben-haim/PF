#import "PFVersionManager.h"

#import "PFBrandingSettings.h"
#import <JFFMessageBox/JFFMessageBox.h>

#define CURRENT_APP_VERSION [ [ [ NSBundle mainBundle ] infoDictionary ] objectForKey: (NSString*)kCFBundleVersionKey ]
#define APP_NAME            [ [ [ NSBundle mainBundle ] infoDictionary ] objectForKey: (NSString*)kCFBundleNameKey ]

@interface PFVersionManager ()

+(void)showAlertWithAppStoreVersion: (NSString*)appStore_version_;

@end

@implementation PFVersionManager

+(void)checkVersion
{
   NSMutableURLRequest* request_ = [ NSMutableURLRequest requestWithURL: [ NSURL URLWithString: [ NSString stringWithFormat: @"http://itunes.apple.com/lookup?id=%@"
                                                                                                 , [ PFBrandingSettings sharedBranding ].appID ] ] ];
   [ request_ setHTTPMethod: @"GET" ];
   
   NSOperationQueue* queue_ = [ [ NSOperationQueue alloc ] init ];
   
   [ NSURLConnection sendAsynchronousRequest: request_
                                       queue: queue_
                           completionHandler: ^( NSURLResponse* response, NSData* data, NSError* error )
    {
       if ( [ data length ] > 0 && !error )
       {
          NSDictionary* app_data_ = [ NSJSONSerialization JSONObjectWithData: data
                                                                     options: NSJSONReadingAllowFragments
                                                                       error: nil ];
          
          dispatch_async(dispatch_get_main_queue(),
                         ^{
                            NSArray *versions_in_store_ = [ [ app_data_ valueForKey: @"results" ] valueForKey: @"version" ];
                            
                            if ( [ versions_in_store_ count ] > 0 )
                            {
                               NSString* appStore_version_ = [ versions_in_store_ objectAtIndex: 0 ];
                               
                               NSArray* appStore_version_parts_ = [ appStore_version_ componentsSeparatedByString: @"."];
                               NSArray* current_version_parts_ = [ CURRENT_APP_VERSION componentsSeparatedByString: @"."];
                               
                               NSComparisonResult main_version_comparation = [ [ current_version_parts_ objectAtIndex: 0 ] compare: [ appStore_version_parts_ objectAtIndex: 0 ]
                                                                                                                           options: NSNumericSearch ];
                               
                               NSComparisonResult sub_version_comparation =  [ [ current_version_parts_ objectAtIndex: 1 ] compare: [ appStore_version_parts_ objectAtIndex: 1 ]
                                                                                                                           options: NSNumericSearch ];
                               
                               if ( main_version_comparation == NSOrderedAscending ||
                                   ( sub_version_comparation == NSOrderedAscending &&
                                    ( main_version_comparation == NSOrderedAscending
                                     || main_version_comparation == NSOrderedSame ) ) )
                               {
                                  [ PFVersionManager showAlertWithAppStoreVersion: appStore_version_ ];
                               }
                            }
                         });
       }
    } ];
}

+(void)showAlertWithAppStoreVersion: (NSString*)appStore_version_
{
   JFFAlertButton* update_button_ = [ JFFAlertButton alertButton: NSLocalizedString( @"UPDATE_APP", nil )
                                                          action: ^( JFFAlertView* sender_ )
                                     {
                                        [ [ UIApplication sharedApplication ] openURL: [ NSURL URLWithString: [ NSString stringWithFormat:
                                                                                                               @"https://itunes.apple.com/app/id%@"
                                                                                                               , [ PFBrandingSettings sharedBranding ].appID ] ] ];
                                     } ];
   
   JFFAlertView* alert_view_ = [ JFFAlertView alertWithTitle: nil
                                                     message: [ NSString stringWithFormat: @"A new version of %@ is available. Please update to version %@ now."
                                                               , APP_NAME
                                                               , appStore_version_ ]
                                           cancelButtonTitle: nil
                                           otherButtonTitles: update_button_, nil ];
   
   [ alert_view_ show ];
}

@end
