#import "PFTableViewItemCell.h"

@interface PFTableViewDecimalPadCell : PFTableViewItemCell

@property (strong, nonatomic) IBOutlet UITextField* valueField;

-(IBAction)valueChangedAction:( id )sender_;

@end
