#include "JFFAlertBlock.h"

#import <UIKit/UIKit.h>

@interface JFFAlertView : NSObject

@property ( nonatomic, copy ) JFFAlertBlock didPresentHandler;
@property ( nonatomic, assign ) UIAlertViewStyle alertViewStyle;

//cancelButtonTitle, otherButtonTitles - pass NSString(button title) or JFFAlertButton
+(id)alertWithTitle:( NSString* )title_
            message:( NSString* )message_
  cancelButtonTitle:( id )cancel_button_title_
  otherButtonTitles:( id )other_button_titles_, ...;

//pass NSString(button title) or JFFAlertButton
-(void)addAlertButton:( id )alert_button_;
-(void)addAlertButtonWithTitle:( NSString* )title_ action:( JFFAlertBlock )action_;

+(void)showAlertWithTitle:( NSString* )title_
              description:( NSString* )description_;

-(void)show;

-(UITextField*)textFieldAtIndex:( NSInteger )index_;

@end
