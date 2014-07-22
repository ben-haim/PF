#import "ESSelectableButtonDelegate.h"

#import <UIKit/UIKit.h>

@class ESSelectableButton;

@protocol ESButtonGroupControllerDelegate;

@interface ESButtonGroupController : NSObject< ESSelectableButtonDelegate >

@property ( nonatomic, retain ) IBOutlet UIView* view;
@property ( nonatomic, assign ) IBOutlet id< ESButtonGroupControllerDelegate > delegate;
@property ( nonatomic, retain ) NSArray* buttons;

@property ( nonatomic, retain ) NSSet* activeIndexes;

@property ( nonatomic, assign ) BOOL allowsMultipleSelection;

-(void)setActiveIndex:( NSInteger )active_index_;
-(void)setTitle:( NSString* )title_ forButtonAtIndex:( NSUInteger )index_;

-(ESSelectableButton*)buttonAtIndex:( NSUInteger )index_;
-(NSInteger)indexOfButton:( UIButton* )button_;

@end
