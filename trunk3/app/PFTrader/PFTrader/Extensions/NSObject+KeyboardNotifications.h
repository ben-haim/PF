#import <Foundation/Foundation.h>

@interface NSObject (KeyboardNotifications)

-(void)subscribeKeyboardNotifications;
-(void)unsubscribeKeyboardNotifications;

-(void)didHideKeyboard;
-(void)didShowKeyboardWithHeight:( CGFloat )height_ inRect:( CGRect )rect_;

@end
