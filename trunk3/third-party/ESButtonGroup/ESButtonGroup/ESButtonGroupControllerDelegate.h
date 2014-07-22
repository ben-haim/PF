#import <Foundation/Foundation.h>

@class ESButtonGroupController;
@class ESSelectableButton;
@class UIButton;

@protocol ESButtonGroupControllerDelegate< NSObject >

-(void)groupController:( ESButtonGroupController* )group_controller_
  didChangeButtonState:( ESSelectableButton* )button_;

@optional

-(BOOL)groupController:( ESButtonGroupController* )group_controller_
disableButtonSelection:( UIButton* )button_;

-(void)groupController:( ESButtonGroupController* )group_controller_
        didClickButton:( ESSelectableButton* )button_;

@end

@interface NSObject (ESButtonGroupControllerDelegate)

@end
