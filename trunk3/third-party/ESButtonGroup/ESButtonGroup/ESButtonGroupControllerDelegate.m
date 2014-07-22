#import "ESButtonGroupControllerDelegate.h"

@implementation NSObject (ESButtonGroupControllerDelegate)

-(BOOL)groupController:( ESButtonGroupController* )group_controller_
disableButtonSelection:( UIButton* )button_
{
   return NO;
}

-(void)groupController:( ESButtonGroupController* )group_controller_
        didClickButton:( ESSelectableButton* )button_
{
}

@end
