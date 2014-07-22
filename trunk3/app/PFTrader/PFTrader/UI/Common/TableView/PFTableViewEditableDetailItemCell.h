#import "PFTableViewItemCell.h"

#import <UIKit/UIKit.h>

@interface PFTableViewEditableDetailItemCell : PFTableViewItemCell

@property ( nonatomic, strong ) IBOutlet UITextField* valueField;

-(IBAction)valueChangedAction:( id )sender_;

-(IBAction)exitAction:( id )sender_;

@end
