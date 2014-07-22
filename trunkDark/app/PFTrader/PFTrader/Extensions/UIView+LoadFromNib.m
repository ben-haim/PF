#import "UIView+LoadFromNib.h"

@implementation UIView (LoadFromNib)

+(id)viewAsFirstObjectFromNibNamed:( NSString* )nib_name_
                             owner:( id )owner_
{
   return [ [ NSBundle mainBundle ] loadNibNamed: nib_name_
                                             owner: owner_
                                           options: nil ][0];
}

+(id)viewAsFirstObjectFromNibNamed:( NSString* )nib_name_
{
   return [ self viewAsFirstObjectFromNibNamed: nib_name_ 
                                         owner: nil ];
}

+(id)viewAsFileOwnerFromNibNamed:( NSString* )nib_name_
{
   UIView* view_ = [ [ self alloc ] initWithFrame: CGRectMake( 0.f, 0.f, 100.f, 100.f ) ];

   [ [ NSBundle mainBundle ] loadNibNamed: nib_name_
                                    owner: view_
                                  options: nil ];

   return view_;
}

@end
