#import <Foundation/Foundation.h>

@interface NSObject (KeyboardNotifications)

-(void)subscribeKeyboardNotifications;
-(void)unsubscribeKeyboardNotifications;

-(void)didHideKeyboard;
-(void)didShowKeyboardWithHeight:( CGFloat )height_ inRect:( CGRect )rect_;

-(CGRect)rectSwap:( CGRect )rect_;
-(CGRect)fixOriginRotationWithRect:( CGRect ) rect_
                       Orientation:( UIInterfaceOrientation ) orientation_
                       ParentWidth:( int )parent_width_
                      ParentHeight:( int )parent_height_;

@end
