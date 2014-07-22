#import <UIKit/UIKit.h>

typedef void (^PFGridActionBlock)( NSUInteger row_ );
typedef BOOL (^PFGridActionVisibilityBlock)( NSUInteger row_ );

@interface PFGridAction : NSObject

@property ( nonatomic, copy ) PFGridActionVisibilityBlock visibility;

+(id)actionWithTitle:( NSString* )title_
              action:( PFGridActionBlock )action_;

+(id)actionWithImage:( UIImage* )image_
    highlightedImage:( UIImage* )highlighted_image_
              action:( PFGridActionBlock )action_;

+(id)actionWithImage:( UIImage* )image_
    highlightedImage:( UIImage* )highlighted_image_
              action:( PFGridActionBlock )action_
     visibilityBlock:( PFGridActionVisibilityBlock )visibility_;

@end

@interface PFGridActionView : UIView

-(id)initWithActions:( NSArray* )actions_
                 row:( NSUInteger )row_
           fixedWith:( CGFloat )fixed_width_;

-(id)initWithActions:( NSArray* )actions_
                 row:( NSUInteger )row_
           fixedWith:( CGFloat )fixed_width_
       startFromZero:( BOOL )start_from_zero_;

@end
