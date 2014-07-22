#import "NSObject+KeyboardNotifications.h"

@implementation NSObject (KeyboardNotifications)

-(void)didHideKeyboard
{
   //do nothing
}

-(void)didShowKeyboardWithHeight:( CGFloat )height_ inRect:( CGRect )rect_
{
   //do nothing
}

-(void)notification:( NSNotification* )notification_
            getRect:( CGRect* )keyboard_rect_
          getHeight:( CGFloat* )height_
{
   NSValue* bounds_ = [ notification_ userInfo ][UIKeyboardFrameEndUserInfoKey];
   *keyboard_rect_ = [ bounds_ CGRectValue ];
   *height_ = fmin( keyboard_rect_->size.height, keyboard_rect_->size.width );
}

-(void)didShowKeyboardWithNotification:( NSNotification* )notification_
{
   CGRect keyboard_rect_ = CGRectZero;
   CGFloat height_ = 0.f;

   [ self notification: notification_
               getRect: &keyboard_rect_
             getHeight: &height_ ];

   [ self didShowKeyboardWithHeight: height_ inRect: keyboard_rect_ ];
}

-(void)willHideKeyboardWithDuration:( NSTimeInterval )duration_
{
   //do nothing
}

-(void)willHideKeyboardWithNotification:( NSNotification* )notification_
{
   [ self willHideKeyboardWithDuration: [ (notification_.userInfo)[UIKeyboardAnimationDurationUserInfoKey] doubleValue ] ];
}

-(void)willShowKeyboardWithHeight:( CGFloat )height_
                           inRect:( CGRect )rect_
                         duration:( NSTimeInterval )duration_
{
   //do nothing
}

-(void)willShowKeyboardWithNotification:( NSNotification* )notification_
{
   CGRect keyboard_rect_ = CGRectZero;
   CGFloat height_ = 0.f;
   
   [ self notification: notification_
               getRect: &keyboard_rect_
             getHeight: &height_ ];

   [ self willShowKeyboardWithHeight: height_
                              inRect: keyboard_rect_
                            duration: [ (notification_.userInfo)[UIKeyboardAnimationDurationUserInfoKey] doubleValue ] ];
}


-(void)subscribeKeyboardNotifications
{
   [ [ NSNotificationCenter defaultCenter ] addObserver: self
                                               selector: @selector( didShowKeyboardWithNotification: )
                                                   name: UIKeyboardDidShowNotification
                                                 object: nil ];

   [ [ NSNotificationCenter defaultCenter ] addObserver: self
                                               selector: @selector( didHideKeyboard )
                                                   name: UIKeyboardDidHideNotification
                                                 object: nil ];

   [ [ NSNotificationCenter defaultCenter ] addObserver: self
                                               selector: @selector( willShowKeyboardWithNotification: )
                                                   name: UIKeyboardWillShowNotification
                                                 object: nil ];
   
   [ [ NSNotificationCenter defaultCenter ] addObserver: self
                                               selector: @selector( willHideKeyboardWithNotification: )
                                                   name: UIKeyboardWillHideNotification
                                                 object: nil ];
}

-(void)unsubscribeKeyboardNotifications
{
   [ [ NSNotificationCenter defaultCenter ] removeObserver: self
                                                      name: UIKeyboardDidShowNotification
                                                    object: nil ];

   [ [ NSNotificationCenter defaultCenter ] removeObserver: self
                                                      name: UIKeyboardDidHideNotification
                                                    object: nil ];

   [ [ NSNotificationCenter defaultCenter ] removeObserver: self
                                                      name: UIKeyboardWillShowNotification
                                                    object: nil ];

   [ [ NSNotificationCenter defaultCenter ] removeObserver: self
                                                      name: UIKeyboardWillHideNotification
                                                    object: nil ];
}

@end
