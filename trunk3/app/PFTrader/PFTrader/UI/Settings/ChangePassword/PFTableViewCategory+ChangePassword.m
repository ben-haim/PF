#import "PFTableViewCategory+ChangePassword.h"

#import "PFTableViewDetailItem.h"

@implementation PFTableViewCategory (ChangePassword)

+(NSArray*)changePasswordCategories
{
   PFTableViewEditableDetailItem* old_password_item_ = [ PFTableViewEditableDetailItem itemWithAction: nil
                                                                                                title: NSLocalizedString( @"OLD_PASSWORD", nil ) ];
   old_password_item_.secureTextEntry = YES;
   
   id old_category_ = [ self categoryWithTitle: nil  items: [ NSArray arrayWithObject: old_password_item_ ] ];
   
   
   PFTableViewEditableDetailItem* new_password_item_ = [ PFTableViewEditableDetailItem itemWithAction: nil
                                                                                                title: NSLocalizedString( @"NEW_PASSWORD", nil ) ];
   new_password_item_.secureTextEntry = YES;
   
   PFTableViewEditableDetailItem* confirm_password_item_ = [ PFTableViewEditableDetailItem itemWithAction: nil
                                                                                                    title: NSLocalizedString( @"CONFIRM_PASSWORD", nil ) ];
   confirm_password_item_.secureTextEntry = YES;
   
   id new_category_ = [ self categoryWithTitle: nil  items: [ NSArray arrayWithObjects: new_password_item_
                                                             , confirm_password_item_
                                                             , nil ] ];
   
   return [ NSArray arrayWithObjects: old_category_
           , new_category_
           , nil ];
}

@end
