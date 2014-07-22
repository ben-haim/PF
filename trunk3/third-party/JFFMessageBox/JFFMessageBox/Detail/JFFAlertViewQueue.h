#import <UIKit/UIKit.h>

@protocol JFFBaseAlertView;

typedef void (^JFFAlertViewShowCallback)( id< JFFBaseAlertView > );

@interface JFFAlertViewQueue : NSObject

-(void)addAlert:( id< JFFBaseAlertView > )alert_view_
   showCallback:( JFFAlertViewShowCallback )show_callback_;

-(void)showOrAddAlert:( id< JFFBaseAlertView > )alert_view_
         showCallback:( JFFAlertViewShowCallback )show_callback_;

-(void)removeAlert:( id< JFFBaseAlertView > )alert_view_;
-(void)dismissAll;

-(void)showTopAlertView;

-(NSUInteger)count;

@end
