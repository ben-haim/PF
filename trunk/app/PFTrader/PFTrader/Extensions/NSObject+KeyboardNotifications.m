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
   NSValue* bounds_ = [ [ notification_ userInfo ] objectForKey: UIKeyboardFrameEndUserInfoKey ];
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
   [ self willHideKeyboardWithDuration: [ [ notification_.userInfo objectForKey: UIKeyboardAnimationDurationUserInfoKey ] doubleValue ] ];
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
                            duration: [ [ notification_.userInfo objectForKey: UIKeyboardAnimationDurationUserInfoKey ] doubleValue ] ];
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

#pragma mark CGRect Utility function
-(CGRect)rectSwap:( CGRect )rect_
{
    CGRect new_rect_;

    new_rect_.origin.x = rect_.origin.y;
    new_rect_.origin.y = rect_.origin.x;
    new_rect_.size.width = rect_.size.height;
    new_rect_.size.height = rect_.size.width;

    return new_rect_;
}

-(CGRect)fixOriginRotationWithRect:( CGRect ) rect_
                       Orientation:( UIInterfaceOrientation ) orientation_
                       ParentWidth:( int )parent_width_
                      ParentHeight:( int )parent_height_
{
    CGRect new_rect_;

    switch(orientation_)
    {
        case UIInterfaceOrientationLandscapeLeft:
            new_rect_ = CGRectMake(parent_width_ - (rect_.size.width + rect_.origin.x), rect_.origin.y, rect_.size.width, rect_.size.height);
            break;
        case UIInterfaceOrientationLandscapeRight:
            new_rect_ = CGRectMake(rect_.origin.x, parent_height_ - (rect_.size.height + rect_.origin.y), rect_.size.width, rect_.size.height);
            break;
        case UIInterfaceOrientationPortrait:
            new_rect_ = rect_;
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            new_rect_ = CGRectMake(parent_width_ - (rect_.size.width + rect_.origin.x), parent_height_ - (rect_.size.height + rect_.origin.y), rect_.size.width, rect_.size.height);
            break;
    }

    return new_rect_;
}

@end
